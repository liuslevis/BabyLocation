import hashlib
import flask
from flask import jsonify
import pymongo
import bson.binary
import bson.objectid
import bson.errors
from flask import json
from cStringIO import StringIO
from PIL import Image
from datetime import datetime, date, time
import redis

global RDS
DATE_TIME_FORMAT = "%Y-%m-%d-%H:%M:%S"

app = flask.Flask(__name__)
app.debug = True

@app.route('/location/<content>',methods=['GET', 'POST'])
def location(content):
    str = "a query: /location/"+content
    print str
    return str  

# Baby App Update a Location
@app.route('/baby/<uid>/lat/<latitude>/long/<longitude>',methods=['GET'])
def updatetrack(uid,latitude,longitude):
    
    # assert(r!=None, 'ERR: cant connect to Redis!')
    # get cur time str

    timestamp = datetime.now().strftime(DATE_TIME_FORMAT)
    latitude = latitude.replace(' ','')
    longitude = longitude.replace(' ','')
    timestamp = timestamp.replace(' ','')
    lat_long_time = str(latitude)+' '+str(longitude)+' '+str(timestamp)
    
    
    # Write to Redis
    key = 'baby:'+uid+':tracklist'
    value = lat_long_time
    r = getRedis()
    r.rpush(key,value)

    info = 'UPDATE: a baby  @(%s,%s,%s)'%(uid,latitude,longitude) + ' Redis: RPUSH(%s,%s)'%(key,value)
    return info  

# Parent App Query a track of baby
# return JSON  {timeseq:[str,...],latseq:[str,...],longseq:[str,...]} 
@app.route('/baby/<uid>/track',methods=['GET'])
def querytrack(uid):
    # Read from Redis
    key = 'baby:'+uid+':tracklist'
    r = getRedis()
    tracklist = r.lrange(key,0,-1)
    timeseq = []
    latseq  = []
    longseq = []
    for record in tracklist:
        if 3==len(record.split(' ')):
            latitude,longitude,timestamp = record.split(' ')
            timeseq.append(timestamp)
            latseq.append(latitude)
            longseq.append(longitude)

    # Return in JSON
    json = jsonify(timeseq=timeseq,latseq=latseq,longseq=longseq)
    info =  'QUERY: track of @%s. %d record found.'%(uid,len(timeseq))
    print info
    return json

@app.route('/')
def index():
    return '''
    <!doctype html>
    <html>
    <body>
        <h1>Useage</h1>
            <h2>
                query a baby's track:  GET http://localhost:7777/baby/Jack/track
            </h2>
            <h2>
                update a baby's location: GET http://localhost:7777/baby/uid/lat/123.123/long/123.123
            </h2>
            </p>
    </body>
    </html>
    '''

# connect and return Redis handler
def getRedis():
    global RDS
    try:
        RDS = redis.StrictRedis(host='localhost', port=6379, db=0)
        RDS.set('foo', 'bar')
        if 'bar'!=RDS.get('foo'):
            raise Exception('ERR: Redis is not well.')
                

    except Exception as err:
        print 'ERR: cant connect to Redis, ensure Redis-server is running!',err

    finally:
        return RDS

    


if __name__ == '__main__':
    app.run(port=7777)