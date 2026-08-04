import json
import os
import requests
from flask import Flask, Response


app = Flask(__name__)
host = os.getenv("inventory_ser_host")
# host = "http://localhost:1337/inventory"

def get_active_sensors():

    response = requests.get(host)
    print(response.status_code)                 # Output: 200 (Success)
    print(f"response: {response.json()}")       # Output: JSON response from the server

    obj=[]

    message = {}
    message['targets'] = response.json()

    labels={}
    labels['env'] = "production"

    message['labels'] = labels

    obj.append(message)

    return json.dumps(obj)

@app.route('/inventory')
def inventory():
    response = get_active_sensors()
    return Response(response, status=200, mimetype='application/json')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=9100)