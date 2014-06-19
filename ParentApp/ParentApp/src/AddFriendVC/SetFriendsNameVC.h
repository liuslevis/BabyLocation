//
//  SetFriendsNameVC.h
//  ParentApp
//
//  Created by Lius on 14-6-19.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AddFriendByQRCodeDelegate.h"

@interface SetFriendsNameVC : UIViewController
@property (strong, nonatomic) NSString *friendUid;
@property (weak, nonatomic) id<AddFriendByQRCodeDelegate> delegate;
@end
