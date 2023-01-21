from ultralytics import YOLO

CLASS_MAPPINGS={0: "long_crack", 1: "trans_crack", 2: "aligator_crack", 3: "pothole"}

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

if __name__ == "__main__":
    predict()

