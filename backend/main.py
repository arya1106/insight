from flask import Flask, request, jsonify
import os
import psycopg2
import base64
from codecs import encode, decode
import json
from ultralytics import YOLO
import requests

CLASS_MAPPINGS={0: "long_crack", 1: "trans_crack", 2: "aligator_crack", 3: "pothole"}

conn = psycopg2.connect(os.environ["DATABASE_URL"], dbname="OSMP")

app = Flask(__name__)

def predict(imageSource):
    model = YOLO("../ML/train4/weights/best.pt")
    outList = []

    results = model.predict(source=imageSource, save=True)
    print(imageSource)
    if results:    
        boxCords = results[0].boxes.xyxy
        classes = results[0].boxes.cls

        for index, element in enumerate(boxCords):
            out = {}
            out["boxCords"] = boxCords[index].tolist()
            out["damageType"] = classes[index].item()
            outList.append(out)

    return outList

def getStreetImages(point, radius):
    lat = point[0]
    long = point[1]
    getImgURL = f"https://api.openstreetcam.org/2.0/photo/?lat={lat}&lng={long}&join=sequence&radius={radius}"
    response = requests.get(url=getImgURL)
    jsonDict = response.json()

    outList = []
    for i in jsonDict['result']['data']:
        data = {}
        data["imageURL"] = i["fileurlLTh"]
        data["location"] = [i["lat"], i["lng"]]

    return outList

@app.route('/report', methods = ["GET", "POST"])
def report():
    if request.method == "POST":
        with conn.cursor() as curr:    
            curr.execute("select * from osmp_schema.damage_nodes")
            res = len(curr.fetchall()) + 1            
            # crack_type = 1 if request.headers.get("cracktype") == "horizontal crack" else 2
            #latitude = float(request.headers.get("latitude"))
           # longitude = float(request.headers.get("longitude"))
           # image_str = request.form.get('image')
           # print(res, crack_type, latitude, longitude)
            #print(request.get_data()) 
            #new_img_str = decode(image_str, "utf-8")
            request.files.get("imageUploads").save("test.jpeg")

            # testing decoding of image string
           # with open("imageToSave.jpeg", "wb") as fh:
            #    fh.write(base64.decodebytes(new_img_str))

            # curr.execute(f"insert into osmp_schema.damage_nodes values ({res}, ST_SetSRID(ST_MakePoint({longitude}, {latitude}), 4326), {crack_type}, '{image_str}', 2)")
            conn.commit()


    return "hi"


if __name__ == "__main__":
    app.run(host= "0.0.0.0", debug=True)
