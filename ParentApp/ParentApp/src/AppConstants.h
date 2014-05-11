//
//  AppConstants.h
//  RegLogVeriUser
//
//  Created by Lius on 14-4-28.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#ifndef RegLogVeriUser_AppConstants_h
#define RegLogVeriUser_AppConstants_h

#define PASSWD_MIN_LEN 6
#define PHONE_LEN 11

#define LOGIN_BTN_SECTION 1
#define LOGIN_BTN_ROW 0

#define DEFAULT_TINT_COLOR [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]

#define REGISTER_BTN_SECTION 1
#define REGISTER_BTN_ROW 0

#define DAVIDDEBUG YES

#define URL_REQ_UPDATE_LOCATION @"http://127.0.0.1:7777/baby/%@/lat/%f/long/%f"
#define URL_TRACK_REQ_WITH_NAME @"http://127.0.0.1:7777/baby/%@/track"

#endif
