//
//  Utils.h
//  Medical_Wisdom
//
//  Created by Mac on 14-1-26.
//  Copyright (c) 2014年 NanJingXianLang. All rights reserved.
//

#import <Foundation/Foundation.h>
/***************************************************************************
 *
 * 工具类
 *
 ***************************************************************************/

#define NSSTR2(partA,partB) [[NSString alloc] initWithFormat:partA arguments:(partB)]
#define NSSTR3(partA,partB,partC) [[NSString alloc] initWithFormat:partA arguments:(partB,partC)]


@interface DavidlauUtils : NSObject



+ (UIImageView *)imageViewWithFrame:(CGRect)frame withImage:(UIImage *)image;

+ (UILabel *)labelWithFrame:(CGRect)frame withTitle:(NSString *)title titleFontSize:(UIFont *)font textColor:(UIColor *)color backgroundColor:(UIColor *)bgColor alignment:(NSTextAlignment)textAlignment;


#pragma mark - alertView提示框
+(UIAlertView *)alertTitle:(NSString *)title message:(NSString *)msg delegate:(id)aDeleagte cancelBtn:(NSString *)cancelName otherBtnName:(NSString *)otherbuttonName;
#pragma mark - btnCreate
+(UIButton *)createBtnWithType:(UIButtonType)btnType frame:(CGRect)btnFrame backgroundColor:(UIColor*)bgColor;

#pragma mark isValidateEmail
+(BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)isPhoneNumber:(NSString *)text;
+ (BOOL)isPasswd:(NSString *)text;
@end

#pragma mark add md5 method to NSData & NSString
@interface NSString (DavidlauUtils)
- (NSString *)md5;
@end

@interface NSData (DavidlauUtils)
- (NSString*)md5;
@end
