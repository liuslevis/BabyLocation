//
//  LoginTVC.m
//  RegLogVeriUser
//
//  Created by Lius on 14-4-27.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import "LoginTVC.h"
#import "AppConstants.h"
#import "MainPage.h"
#import "IIViewDeckController.h"
#import "ChildList.h"
#import "UserAuthAPI.h"
#import "SingleModel.h"

@interface LoginTVC ()
@property (strong, nonatomic)  NSString *uid;
@property (weak, nonatomic) IBOutlet UITextField *textPhoneNo;
@property (weak, nonatomic) IBOutlet UITextField *textPasswd;
@property (weak, nonatomic) IBOutlet UILabel *labelLogin;
@end

@implementation LoginTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 检查UserDefault是否有登录记录，有则直接验证，进入主界面
    NSString *savedUid = [[NSUserDefaults standardUserDefaults]
                          stringForKey:APP_USER_UID_KEY];
    NSString *savedMd5 = [[NSUserDefaults standardUserDefaults]
                          stringForKey:APP_USER_PASSWD_KEY];
    if(VERBOSE_MODE) NSLog(@"check userdefault:%@ %@",savedUid, savedMd5);
    
    if ([UserAuthAPI verifyUid:savedUid passwdMd5:savedMd5]) {
        // 保存用户登录信息到Model
        [SingleModel sharedInstance].userInfo.uid = savedUid;
        [SingleModel sharedInstance].userInfo.passmd5 = savedMd5;

        

        // 跳转到主界面
        UIStoryboard *mainStoryboad = [UIStoryboard storyboardWithName:@"MainAndSettings" bundle:nil];
        if (mainStoryboad){
            [self presentViewController:[mainStoryboad instantiateInitialViewController]
                               animated:YES
                             completion:nil];
        }
    }

    [self bindLoginBtnColorUpdate];
    
    // Demo account for Demo
    if (DEMO_MODE) {
        self.textPhoneNo.text = DEMO_USER_1_PHONE;
        self.textPasswd.text  = DEMO_USER_1_PASS;
        self.labelLogin.textColor = DEFAULT_TINT_COLOR;
    }
}

-(void)dismissKeyboard {
    [self.textPasswd resignFirstResponder];
    [self.textPhoneNo resignFirstResponder];
}


# pragma mark 登录按钮颜色
- (void)loginColorChanged{
    if ([DavidlauUtils isPasswd:self.textPasswd.text] &&
        [DavidlauUtils isPhoneNumber:self.textPhoneNo.text]) {
        self.labelLogin.textColor = DEFAULT_TINT_COLOR;
    }else{
        self.labelLogin.textColor = [UIColor lightGrayColor];
    }
}


- (void) bindLoginBtnColorUpdate{
    [self.textPasswd addTarget:self action:@selector(loginColorChanged) forControlEvents:UIControlEventAllEditingEvents ];
    [self.textPhoneNo addTarget:self action:@selector(loginColorChanged) forControlEvents:UIControlEventAllEditingEvents ];
    [self loginColorChanged];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self loginColorChanged];
}

# pragma mark 登录注册逻辑
- (void)pressLogin{
    // 确认帐号密码合法
    if (![DavidlauUtils isPhoneNumber:self.textPhoneNo.text]) {
        NSString *warning = [NSString stringWithFormat: @"请填%d位手机号码",PHONE_LEN];
        [DavidlauUtils alertTitle:@"提示" message:warning delegate:nil cancelBtn:@"取消" otherBtnName:nil];
    }else if (![DavidlauUtils isPasswd:self.textPasswd.text]) {
        NSString *warning = [NSString stringWithFormat: @"密码需要大于%d位",PASSWD_MIN_LEN-1];
        [DavidlauUtils alertTitle:@"提示" message:warning delegate:nil cancelBtn:@"取消" otherBtnName:nil];
    }else{
        

        # pragma mark 跳转到主界面
        // Demo without validate
        if (LOGIN_WITHOUT_VERIFY) {
            
            // Init With Storyboard
            UIStoryboard *mainStoryboad = [UIStoryboard storyboardWithName:@"MainAndSettings" bundle:nil];
            if (mainStoryboad){
                [self presentViewController:[mainStoryboad instantiateInitialViewController]
                               animated:YES
                             completion:nil];
            }

            
        }else{// 联网确认帐号密码
            self.uid = self.textPhoneNo.text;
            // TODO:添加阻塞动画
            
            //检查服务器连通
            if (NO==[UserAuthAPI isServerRunning]) {
                [DavidlauUtils alertTitle:@"无法登录" message:@"我们的服务器似正在抢救中，请稍候再试" delegate:self cancelBtn:@"取消" otherBtnName:nil];
                return;
            }
            
            //验证用户信息
            if (YES==[UserAuthAPI verifyUid:self.uid passwdMd5:[self.textPasswd.text md5]]){
                //成功登录，保存用户信息到NSUserDefault并跳转
                NSString *valueToSave = self.uid;
                [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:APP_USER_UID_KEY];
                valueToSave = [self.textPasswd.text md5];
                [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:APP_USER_PASSWD_KEY];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // 保存用户登录信息到Model
                [SingleModel sharedInstance].userInfo.uid = self.uid;
                [SingleModel sharedInstance].userInfo.passmd5 = [self.textPasswd.text md5];
                
                // 跳转到主界面
                UIStoryboard *mainStoryboad = [UIStoryboard storyboardWithName:@"MainAndSettings" bundle:nil];
                if (mainStoryboad){
                    [self presentViewController:[mainStoryboad instantiateInitialViewController]
                                       animated:YES
                                     completion:nil];
                }
            }else{
                [DavidlauUtils alertTitle:@"登录失败" message:@"用户名或密码错误" delegate:self cancelBtn:@"取消" otherBtnName:nil];
            }
        }
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Login other pressed!");

    if (LOGIN_BTN_ROW==indexPath.row && LOGIN_BTN_SECTION==indexPath.section) {
        NSLog(@"Login pressed!");
        [self pressLogin];
    }
}


# pragma mark Useless

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
