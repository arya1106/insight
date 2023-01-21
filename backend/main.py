from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/report', methods = ["GET", "POST"])
def report():
    if request.method == "POST":
        print(request.headers)
    
    return "hi"


if __name__ == "__main__":
    app.run(host= "0.0.0.0", debug=True)