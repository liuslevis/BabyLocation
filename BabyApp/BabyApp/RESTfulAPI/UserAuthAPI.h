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

+(BOOL)addFriend:(NSString *)friendUid
       withMyUid:(NSString *)myUid
       passwdMd5:(NSString *)passwd;

+(BOOL)updateLocationWithUid:(NSString *)uid
                          atCLLocation:(CLLocation *)location;
+(BOOL)updateLocationWithUid:(NSString *)uid
              atCoordinate2D:(CLLocationCoordinate2D )coord;

@end
