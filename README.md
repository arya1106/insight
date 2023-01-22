# Insight

<p align="center">
[![Demo Video](https://img.youtube.com/vi/zqdhXTJrVrk/0.jpg)](https://youtu.be/zqdhXTJrVrk)
</p>

**Every time you stumble across a small crack in the road, that’s the beginning of something very dangerous.** They develop into potholes, causing damage to vehicles and fatal car accidents. It often takes years to fix these defects, leading to even more traffic, pollution, and new cracks forming. It's important to address these issues early to prevent a downward spiral. In fact, research has shown that approximately 1/3rd of traffic accidents involve poor road conditions. This, is what we aim to solve.

**Introducing Insight**, a cutting-edge technology solution that uses machine learning to identify and map dangerous cracks on the road. Our mission is to make roads safer for drivers by providing them with real-time information about the condition of the roads they travel on.

Through our mobile app, we make it easy for anyone to take a picture of any defects they see on the road and upload it to our database. Our machine learning model also analyzes open-source street images and data and adds them to our map, creating a comprehensive and up-to-date view of the condition of the roads in a particular region. Our iOS app written in Swift is supported with a custom REST API with methods that permit the flow of data throughout our entire pipeline.

On our website, users can select a region and see all the labeled & reported cracks, flagged on the map with colored markers. This information can be used by municipalities, road maintenance companies, and transportation departments to prioritize repairs and ensure that the roads are safe for drivers. Our web app is supported by a Flask server running on a Digital Ocean droplet and Cockroach DB. We retrained YOLO-v8, a popular state-of-the-art object detection machine learning model, on our custom database combining data from academic publications, Google StreetView, and Open Street Cam. To improve model performance we referenced previous works in Computer Vision in the transportation sector, annotating relevant features with additional information, such as damage type. This is how we detect and locate dangerous road cracks.

**Insight** is not only a tool for road safety, but it's also a tool for community engagement and citizen science. By encouraging people to report road defects, we are creating a sense of shared responsibility for road safety and empowering people to take action to improve the roads in their community. Of course, one may have concerns about uploading location data, but all reports are anonymous to protect users’ privacy.

Insight has the potential to make a significant impact on road safety, and we are excited to continue developing and improving our technology.

