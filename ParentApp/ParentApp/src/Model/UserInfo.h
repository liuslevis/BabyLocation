//
//  UserInfo.h
//  ParentApp
//
//  Created by Lius on 14-6-6.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface UserInfo : NSObject
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *passmd5;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *idfa;
@property (strong, nonatomic) NSString *lastUpdateDateTime;
@property (strong, nonatomic) NSString *gender;// boy or girl
@property (strong, nonatomic) UIImage *avatar;
@property (strong, nonatomic) CLLocation *current_location;
@property (strong, nonatomic) NSArray *history_location;
@property (strong, nonatomic) NSArray *friends;// friends is children, array of uid



- (UserInfo *)initWithUid:(NSString *)uid
              phone:(NSString *)phone
           nickname:(NSString *)nickname
            passmd5:(NSString *)passmd5
              email:(NSString *)email
               idfa:(NSString *)idfa
             avatar:(UIImage *)avatar
            friends:(NSArray *)friends
          locations:(NSArray *)locations;

- (UserInfo *)initWithUid:(NSString *)uid;

@end
