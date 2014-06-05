//
//  AddFriendVC.m
//  ParentApp
//
//  Created by Lius on 14-5-9.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import "GenerateQRCodeVC.h"
#import "QRTest.h"
#import "QRCodeGenerator.h"

@interface GenerateQRCodeVC ()

@end

@implementation GenerateQRCodeVC



-(void)viewDidLoad {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // Generate QR
    self.QRImageView.image = [self formQRwithCode:self.labelParentName.text ofSize:self.QRImageView.bounds.size.width];
}

-(UIImage *)formQRwithCode:(NSString *)code ofSize:(CGFloat)size {
    return [QRCodeGenerator qrImageForString:code imageSize:size];
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



#pragma mark useless
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
