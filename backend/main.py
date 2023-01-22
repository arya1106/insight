from flask import Flask, request, jsonify
from flask_cors import CORS, cross_origin
import os
import psycopg2
import base64
from codecs import encode, decode
import json
from ultralytics import YOLO
import requests
import cv2
import urllib.request
import numpy as np

CLASS_MAPPINGS={0: "long_crack", 1: "trans_crack", 2: "aligator_crack", 3: "pothole"}

conn = psycopg2.connect(os.environ["DATABASE_URL"], dbname="OSMP")

app = Flask(__name__)
CORS(app, resources={r"*": {"origins": "*"}})

def predict(imageSource):
    model = YOLO("../ML/train4/weights/best.pt")
    outDict = {}

    results = model.predict(source=imageSource, verbose=False)
    print(imageSource)
    if results:    
        boxCords = results[0].boxes.xyxy
        classes = results[0].boxes.cls

        url_response = urllib.request.urlopen(imageSource)
        img = cv2.imdecode(np.array(bytearray(url_response.read()), dtype=np.uint8), -1)
        imgAnnotated = img.copy()

        for index, element in enumerate(boxCords):
            out = {}
            out["boxCords"] = boxCords[index].tolist()
            out["damageType"] = classes[index].item()
            x1 = boxCords[index][0]
            y1 = boxCords[index][1]
            x2 = boxCords[index][2]
            y2 = boxCords[index][3]
            imgAnnotated = cv2.rectangle(imgAnnotated, (int(x1), int(y1)), (int(x2), int(y2)), (0, 255, 0), 2)
            imgAnnotated = cv2.putText(imgAnnotated, CLASS_MAPPINGS[int(classes[index].item())], (x1, y1-10), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (0,255,0), 2)
        
        imgBytes = cv2.imencode('.jpg', imgAnnotated)[1].tobytes()
        encodedImg = base64.b64encode(imgBytes)
        asciiImg = encodedImg.decode('ascii')
        outDict["image"] = asciiImg
        outDict["damageType"] = CLASS_MAPPINGS[int(classes[0].item())]
    return outDict

def getStreetImages(point, radius):
    lat = point[0]
    long = point[1]
    getImgURL = f"https://api.openstreetcam.org/2.0/photo/?lat={lat}&lng={long}&join=sequence&radius={radius}"
    response = requests.get(url=getImgURL)
    jsonDict = response.json()

    outList = []
    if "result" in jsonDict:
        for i in jsonDict['result']['data']:
            data = {}
            data["imageURL"] = i["fileurlLTh"]
            data["location"] = [i["lat"], i["lng"]]
            outList.append(data)

    return outList

@app.route('/report', methods = ["GET", "POST"])
def report():
    if request.method == "POST":
        with conn.cursor() as curr:    
            curr.execute("select * from osmp_schema.damage_nodes")
            res = len(curr.fetchall()) + 1            
            crack_type = 1 if request.headers.get("cracktype") == "horizontal crack" else 2
            latitude = float(request.headers.get("latitude"))
            longitude = float(request.headers.get("longitude"))
            content = request.files.get("imageUploads").read()
            print(type(content))
            cmd = "insert into osmp_schema.damage_nodes values (%d, ST_SetSRID(ST_MakePoint(%15.10f, %15.10f), 4326), %d, 2, %s)" % (res, longitude, latitude, crack_type, content)
            curr.execute(cmd)
            conn.commit()
    return "hi"

@app.route('/query', methods = ["GET", "POST"])
@cross_origin()
def query():
    if request.method == "POST":
        response = {}
        response["markers"] = []
        data = request.get_json()
        point = data["location"]
        point[0] = float(point[0])
        point[1] = float(point[1])
        radius = int(data["radius"])
        streetImages = getStreetImages(point, radius)
        predictions = []
        for image in streetImages:
            marker = {}
            pred = predict(imageSource=image["imageURL"])
            if len(pred) > 0:
                predictions.append(pred)
                marker["location"] = image["location"]
                marker["damageType"] = pred["damageType"]
                marker["dataSource"] = 1
                marker["image"] = pred["image"]
                response["markers"].append(marker)
        with conn.cursor() as curr:
            curr.execute("select * from osmp_schema.damage_nodes where ST_DistanceSphere(location, ST_MakePoint(%15.10f, %15.10f)) <= %d" % (point[1], point[0], radius))
            res = curr.fetchall() 
            curr.execute("select ST_X(location), ST_Y(location) from osmp_schema.damage_nodes where ST_DistanceSphere(location, ST_MakePoint(%15.10f, %15.10f)) <= %d" % (point[1], point[0], radius))
            location_res = curr.fetchall()
            for i in range(len(res)):
                marker = {}
                marker["location"] = [location_res[i][1], location_res[i][0]]
                marker["damageType"] = res[i][2]
                marker["dataSource"] = 2
                encoded = base64.b64encode(res[i][4].tobytes())
                marker["image"] = encoded.decode('ascii')
                response["markers"].append(marker)

    return json.dumps(response, indent=2) 

@app.route('/')
def home():
    return app.send_static_file("../index.html")

if __name__ == "__main__":
    app.run(host= "0.0.0.0", debug=True)
