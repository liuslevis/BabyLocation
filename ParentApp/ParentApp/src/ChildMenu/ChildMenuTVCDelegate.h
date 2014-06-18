//
//  ChildMenuTVCDelegate.h
//  ParentApp
//
//  Created by Lius on 14-5-10.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import <Foundation/Foundation.h>

// I'll call delegate method: [self.delegate method] as follow
@protocol ChildMenuTVCDelegate <NSObject>
@required
-(void)didFinishedSelectChildAtIndex:(int)index;
@end
