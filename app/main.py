import boto3
import psycopg2

boto3.setup_default_session(profile_name = 'quyennvdotcom')
ssm = boto3.client('ssm','ap-northeast-1')

postgres_endpoint = ssm.get_parameter(Name='/rds/db/il-db-init/endpoint')['Parameter']['Value']
postgres_identifier = ssm.get_parameter(Name='/rds/db/il-db-init/identifier')['Parameter']['Value']
postgres_username = ssm.get_parameter(Name='/rds/db/il-db-init/endpoint')['Parameter']['Value']
postgres_password  = ssm.get_parameter(Name='/rds/db/il-db-init/superuser/password')['Parameter']['Value']

print("End point: {0}".format(postgres_endpoint))
print("Identifier: {0}".format(postgres_identifier))
print("Username: {0}".format(postgres_username))
print("Password: {0}".format(postgres_password))

#get the version of db
try:
    con = psycopg2.connect(host = postgres_endpoint, database=postgres_identifier,user=postgres_username,password=postgres_password)
    cur = con.cursor()
    cur.execute("SELECT version")
    version = cur.fetchone()
    print('The version of postgresql: {0}'.format(version))
except Exception as e:
    print('Unable to connect. Detail: {0}'.format(e))
