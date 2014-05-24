//
//  AddFriendByUid.m
//  ParentApp
//
//  Created by Lius on 14-5-24.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import "AddFriendByUid.h"
#import "AppConstants.h"
#import "UserAuthAPI.h"
#import "DavidlauUtils.h"

@interface AddFriendByUid () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firendUidField; // TODO:暂时是手机号做uid
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;

@end

@implementation AddFriendByUid

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
- (IBAction)pressedAddFriend:(id)sender {
    // Simply Update Server user:uid:firends
    if (![DavidlauUtils isPhoneNumber:self.firendUidField.text] ) {
        [DavidlauUtils alertTitle:nil message:@"请输入11位手机号" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
        return;
    }
    
    NSString *savedUid = [[NSUserDefaults standardUserDefaults]
                          stringForKey:APP_USER_UID_KEY];
    NSString *savedMd5 = [[NSUserDefaults standardUserDefaults]
                          stringForKey:APP_USER_PASSWD_KEY];
    
    NSLog(@"Adding Friend :%@",self.firendUidField.text);
    
    if(YES==[UserAuthAPI addFriend:self.firendUidField.text
                         withMyUid:savedUid
                         passwdMd5:savedMd5])
    {
        // segue to rootview by delegate
        [DavidlauUtils alertTitle:nil message:@"已添加好友" delegate:self cancelBtn:@"确认" otherBtnName:nil];

    }else{
        [DavidlauUtils alertTitle:nil message:@"添加失败" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
    }
    
    //TODO: 完善：双向认证逻辑（需要用到APN），或者单向的：宝贝客户端扫一扫父亲端即可
}

#pragma mark - Alert Delegate
//press to segue to RootVC
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
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
