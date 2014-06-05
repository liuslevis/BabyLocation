//
//  AddFriendByQRCodeVC.m
//  ParentApp
//
//  Created by Lius on 14-6-5.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import "AddFriendByQRCodeVC.h"

@interface AddFriendByQRCodeVC ()

@end

@implementation AddFriendByQRCodeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)pressAddFriend:(id)sender {
    NSLog(@"add:%@", self.textField.text);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
