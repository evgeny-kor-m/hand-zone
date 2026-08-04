import random
import time
from flask import Flask, jsonify

app = Flask(__name__)

SENSORS = [f"sensor_{i}" for i in range(50)]

def get_active_sensors():
    random.seed(int(time.time() / 30))
    count = random.randint(3, 15)
    return random.sample(SENSORS, count)

@app.route('/inventory')
def inventory():
    sensors = get_active_sensors()
    return jsonify(sensors)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=1337)
