from flask import Flask, request, jsonify
import os
import psycopg2
import base64
from codecs import encode

conn = psycopg2.connect(os.environ["DATABASE_URL"], dbname="OSMP")

app = Flask(__name__)

@app.route('/report', methods = ["GET", "POST"])
def report():
    if request.method == "POST":
        with conn.cursor() as curr:    
            curr.execute("select * from osmp_schema.damage_nodes")
            res = len(curr.fetchall()) + 1            
            crack_type = 1 if request.headers.get("cracktype") == "horizontal crack" else 2
            latitude = float(request.headers.get("latitude"))
            longitude = float(request.headers.get("longitude"))
            image_str = request.form.get('image')
            print(res, crack_type, latitude, longitude)
            
            new_img_str = encode(image_str, "utf-8")

            # testing decoding of image string
            with open("imageToSave.jpeg", "wb") as fh:
                fh.write(base64.decodebytes(new_img_str))

            # curr.execute(f"insert into osmp_schema.damage_nodes values ({res}, ST_SetSRID(ST_MakePoint({longitude}, {latitude}), 4326), {crack_type}, '{image_str}', 2)")
            conn.commit()


    return "hi"


if __name__ == "__main__":
    app.run(host= "0.0.0.0", debug=True)
