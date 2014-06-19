//
//  LocationAPI.h
//  ParentApp
//
//  Created by Lius on 14-5-23.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface UserAuthAPI : NSObject

+ (NSDictionary *) signUpUid:(NSString *)uid
                       phone:(NSString *)phone
                      passwdMd5:(NSString *)passwd
                       email:(NSString *)email
                       name:(NSString *)name;

+ (NSDictionary *) signInUid:(NSString *)uid
                      passwdMd5:(NSString *)passwd;

+ (BOOL) verifyUid:(NSString *)uid
            passwdMd5:(NSString *)passwd;

+ (BOOL)isServerRunning;

//+(BOOL)addFriend:(NSString *)friendUid
//       withMyUid:(NSString *)myUid
//       passwdMd5:(NSString *)passwd;

+(BOOL)addFriend:(NSString *)friendUid
    withNickName:(NSString *)friendName
       withMyUid:(NSString *)myUid
       passwdMd5:(NSString *)passwd;

// 把自己的uid和位置location上传到服务器
+(BOOL)updateLocationWithUid:(NSString *)uid
                atCLLocation:(CLLocation *)location;

// 下载某人uid的历史位置
//+(NSArray *)downloadLocationsOfUid:(NSString *)uid;

// 获取好友uid列表，
// 输入参数friends 应当是 SingleModel的friends array
// 返回friends with uid
+ (NSArray *)queryFriendsUidListByUid:(NSString *)uid
                              passMd5:(NSString *)passmd5;
// 返回friends with uid,name
+ (NSArray *)queryFriendsListByUid:(NSString *)uid
                           passMd5:(NSString *)passmd5;


// 获取好友的详细信息，包括地理位置，根据输入friends的uid，返回friends with detail
+ (NSArray *)queryFriendsDetailInfo:(NSArray *)friends // array of UserInfo
                         byUid:(NSString *)uid
                       passMd5:(NSString *)passmd5;


@end
