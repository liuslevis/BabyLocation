import hashlib
import flask
from flask import jsonify
import sys
# import pymongo
# import bson.binary
# import bson.objectid
# import bson.errors
# from PIL import Image
from flask import json
from cStringIO import StringIO
from datetime import datetime, date, time
import redis

global RDS
DATE_TIME_FORMAT = "%Y-%m-%d-%H:%M:%S"
MAX_LOCATION_LIST_LEN = 1000

app = flask.Flask(__name__)
app.debug = True # auto reload

@app.route('/ping',methods=['GET'])
def checkServerAvailable():
    print "query: GET /ping"
    return jsonify(result="server available")

def hasUser(uid):
    uid = uid.encode('utf8')
    r = getRedis()
    userkeys = r.hkeys( "user:%s"%str(uid) )
    if userkeys!=None and len(userkeys)>0:
        return True
    return False


@app.route('/friendList_uid/<uid>/<passwd>',methods=['GET'])
def queryFriendUidList(uid, passwd):
    uid = uid.encode('utf8')
    passwd = passwd.encode('utf8')
    info = "query:GET /friendList_uid/%s/%s"%(uid, passwd)
    print info
    if isValidUser(uid,passwd):
        r = getRedis()
        user_friend_key = "user:%s:friends_uid"%uid
        result_li = r.lrange(user_friend_key,0,-1)

    uids_str = ''
    print result_li
    if type(list())==type(result_li):
        for uid in result_li:
            uids_str += str(uid)+' '

        return jsonify(result="query friends success",uid_list=uids_str)

    return jsonify(result="query friends failed",uid_list=uids_str)


@app.route('/friendList_name/<uid>/<passwd>',methods=['GET'])
def queryFriendNameList(uid, passwd):
    uid = uid.encode('utf8')
    passwd = passwd.encode('utf8')
    info = "query:GET /friendList_name/%s/%s"%(uid, passwd)
    print info
    if isValidUser(uid,passwd):
        r = getRedis()
        user_friend_key = "user:%s:friends_name"%uid
        result_li = r.lrange(user_friend_key,0,-1)

    name_str = ''
    print result_li
    if type(list())==type(result_li):
        for name in result_li:
            name_str += str(name)+' '

        return jsonify(result="query friends success",name_list=name_str)

    return jsonify(result="query friends failed",name_list=name_str)

# @app.route('/addFriend/<uid>/<passwd>/<friendUid>',methods=['GET'])
# def addFriend(uid, passwd, friendUid):
#     uid = uid.encode('utf8')
#     passwd = passwd.encode('utf8')
#     friendUid = friendUid.encode('utf8')

#     info = "query:GET /addFriend/%s/%s/%s"%(uid, passwd, friendUid)
#     print info
#     if isValidUser(uid,passwd):
#         r = getRedis()
#         user_friend_key = "user:%s:friends_uid"%uid
#         result = r.sadd(user_friend_key,friendUid)
#         if result==1:
#             return jsonify(result="add friend success")
#         else:
#             # already has
#             return jsonify(result="add friend success")

#     return jsonify(result="failed to add friend")

@app.route('/addFriendWithName/<uid>/<passwd>/<friendUid>/<friendName>',methods=['GET'])
def addFriendWithName(uid, passwd, friendUid,friendName):
    uid = uid.encode('utf8')
    passwd = passwd.encode('utf8')
    friendUid = friendUid.encode('utf8')
    friendName = friendName.encode('utf8')

    info = "query:GET /addFriendWithName/%s/%s/%s/%s"%(uid, passwd, friendUid,friendName)
    print info
    if isValidUser(uid,passwd):
        if not hasFriend(uid,friendUid):
            r = getRedis()
            
            key1 = "user:%s:friends_uid"%uid
            result = r.rpush(key1,friendUid)

            key2 = "user:%s:friends_name"%uid
            result2 = r.rpush(key2,friendName)
                
            return jsonify(result="add friend success")

        else:
            print "addFriendWithName failed: %s already has friend %s" % (uid,friendUid)
            # already has
            return jsonify(result="add friend success")

    return jsonify(result="failed to add friend")

def hasFriend(uid,friendUid):
    r = getRedis()
    key = "user:%s:friends_uid"
    user_friend_key = "user:%s:friends_uid"%uid
    result_li = r.lrange(user_friend_key,0,-1)

    if type(list())==type(result_li):
        for uid in result_li:
            if uid == friendUid:
                return True

    return False

@app.route('/signup/<uid>/<passwd>/<phone>/<name>/<email>/<uuid>',methods=['GET'])
def signup(uid, passwd, phone, name, email, uuid):
    uid = uid.encode('utf8')
    passwd = passwd.encode('utf8')
    phone = phone.encode('utf8')
    name = name.encode('utf8')
    email = email.encode('utf8')
    uuid = uuid.encode('utf8')

    info = "query:GET /signup/%s/%s/%s/%s/%s/%s"%(uid, passwd, phone, name, email, uuid)
    print info
    r = getRedis()

    # check if has register
    if hasUser(uid):
        # uid already occupied
        print "    ERR:uid already occupied" 
        return jsonify(result="uid occupied")
    else:
        # uid available  

        base = "user:%s" % str(uid)

        result = r.hmset(base, \
            { \
            "uid"     :uid , \
            "passwd"  :passwd , \
            "phone"   :phone , \
            "name"    :name , \
            "email"   :email ,\
            "uuid"    :uuid \
            })

        if result == True:
            print " Sign up Success!"
            return jsonify(result="sign up success")
        else:
            print " Sign up Failed!"
            return jsonify(result="sign up failed")

def isValidUser(uid,tryPass):
    uid = uid.encode('utf8')
    tryPass = tryPass.encode('utf8')

    r = getRedis()
    uid = str(uid)
    tryPass = str(tryPass)
    userkeys = r.hkeys( "user:%s"%str(uid) )
    if userkeys!=None and len(userkeys)>0:
        # is valid User
        realpass = r.hget('user:%s'%uid, 'passwd')
        realpass = str(realpass)
        if realpass!="" and realpass == tryPass:
            return True
    return False

@app.route('/login/<uid>/<passwd>',methods=['GET'])
def login(uid, passwd):
    uid = uid.encode('utf8')
    passwd = passwd.encode('utf8')

    info = "query:GET /login/%s/%s"%(uid, passwd)
    print info
    r = getRedis()

    # check if has user uid
    if hasUser(uid):
        # is valid User
        realpass = r.hget('user:%s'%uid, 'passwd')
        if(realpass!=None):
            if(realpass==passwd):
                print "   login sucess!"
                return jsonify(result="login success")
            else:
                print "   login failed: incorrect passwd !"
                return jsonify(result="incorrect passwd")
        else:
            print "   ERR:!! login failed: has uid, no passwd"
            return jsonify(result="has uid, no passwd record")

    print "  login failed: no such uid"
    return jsonify(result="no such uid")

# Baby App Update a Location
@app.route('/baby/<uid>/lat/<latitude>/long/<longitude>',methods=['GET'])
def updatetrack(uid,latitude,longitude):
    uid = uid.encode('utf8')
    latitude = latitude.encode('utf8')
    longitude = longitude.encode('utf8')
    
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
    res = r.rpush(key,value) #return num of elem in list (>=1)
    r.ltrim(key,0,MAX_LOCATION_LIST_LEN)
    info = 'query:UPDATE a baby  @(%s,%s,%s)'%(uid,latitude,longitude) + ' Redis: RPUSH(\'%s\',\'%s\')'%(key,value) + "result:%d"%res

    print info
    if res>=1:
        return jsonify(result="update location success")  
    return jsonify(result="failed to update location")  

# Parent App Query a track of baby
# return JSON  {timeseq:[str,...],latseq:[str,...],longseq:[str,...]} 
@app.route('/baby/<uid>/track',methods=['GET'])
def querytrack(uid):
    uid = uid.encode('utf8')

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
    info =  'quert:GET track of @%s. %d record found.'%(uid,len(timeseq))
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
    # app.debug = False
    # app.run(port=7777) # test on local

    app.run(host='0.0.0.0',port=7777) # listen on all public IPs.