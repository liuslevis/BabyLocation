//
//  SetFriendsNameVC.m
//  ParentApp
//
//  Created by Lius on 14-6-19.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import "SetFriendsNameVC.h"
#import "SingleModel.h"
#import "DavidlauUtils.h"

@interface SetFriendsNameVC ()
@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;

@end

@implementation SetFriendsNameVC


- (IBAction)addFriend:(id)sender {
    if ([self.textName.text length]>0) {
        if([self.friendUid length]>1){
            [self.delegate DismissModalViewAndAddFriendWithUid:self.friendUid andName:self.textName.text];
        }else{
            NSLog(@"ERR: SetFriendNameVC cant get friendUid");
        }
    }else{
        [DavidlauUtils alertTitle:@"请输入宝贝名字" message:nil delegate:nil cancelBtn:@"好" otherBtnName:nil];
    }
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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


@end
