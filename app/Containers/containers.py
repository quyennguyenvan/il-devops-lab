from dependency_injector import containers, providers
from dependency_injector.wiring import Provide

#import class
from Helpers.AWS_Credential import AWSCredential
from Services.SSM import SSM
from Services.DBConnection import DBContext

#load config
class Configs (containers.DeclarativeContainer):
    config = providers.Configuration('config')

class AWSCredentialService(containers.DeclarativeContainer):
    awsConfig = providers.Singleton(AWSCredential, Configs.config)

class SSMService(containers.DeclarativeContainer):
    ssmService = providers.Factory(SSM, Configs.config, awsCredential = AWSCredentialService.awsConfig)

class DBContextService(containers.DeclarativeContainer):
    dbContextService = providers.Factory(DBContext, Configs.config)

