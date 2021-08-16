import json
from botocore.config import Config
import logging

from Containers.containers import Configs,AWSCredentialService,SSMService,DBContextService

from flask import Flask, request
from flask_cors import CORS

logging.basicConfig(format='%(asctime)s %(process)d %(levelname)s %(name)s %(message)s', level=logging.INFO,filename="log.txt")
logger = logging.getLogger(__name__)
logger.info('Logger init ... OK')

app = Flask(__name__)
cors = CORS(app, resources={r"/v1/*": {"origins": "*"}})

@app.route('/v1/info', methods=['GET','POST'])
def getDBCredential():
        
    awsService = AWSCredentialService.awsConfig()
    ssmService = SSMService.ssmService()
    dbInfo = ssmService.GetDBParameters()

    dbContext = DBContextService.dbContextService()
    dbContext.connectionDBCredential = {
        "hostname": dbInfo[0]['Value'],
        "identifier": dbInfo[1]['Value'],
        "username": dbInfo[3]['Value'],
        "password": dbInfo[2]['Value']
    }
    return json.dumps("DB Info: {0}. DB Connection info: {1}".format(dbContext.getDBInfor(),dbInfo))

if __name__ == '__main__':
    #load the config
    appConfig = json.load(open("Config.json"))
    Configs.config.override(appConfig)
    app.run(host='0.0.0.0', debug=True)

   
