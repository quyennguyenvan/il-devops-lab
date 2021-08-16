from dependency_injector.providers import Selector
import psycopg2

class DBContext(object):

    def __init__(self,connectionDBCredential):
        self.connectionDBCredential = connectionDBCredential

    #init the connection
    def connection(self):
        try:
            con = psycopg2.connect(host = self.connectionDBCredential['hostname'], 
                    database=self.connectionDBCredential['identifier'],
                    user=self.connectionDBCredential['username'],
                    password=self.connectionDBCredential['password'])
            cur = con.cursor()
            return cur
        except Exception as e:
            print('Unable to connect. Detail: {0}'.format(e))

    def getDBInfor(self):
        try:
            if self.connection():
                cur = self.connection()
                cur.execute("SELECT version()")
                version = cur.fetchone()
                return version
        except Exception as er:
            return er
