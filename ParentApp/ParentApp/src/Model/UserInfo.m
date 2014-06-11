//
//  UserInfo.m
//  ParentApp
//
//  Created by Lius on 14-6-6.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

-(NSArray *)friends{
    if (_friends==nil) {
        _friends = [[NSArray alloc] init];
    }
    return _friends;
}

-(NSArray *)history_location{
    if (_history_location==nil) {
        _history_location = [[NSArray alloc] init];
    }
    return _history_location;
}

-(NSString *)uid{
    if (_uid==nil) {
        _uid = @"";
    }
    return _uid;
}

-(NSString *)phone{
    if (_phone==nil) {
        _phone = @"";
    }
    return _phone;
}

-(NSString *)nickname{
    if (_nickname==nil) {
        _nickname = @"";
    }
    return _nickname;
}

-(NSString *)passmd5{
    if (_passmd5==nil) {
        _passmd5 = @"";
    }
    return _passmd5;
}

-(NSString *)email{
    if (_email==nil) {
        _email = @"";
    }
    return _email;
}

-(NSString *)idfa{
    if (_idfa==nil) {
        _idfa = @"";
    }
    return _idfa;
}

-(NSString *)lastUpdateDateTime
{
    if (_lastUpdateDateTime==nil) {
        _lastUpdateDateTime = @"";
    }
    return _lastUpdateDateTime;
}


- (UserInfo *)initWithUid:(NSString *)uid
{
    self.uid = uid;
    return self;
}

- (UserInfo *)initWithUid:(NSString *)uid
                    phone:(NSString *)phone
                 nickname:(NSString *)nickname
                  passmd5:(NSString *)passmd5
                    email:(NSString *)email
                     idfa:(NSString *)idfa
                   avatar:(UIImage *)avatar
                  friends:(NSArray *)friends
         history_location:(NSArray *)history_location
{
    self.uid = uid;
    self.phone = phone;
    self.nickname = nickname;
    self.passmd5 = passmd5;
    self.email = email;
    self.avatar = avatar;
    self.friends = friends;
    self.history_location = history_location;
    return self;
}

@end
