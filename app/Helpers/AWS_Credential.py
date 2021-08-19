from botocore import config
from Helpers.AWSSesion import AWS_Session
import os 
import logging

class AWSCredential(object):
    def __init__(self,config):
        self.config = config

    def Get_Credentials(self):
        awsClient = AWS_Session(self.config['AWS']['KeyID'],self.config['AWS']['KeySecret'])
        awsClient.get_credentials()
        return awsClient

    def Get_CredentialsByEnv(self):
        awsAccessKey = os.environ['accessKey']
        awsSecretKey = os.environ['secretKey']
        print("{0} - {1}".format(awsAccessKey,awsSecretKey))
        logging.info('Load the credential: {0}'.format(awsAccessKey))
        awsClient = AWS_Session(awsAccessKey,awsSecretKey)
        awsClient.get_credentials()
        return awsClient

    def Get_CredentialsByProfile(self):
        awsClient = AWS_Session(profile_name=self.config['AWS']['awsProfileName'])
        awsClient.get_credentials()
        return awsClient