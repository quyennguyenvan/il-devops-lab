import json
from botocore.compat import accepts_kwargs
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
        
    AWSCredentialService.awsConfig()
    ssmService = SSMService.ssmService()
    dbInfo = ssmService.GetDBParameters()

    dbContext = DBContextService.dbContextService()
    dbName = dbInfo[0]['Value']
    host = dbInfo[1]['Value'].split(':')[0]
    dbIndentifier = dbInfo[2]['Value']
    password = dbInfo[3]['Value']
    username = dbInfo[4]['Value']
    dbContext.connectionDBCredential = {
        "hostname": host,
        "identifier": dbName,
        "username": username,
        "password": password
    }
    return {"data": json.dumps("DB Info: {0}. DB Connection info: {1}".format(dbContext.getDBInfor(),dbInfo))}

if __name__ == '__main__':
    #load the config
    appConfig = json.load(open("Config.json"))
    Configs.config.override(appConfig)
    app.run(host='0.0.0.0', debug=False)

   
