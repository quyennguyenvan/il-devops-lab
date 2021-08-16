from os import name
from Helpers.AWSSesion import AWS_Session


class SSM(object):
    def __init__(self,config,awsCredential):
        self.config = config
        self.awsCredential = awsCredential

    def GetDBParameters(self):
        awsClient = self.awsCredential.Get_Credentials()
        ssmRequest = awsClient.client('ssm', self.config['AWS']['Region'])
        listParametes = ssmRequest.describe_parameters()['Parameters']

        parametesResult = []

        for item in listParametes:
            value = ssmRequest.get_parameter(Name = item['Name'],WithDecryption=False)['Parameter']['Value']
            parametesResult.append({
                "Name": item['Name'],
                "Value": value
            })
        return parametesResult