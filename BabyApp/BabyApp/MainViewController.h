//
//  MainViewController.h
//  BabyApp
//
//  Created by Lius on 14-6-5.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AdSupport/ASIdentifierManager.h>
#import "DMAdView.h"

@interface MainViewController : UIViewController <DMAdViewDelegate>
{
    DMAdView *_dmAdView;
}
@property (weak, nonatomic) IBOutlet UILabel *uidLabel;

+ (NSString *)getUid;



@end
