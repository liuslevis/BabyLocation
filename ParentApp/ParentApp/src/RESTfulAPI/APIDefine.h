//
//  APIDefine.h
//  ParentApp
//
//  Created by Lius on 14-5-23.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#ifndef ParentApp_APIDefine_h
#define ParentApp_APIDefine_h

#define LOCAL_SERVER @"http://127.0.0.1:7777"
#define REMOTE_SERVER @"http://server.babylocation.tk:7777"


#define URL_CHECK_SERVER_AVAILABILITY @"http://server.babylocation.tk:7777/ping"
#define URL_REQ_UPDATE_LOCATION @"http://server.babylocation.tk:7777/baby/%@/lat/%f/long/%f"
#define URL_GET_TRACK_OF_UID @"http://server.babylocation.tk:7777/baby/%@/track"
#define URL_UPDATE_FRIENDS_UID @"http://server.babylocation.tk:7777/friendList_uid/%@/%@"
#define URL_UPDATE_FRIENDS_NAME @"http://server.babylocation.tk:7777/friendList_name/%@/%@"


#define URL_ADD_FRIENDS_WITH_MYUID_MYPASSMD5_FRIENDUID @"http://server.babylocation.tk:7777/addFriend/%@/%@/%@"
#define URL_ADD_FRIENDS_WITH_MYUID_MYPASSMD5_FRIENDUID_FRIENDNAME @"http://server.babylocation.tk:7777/addFriendWithName/%@/%@/%@/%@"
#define URL_SIGNUP_WITH_UID_PASS_PHONE_NAME_EMAIL_UUID @"http://server.babylocation.tk:7777/signup/%@/%@/%@/%@/%@/%@"

#define URL_SIGNIN_WITH_UID_PASS @"http://server.babylocation.tk:7777/login/%@/%@"

#endif
