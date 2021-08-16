from dependency_injector.providers import Selector
import psycopg2
import logging

class DBContext(object):

    def __init__(self,connectionDBCredential):
        self.connectionDBCredential = connectionDBCredential

    #init the connection
    def getDBInfor(self):
        try:
            con = psycopg2.connect(
                    host=self.connectionDBCredential['hostname'], 
                    database=self.connectionDBCredential['identifier'],
                    user=self.connectionDBCredential['username'],
                    password=self.connectionDBCredential['password'])
            cur = con.cursor()
            cur.execute("SELECT version()")
            version = cur.fetchone()
            return version
        except Exception as er:
            logging.info("db issue: {0}".format(er))
            print('Unable to connect. Detail: {0}'.format(er))
            return "Current cur not open. please check the network or credential of connection"
