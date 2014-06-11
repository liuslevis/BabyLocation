//
//  Utils.m
//  Medical_Wisdom
//
//  Created by Mac on 14-1-26.
//  Copyright (c) 2014年 NanJingXianLang. All rights reserved.
//

#import "DavidlauUtils.h"
#import "AppConstants.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access



@implementation DavidlauUtils

+ (BOOL)isPhoneNumber:(NSString *)text
{
    if ([text length] < PHONE_LEN){
        return NO;
    }
    return YES;
}

+ (BOOL)isPasswd:(NSString *)text
{
    if ([text length] < PASSWD_MIN_LEN){
        return NO;
    }
    return YES;
}



+ (UIImageView *)imageViewWithFrame:(CGRect)frame withImage:(UIImage *)image{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = image;
    return imageView ;
}

+ (UILabel *)labelWithFrame:(CGRect)frame withTitle:(NSString *)title titleFontSize:(UIFont *)font textColor:(UIColor *)color backgroundColor:(UIColor *)bgColor alignment:(NSTextAlignment)textAlignment{
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.font = font;
    label.textColor = color;
    label.backgroundColor = bgColor;
    label.textAlignment = textAlignment;
    return label ;
    
}


//alertView
+(UIAlertView *)alertTitle:(NSString *)title message:(NSString *)msg delegate:(id)aDeleagte cancelBtn:(NSString *)cancelName otherBtnName:(NSString *)otherbuttonName{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:aDeleagte cancelButtonTitle:cancelName otherButtonTitles:otherbuttonName, nil];
    [alert show];
    return  alert;
}

+(UIButton *)createBtnWithType:(UIButtonType)btnType frame:(CGRect)btnFrame backgroundColor:(UIColor*)bgColor{
    UIButton *btn = [UIButton buttonWithType:btnType];
    btn.frame = btnFrame;
    [btn setBackgroundColor:bgColor];
    return btn;
}

//利用正则表达式验证邮箱的合法性
+(BOOL)isValidateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
    
}

+ (NSString *)howLongIsTheInterval:(NSTimeInterval) interval
{
    int inter_abs = interval<0?-interval:interval;
    long temp = 0;
    NSString *result;
    if (inter_abs < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = inter_abs/60) <60){
        result = [NSString stringWithFormat:interval>0?@"%ld%@后":@"%ld%@前",temp,@"分"];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:interval>0?@"%ld%@后":@"%ld%@前",temp,@"小时"];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:interval>0?@"%ld%@后":@"%ld%@前",temp,@"日"];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:interval>0?@"%ld%@后":@"%ld%@前",temp,@"月"];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:interval>0?@"%ld%@后":@"%ld%@前",temp,@"年"];
    }
    return result;
    

}

@end

// md5 for NSString & NSData
@implementation NSString (MyAdditions)
- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end

@implementation NSData (MyAdditions)
- (NSString*)md5
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( self.bytes, self.length, result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}
@end


