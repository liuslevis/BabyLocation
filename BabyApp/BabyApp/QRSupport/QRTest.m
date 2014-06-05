//
//  QRTest.m
//  sercher
//
//  Created by 林晓杨 on 14-5-6.
//  Copyright (c) 2014年 Xu. All rights reserved.
//

#import "QRTest.h"
#import "QRCodeGenerator.h"

@implementation QRTest

-(void)viewDidLoad {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(IBAction)formQR:(id)sender {
    NSString *str = [string text];
    NSLog(@"%@", str);
    image.image = [QRCodeGenerator qrImageForString:str imageSize:image.bounds.size.width];
}

-(void)dismissKeyboard {
    NSArray *subviews = [self.view subviews];
    for (id objInput in subviews) {
        if ([objInput isKindOfClass:[UITextField class]]) {
            UITextField *theTextField = objInput;
            if ([objInput isFirstResponder]) {
                [theTextField resignFirstResponder];
            }
        }
    }
}

@end
