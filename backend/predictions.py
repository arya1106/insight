from ultralytics import YOLO
import sys
import json

CLASS_MAPPINGS={0: "long_crack", 1: "trans_crack", 2: "aligator_crack", 3: "pothole"}

def predict():
    model = YOLO("best.pt")
    outList = []

    results = model.predict(source=sys.argv[1])
    if results:    
        boxCords = results[0].boxes.xyxy
        classes = results[0].boxes.cls

        for index, element in enumerate(boxCords):
            out = {}
            out["boxCords"] = boxCords[index].tolist()
            out["damageType"] = classes[index].item()
            outList.append(out)

    outDict = {"damages": outList}
    jsonString = json.dumps(outDict)
    print(jsonString)

