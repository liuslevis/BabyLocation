//
//  QRTest.h
//  sercher
//
//  Created by 林晓杨 on 14-5-6.
//  Copyright (c) 2014年 Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRTest : UIViewController
{
    IBOutlet UIImageView *image;
    IBOutlet UITextField *string;
    IBOutlet UIButton *form;
}

-(IBAction)formQR:(id)sender;

@end
