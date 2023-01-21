from flask import Flask, request, jsonify
import os
import psycopg2

conn = psycopg2.connect(os.environ["DATABASE_URL"])

app = Flask(__name__)

@app.route('/report', methods = ["GET", "POST"])
def report():
    if request.method == "POST":
        print(request.headers)
        print(request.form)
        print(request.data)
        with conn.cursor() as curr:
            curr.execute("")

    return "hi"


if __name__ == "__main__":
    app.run(host= "0.0.0.0", debug=True)
