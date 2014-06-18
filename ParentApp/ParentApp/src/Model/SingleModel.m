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
    if(VERBOSE_MODE) NSLog(@"SingleModel: updateAsync");
    if ([SingleModel sharedInstance].userInfo!=nil &&
        [SingleModel sharedInstance].userInfo.uid!=nil &&
        [SingleModel sharedInstance].userInfo.passmd5!=nil)
    {
        if (VERBOSE_MODE) NSLog(@"userinfo valid,begin to update");
        if([UserAuthAPI isServerRunning]){
            #pragma mark TODO: implement
            
            //更新用户好友列表
            SingleModel.sharedInstance.friends =
            [UserAuthAPI queryFriendsUidListByUid:SingleModel.sharedInstance.userInfo.uid
                                          passMd5:SingleModel.sharedInstance.userInfo.passmd5];
            
            
            // 更新好友详细信息（地理 头像...）
            [UserAuthAPI queryFriendsDetailInfo:SingleModel.sharedInstance.friends
                                          byUid:SingleModel.sharedInstance.userInfo.uid
                                        passMd5:SingleModel.sharedInstance.userInfo.passmd5];

            // check
//            for(id kid in SingleModel.sharedInstance.friends){
//                NSLog(@"kid locations num=%d",[((UserInfo *)kid).history_location count]);
//            }
            
            
            // Fake Data
//            UserInfo *userInfo = [[UserInfo alloc] init];
//            userInfo.uid = @"XiaoKui";
//            userInfo.nickname = @"小葵";
//            userInfo.avatar = [UIImage imageNamed:@"girl"];
//            [SingleModel sharedInstance].friends_userInfo= [[SingleModel sharedInstance].friends_userInfo arrayByAddingObject:userInfo];
//            
//            UserInfo *userInfo2 = [[UserInfo alloc] init];
//            userInfo2.uid = @"David";
//            userInfo2.nickname = @"小新";
//            userInfo2.avatar = [UIImage imageNamed:@"boy"];
//            [SingleModel sharedInstance].friends_userInfo= [[SingleModel sharedInstance].friends_userInfo arrayByAddingObject:userInfo2];
//            [SingleModel sharedInstance].friends_userInfo= [[SingleModel sharedInstance].friends_userInfo arrayByAddingObject:userInfo];
            

        
        }

    }

}

// add a kid
- (void)addFriend:(NSString *)uid
{
    if ([self isValidUser])
        [UserAuthAPI addFriend:uid withMyUid:self.userInfo.uid passwdMd5:self.userInfo.passmd5];
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

//- (NSArray *)downloadHistoryLocationOfChildAtIndex:(int)childIndex
//{
//
////    if ( nil==self.friends_userInfo ||
////        self.friends_userInfo.count <= childIndex ) {
////        NSLog(@"SingleModel downloadHistoryLocationOfChildAtIndex: break");
////        return nil;
////    }
//
//    NSLog(@"Failed , frendUserInfo.count=%d", self.friends.count);
//
//
//    NSData *child_track_data;
//    if (DEMO_MODE) {
//        // Demo Mode, just load data from txt
//        NSString *trackFileName = childIndex==0? @"DavidTrack" : @"XiaoKuiTrack";
//        
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:trackFileName ofType:@"txt"];
//        NSLog(@"Load From file %@", filePath);
//        NSData *myData = [NSData dataWithContentsOfFile:filePath];
//        if (myData) {
//            child_track_data = [NSData dataWithContentsOfFile:filePath];
//        }else{
//            NSLog(@"ERR: cant load Demo's track data");
//            return nil;
//        }
//        
//        
//        
//    }else{
//#pragma MARK TODO:download location of each friend by uid
//        // Download Track Data From Server
//        
//       
//        UserInfo *kidInfo = [self.friends objectAtIndex:childIndex];
//        NSString *kidUid = [kidInfo uid];
//        
//        NSString *url = [NSString stringWithFormat:URL_GET_TRACK_OF_UID,kidUid];
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//        // TODO: change to Async
//        child_track_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//        if (child_track_data==nil) {
//            NSLog(@"ERR: no echo from server when query history :%@",url);
//            return nil;
//        }
//    }
//    
//    if (child_track_data == nil){
//        NSLog(@"ERR: cant download/load child track data");
//        return nil;
//    }
//    NSError *error;
//    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:child_track_data options:NSJSONReadingMutableLeaves error:&error];
//    
//    NSArray *timeseq = [json objectForKey:@"timeseq"];
//    NSArray *longseq = [json objectForKey:@"longseq"];
//    NSArray *latseq = [json objectForKey:@"latseq"];
//    
//    if ([timeseq count]!=[longseq count] || [longseq count]!=[latseq count] || [timeseq count]==0){
//        NSLog(@"WARNING: the track download has wrong format!");
//        return nil;
//    }else{// Draw Track
//        NSInteger len = [timeseq count];
//        NSMutableArray *locations = [[NSMutableArray alloc] init];
//        for (NSInteger i = 0; i<len; i++) {
//            //            NSLog(@" ts:%@,lat,long:%@",(NSString *)[timeseq objectAtIndex:i],(NSString *)[longseq objectAtIndex:i]);
//            double latitude = [(NSString *)[latseq objectAtIndex:i] doubleValue];
//            double longitude= [(NSString *)[longseq objectAtIndex:i] doubleValue];
//            [locations addObject:[[CLLocation alloc]
//                                  initWithLatitude:latitude
//                                  longitude:longitude]];
//        }
//        return [locations copy];
//    }
//}


@end
