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
    NSString *url = [[NSString stringWithFormat:URL_SIGNUP_WITH_UID_PASS_PHONE_NAME_EMAIL_UUID,uid,passwd,phone,name,email,uuid] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:result_data options:NSJSONReadingMutableLeaves error:&error];
    
    if(json){
        NSString *result = [json objectForKey:@"result"];
        if( [@"server available" isEqualToString:result]){
            return YES;
        }
    }else{
        NSLog(@"ERR: cant get JSON. request url:%@ Error:%@",url,error);
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
              atCoordinate2D:(CLLocationCoordinate2D )coor
{
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


@end
