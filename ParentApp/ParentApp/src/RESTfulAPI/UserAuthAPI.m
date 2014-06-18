//
//  LocationAPI.m
//  ParentApp
//
//  Created by Lius on 14-5-23.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import "UserAuthAPI.h"
#import "APIDefine.h"
#import "DavidlauUtils.h"
#import "AppConstants.h"
#import "UserInfo.h"

@implementation UserAuthAPI

// return JSON from server
+ (NSDictionary *) signUpUid:(NSString *)uid
                       phone:(NSString *)phone
                      passwdMd5:(NSString *)passwd
                       email:(NSString *)email
                        name:(NSString *)name
{
    if(uid==nil | phone==nil | passwd==nil){
        return nil;
    }
    NSString *uuid = [[NSUUID UUID] UUIDString];
    
    NSString *unencodedString = [NSString stringWithFormat:URL_SIGNUP_WITH_UID_PASS_PHONE_NAME_EMAIL_UUID,uid,passwd,phone,name,email,uuid];
    
    // encode url
    NSString *url = [unencodedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // another
//    NSString *url = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(    NULL,    (CFStringRef)unencodedString,    NULL,    (CFStringRef)@"!*'();:@&=+$,/?%#[]",    kCFStringEncodingUTF8 ));
    
    if (VERBOSE_MODE) {
        NSLog(@"sign up url:%@",url);
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSError *error1;
    NSData *result_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error1];
    
    if(result_data==nil){
        NSLog(@"ERR: cant sign up, check network! request url:%@ Error:%@",url,error1);
        return nil;
    }
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:result_data options:NSJSONReadingMutableLeaves error:&error];
    
    if(nil!=json){
        return json;
    }
    
    return nil;
}

+ (NSDictionary *)signInUid:(NSString *)uid
                     passwdMd5:(NSString *)passwd
{
    if (uid==nil | passwd==nil) return nil;
    NSString *url = [[NSString stringWithFormat:URL_SIGNIN_WITH_UID_PASS,uid,passwd]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (VERBOSE_MODE) {
        NSLog(@"sign in url:%@",url);
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSError *error1;
    NSData *result_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error1];
    
    if(result_data==nil){
        NSLog(@"ERR: cant sign in, check network! request url:%@ Error:%@",url,error1);
        return nil;
    }
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:result_data options:NSJSONReadingMutableLeaves error:&error];
    
    if(nil!=json){
        return json;
    }
    
    return nil;
}

+ (BOOL) verifyUid:(NSString *)uid
            passwdMd5:(NSString *)passwd
{
    NSDictionary *json=[UserAuthAPI signInUid:uid passwdMd5:passwd];
    if (json==nil) {
        return NO;
    }
    NSString *result =(NSString *)[json objectForKey:@"result"];
    if ([@"login success" isEqualToString:result]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isServerRunning
{
     NSString *url = [[NSString stringWithFormat:URL_CHECK_SERVER_AVAILABILITY]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (VERBOSE_MODE) {
        NSLog(@"check server availability in url:%@",url);
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSError *error1;
    NSData *result_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error1];
    
    if(result_data==nil){
        NSLog(@"ERR: cant connect to server, check network! request url:%@ Error:%@",url,error1);
        return NO;
    }

    NSError *error2;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:result_data options:NSJSONReadingMutableLeaves error:&error2];
    
    if(json){
        NSString *result = [json objectForKey:@"result"];
        if( [@"server available" isEqualToString:result]){
            return YES;
        }
    }else{
        NSLog(@"ERR: cant connect to server to get JSON. request url:%@ Error:%@",url,error2);
    }
    
    return NO;
}

+(BOOL)addFriend:(NSString *)friendUid
       withMyUid:(NSString *)myUid
       passwdMd5:(NSString *)passwd
{

    NSString *url = [[NSString stringWithFormat:URL_ADD_FRIENDS_WITH_MYUID_MYPASSMD5_FRIENDUID,myUid,passwd,friendUid]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (VERBOSE_MODE) {
        NSLog(@"add friend via uid, url:%@",url);
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSError *error1;
    NSData *result_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error1];
    
    if(result_data==nil){
        NSLog(@"ERR: cant connect to server, check network! request url:%@ Error:%@",url,error1);
        return NO;
    }
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:result_data options:NSJSONReadingMutableLeaves error:&error];
    
    if(json){
        NSString *result = [json objectForKey:@"result"];
        if( [@"failed to add friend" isEqualToString:result]){
            return NO;
        }else if([@"add friend success" isEqualToString:result]){
            return YES;
        }
    }else{
        NSLog(@"ERR: cant get JSON. request url:%@ Error:%@",url,error);
    }

    return NO;
}


+(BOOL)updateLocationWithUid:(NSString *)uid
                atCLLocation:(CLLocation *)location
{
    CLLocationCoordinate2D coor = location.coordinate;
    double latitude =  coor.latitude;
    double longitude = coor.longitude;
    
    if(VERBOSE_MODE) NSLog(@" prepare update loation lat:%f long:%f",latitude,longitude);

    NSString *url = [[NSString stringWithFormat:URL_REQ_UPDATE_LOCATION,uid,latitude,longitude]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (VERBOSE_MODE) {
        NSLog(@"updateLocationWith Query:%@",url);
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSError *error1;
    NSData *result_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error1];
    
    if(result_data==nil){
        NSLog(@"ERR: cant connect to server, check network! request url:%@ Error:%@",url,error1);
        return NO;
    }
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:result_data options:NSJSONReadingMutableLeaves error:&error];
    
    if(json){
        NSString *result = [json objectForKey:@"result"];
        if( [@"failed to update location" isEqualToString:result]){
            return NO;
        }else if([@"update location success" isEqualToString:result]){
            return YES;
        }
    }else{
        NSLog(@"ERR: cant get JSON. request url:%@ Error:%@",url,error);
    }
    
    return NO;
}

// friends: array of UserInfo, including names, avatar, histroy location
+ (NSArray *)queryFriendsUidListByUid:(NSString *)uid
                         passMd5:(NSString *)passmd5
{
    NSArray *friends = [[NSArray alloc] init];
    if([self verifyUid:uid passwdMd5:passmd5]){
        if(VERBOSE_MODE) NSLog(@" query friend list");
        
        NSString *url = [[NSString stringWithFormat:URL_UPDATE_FRIENDS,uid,passmd5] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (VERBOSE_MODE) {
            NSLog(@"query friend list:%@",url);
        }
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSError *error1;
        NSData *result_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error1];
        
        if(result_data==nil){
            NSLog(@"ERR: cant connect to server, check network! request url:%@ Error:%@",url,error1);
            return friends;
        }
        
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:result_data options:NSJSONReadingMutableLeaves error:&error];
        
        if(json){
            NSString *result = [json objectForKey:@"result"];
            if( [@"query friends success" isEqualToString:result]){
                
                // get friend uid list
                NSString *uid_str_list = [json objectForKey:@"uid_list"];
                NSArray *uid_list = [uid_str_list componentsSeparatedByString:@" "];
                for(id uid in uid_list){
                    if ( [((NSString *)uid) length] > 0) {
                        UserInfo *friend = [[UserInfo alloc] initWithUid:(NSString *)uid];
                        friends = [friends arrayByAddingObject:friend];
                        if (VERBOSE_MODE) NSLog(@" get %dth friend:%@", [uid_list indexOfObject:uid],friend.uid);
                    }
                }
            }else if([@"query friends failed" isEqualToString:result]){
                NSLog(@"ERR: get friend list failed");
            }
        }else{
            NSLog(@"ERR: cant get JSON. request url:%@ Error:%@",url,error);
        }
    }else{
        if(VERBOSE_MODE) NSLog(@"ERR: update friends failed, invalid user info");
    }
    return friends;
}

// 获取好友的详细信息，包括地理位置，根据输入friends的uid
+ (NSArray *)queryFriendsDetailInfo:(NSArray *)friends // array of UserInfo with uid
                         byUid:(NSString *)uid
                       passMd5:(NSString *)passmd5
{
    if([self verifyUid:uid passwdMd5:passmd5]){
        if(VERBOSE_MODE) NSLog(@" queryFriendsDetailInfo begin");
        for(id friend in friends){
            NSString *uid = ((UserInfo *)friend).uid;
            if ([uid length]>0){
                NSData *child_track_data;

                // Download Track Data From Server
                NSString *url = [NSString stringWithFormat:URL_GET_TRACK_OF_UID,uid];
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
                if (VERBOSE_MODE) NSLog(@"queryFriendsDetailInfo with URL:%@", url);
                // TODO: change to Async
                child_track_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                if (child_track_data==nil) {
                    NSLog(@"ERR: no echo from server when query history :%@",url);
                    continue;
                }
                
                
                if (child_track_data == nil){
                    NSLog(@"ERR: cant download/load child track data");
                    continue;
                }
                NSError *error;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:child_track_data options:NSJSONReadingMutableLeaves error:&error];
                
                NSArray *timeseq = [json objectForKey:@"timeseq"];
                NSArray *longseq = [json objectForKey:@"longseq"];
                NSArray *latseq = [json objectForKey:@"latseq"];
                

                if ([timeseq count]!=[longseq count] || [longseq count]!=[latseq count] || [timeseq count]==0){
                    NSLog(@"WARNING: the track download has wrong format!");
                    continue;
                }else{// Generate Track (array of locations)
                    NSMutableArray *locations = [[NSMutableArray alloc] init];
                    for (NSInteger i = 0; i< [timeseq count]; i++) {
                        //            NSLog(@" ts:%@,lat,long:%@",(NSString *)[timeseq objectAtIndex:i],(NSString *)[longseq objectAtIndex:i]);
                        double latitude = [(NSString *)[latseq objectAtIndex:i] doubleValue];
                        double longitude= [(NSString *)[longseq objectAtIndex:i] doubleValue];
                        [locations addObject:[[CLLocation alloc]
                                              initWithLatitude:latitude
                                              longitude:longitude]];
                    }
                    if(locations){
                        ((UserInfo *)friend).history_location = locations;
                        ((UserInfo *)friend).current_location = [locations objectAtIndex:0];
                        
                        ((UserInfo *)friend).lastUpdateDateTime = [timeseq objectAtIndex:0]; // e.g. @"2014-06-11-17:24:11"
                    }
                }
            }
        }
    }else{
        if(VERBOSE_MODE) NSLog(@"ERR: queryFriendsDetailInfo failed, invalid user info");
    }
    return friends;
}

@end
