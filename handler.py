import ctypes
import json
import os
import time, datetime
import logging
logging.getLogger().setLevel(logging.INFO)

# load R shared libraries from lib dir
for file in os.listdir('lib'):
    if os.path.isfile(os.path.join('lib', file)):
        ctypes.cdll.LoadLibrary(os.path.join('lib', file))

# set R environment variables
os.environ["R_HOME"] = os.getcwd()
os.environ["R_LIBS"] = os.path.join(os.getcwd(), 'site-library')

import rpy2
from rpy2 import robjects
from rpy2.robjects import r

import warnings
from rpy2.rinterface import RRuntimeWarning
warnings.filterwarnings("ignore", category=RRuntimeWarning)

def predict(event_body):
    r('library(jsonlite)')
    r('library(exampleModel)')

    # assign variables in R
    py_dict = str(event_body)
    r.assign('json_df', py_dict)

    logging.info('[API] Calling R Prediction')
    r("""
    req <- fromJSON(paste(json_df, collapse = ""))
    res <- get_prediction(req)
    res_json = toJSON(res, pretty=TRUE)
    """)
    logging.info('[API] R Prediction returned.')
    results = robjects.r['res_json']
    return str(results)

def lambda_handler(event, context):
    if event.get('body'):
        logging.info("[API] " + str(json.dumps(event['resource'])))
        logging.info("[API] " + str(json.dumps(event['requestContext'])))
        logging.info("[API] " + str(json.dumps(event['body'])))
        event_body = event['body']
        event = json.loads(event_body)
    try:
        pred_list = predict(event_body)
        res = {}
        logging.info("[API] " + json.dumps(pred_list))
        res['headers'] = { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" }
        res['body'] = pred_list
        res['statusCode'] = 200
        return res
    except rpy2.rinterface.RRuntimeError, e:
        logging.error('Payload: {0}'.format(event))
        logging.error('Error: {0}'.format(e.message))
        error = {}
        error['errorType'] = 'PredictionsError'
        error['httpStatus'] = 400
        error['request_id'] = context.aws_request_id
        error['message'] = e.message.replace('\n', ' ') # convert multi-line message into single line
        raise Exception(json.dumps(error))
