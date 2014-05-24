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
        return FALSE;
    }
    NSString *result =(NSString *)[json objectForKey:@"result"];
    if ([@"login success" isEqualToString:result]) {
        return TRUE;
    }
    return FALSE;
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
        return FALSE;
    }
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:result_data options:NSJSONReadingMutableLeaves error:&error];
    
    if(json){
        NSString *result = [json objectForKey:@"result"];
        if( [@"server available" isEqualToString:result]){
            return TRUE;
        }
    }else{
        NSLog(@"ERR: cant get JSON. request url:%@ Error:%@",url,error);

    }
    
    return FALSE;
}


@end
