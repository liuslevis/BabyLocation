//
//  AddFriendByQRCodeVC.h
//  ParentApp
//
//  Created by Lius on 14-6-5.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AddFriendByQRCodeVC : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *viewPreview;

@end
