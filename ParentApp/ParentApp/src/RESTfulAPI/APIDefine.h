//
//  APIDefine.h
//  ParentApp
//
//  Created by Lius on 14-5-23.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#ifndef ParentApp_APIDefine_h
#define ParentApp_APIDefine_h

#define URL_CHECK_SERVER_AVAILABILITY @"http://127.0.0.1:7777/ping"
#define URL_REQ_UPDATE_LOCATION @"http://127.0.0.1:7777/baby/%@/lat/%f/long/%f"
#define URL_TRACK_REQ_WITH_NAME @"http://127.0.0.1:7777/baby/%@/track"


#define URL_SIGNUP_WITH_UID_PASS_PHONE_NAME_EMAIL_UUID @"http://127.0.0.1:7777/signup/%@/%@/%@/%@/%@/%@"

#define URL_SIGNIN_WITH_UID_PASS @"http://127.0.0.1:7777/login/%@/%@"

#endif
