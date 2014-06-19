//
//  AddFriendByQRCodeDelegate.h
//  ParentApp
//
//  Created by Lius on 14-6-19.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AddFriendByQRCodeDelegate <NSObject>
@required
-(void) DismissModalViewAndAddFriendWithUid:(NSString *)uid andName:(NSString *)name;
@end
