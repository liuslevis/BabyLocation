//
//  SingleModel.m
//  ParentApp
//
//  Created by Lius on 14-6-6.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import "SingleModel.h"
#import "UserAuthAPI.h"
#import "AppConstants.h"
#import "DavidlauUtils.h"
#import "APIDefine.h"

@implementation SingleModel


-(NSArray *)friends{
    if (_friends==nil) {
        _friends = [[NSArray alloc] init];
    }
    return _friends;
}

-(UserInfo *)userInfo{
    if (_userInfo==nil) {
        _userInfo = [[UserInfo alloc] init];
    }
    return _userInfo;
}

+ (SingleModel *)sharedInstance
{
    static SingleModel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SingleModel alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

// update info from Server
- (void)updateSync
{
    if(VERBOSE_MODE) NSLog(@"SingleModel: updateSync");
    if ([SingleModel sharedInstance].userInfo!=nil &&
        [SingleModel sharedInstance].userInfo.uid!=nil &&
        [SingleModel sharedInstance].userInfo.passmd5!=nil)
    {
        if (VERBOSE_MODE) NSLog(@"userinfo valid,begin to update");
        if([UserAuthAPI isServerRunning]){
            #pragma mark TODO: implement
            
            //更新用户好友列表
            SingleModel.sharedInstance.friends =
            [UserAuthAPI queryFriendsListByUid:SingleModel.sharedInstance.userInfo.uid
                                          passMd5:SingleModel.sharedInstance.userInfo.passmd5];

            
            // 更新好友详细信息（地理 头像...）
            [UserAuthAPI queryFriendsDetailInfo:SingleModel.sharedInstance.friends
                                          byUid:SingleModel.sharedInstance.userInfo.uid
                                        passMd5:SingleModel.sharedInstance.userInfo.passmd5];
        
        }
    }
}

// add a kid
- (void)addFriend:(NSString *)uid withName:(NSString *)name
{
    if ([self isValidUser]){
        [UserAuthAPI addFriend:uid withNickName:name withMyUid:self.userInfo.uid passwdMd5:self.userInfo.passmd5];
    }
}

// check wether userInfo valid
- (BOOL)isValidUser
{
    if(self.userInfo.uid!=nil && self.userInfo.passmd5!=nil){
        if([UserAuthAPI verifyUid:self.userInfo.uid passwdMd5:self.userInfo.passmd5]){
            return YES;
        }
    }
    return NO;
}

@end
