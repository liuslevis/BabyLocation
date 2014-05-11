//
//  ChildMenuTVC.h
//  ParentApp
//
//  Created by Lius on 14-5-10.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainVC.h"
#import "ChildMenuTVCDelegate.h"


@interface ChildMenuTVC : UITableViewController
@property (nonatomic,weak) id <ChildMenuTVCDelegate> delegate;
@end
