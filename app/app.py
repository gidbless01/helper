from flask import Flask, request
import logging
from pythonjsonlogger import jsonlogger
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST
import time
import random


app = Flask(__name__)


# JSON structured logging
logger = logging.getLogger('demo_app')
logHandler = logging.StreamHandler()
formatter = jsonlogger.JsonFormatter('%(asctime)s %(levelname)s %(name)s %(message)s %(request_id)s')
logHandler.setFormatter(formatter)
logger.addHandler(logHandler)
logger.setLevel(logging.INFO)


# Prometheus metric
REQUESTS = Counter('http_requests_total', 'Total HTTP requests', ['endpoint', 'method', 'status'])


@app.route('/')
def index():
request_id = str(int(time.time()*1000)) + str(random.randint(1000,9999))
try:
# simulate work
time.sleep(random.uniform(0.01, 0.2))
logger.info('handling index', extra={'request_id': request_id, 'endpoint': '/'})
REQUESTS.labels(endpoint='/', method='GET', status='200').inc()
return 'Hello from demo app', 200
except Exception as e:
logger.exception('index failed', extra={'request_id': request_id})
REQUESTS.labels(endpoint='/', method='GET', status='500').inc()
return 'error', 500


@app.route('/metrics')
def metrics():
return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}


if __name__ == '__main__':
app.run(host='0.0.0.0', port=5000)