//
//  SingleModel.h
//  ParentApp
//
//  Created by Lius on 14-6-6.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface SingleModel : NSObject

@property (strong, nonatomic) UserInfo *userInfo; // name, uid, avatar, histroy locations
@property (strong, nonatomic) NSArray *friends;// aka. children list, array of userInfo

+ (SingleModel *)sharedInstance;

-(void)updateSync;
- (void)addFriend:(NSString *)uid withName:(NSString *)name;
- (BOOL)isValidUser;
//- (NSArray *)downloadHistoryLocationOfChildAtIndex:(int)childIndex; // array of CLLocation
@end
