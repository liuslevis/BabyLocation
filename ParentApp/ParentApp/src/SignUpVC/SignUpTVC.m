//
//  RegisterTVC.m
//  RegLogVeriUser
//
//  Created by Lius on 14-4-28.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import "SignUpTVC.h"
#import "UserAuthAPI.h"
#import "AppConstants.h"

@interface SignUpTVC ()
@property (strong, nonatomic) NSString *uid;
@property (weak, nonatomic) IBOutlet UITextField *textPhoneNo;
@property (weak, nonatomic) IBOutlet UITextField *textPasswd;
@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextField *textEmail;
@property (weak, nonatomic) IBOutlet UILabel *labelRegister;

@end

@implementation SignUpTVC

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
    if (DEMO_MODE) {
        self.textPhoneNo.text = DEMO_USER_1_PHONE;
        self.textPasswd.text = DEMO_USER_1_PASS;
        self.textName.text = DEMO_USER_1_NAME;
        self.textEmail.text = DEMO_USER_1_EMAIL;
    }
    
    [self bindRegisterBtnColorUpdate];

    // tap empty place to dismiss keyboard
//    UITapGestureRecognizer*tap =[[UITapGestureRecognizer alloc]                                        initWithTarget:self action:@selector(dismissKeyboard)];
//    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.textPasswd resignFirstResponder];
    [self.textEmail resignFirstResponder];
    [self.textPhoneNo resignFirstResponder];
    [self.textName resignFirstResponder];

}

# pragma mark 注册按钮颜色更新逻辑
- (void)registerColorChanged{
    if ([DavidlauUtils isPasswd:self.textPasswd.text] &&
        [DavidlauUtils isPhoneNumber:self.textPhoneNo.text] &&
        [DavidlauUtils isValidateEmail:self.textEmail.text]) {
        self.labelRegister.textColor = DEFAULT_TINT_COLOR;
    }else{
        self.labelRegister.textColor = [UIColor lightGrayColor];
    }
}


- (void) bindRegisterBtnColorUpdate{
    [self.textPasswd addTarget:self action:@selector(registerColorChanged) forControlEvents:UIControlEventAllEditingEvents ];
    [self.textPhoneNo addTarget:self action:@selector(registerColorChanged) forControlEvents:UIControlEventAllEditingEvents ];
    [self.textEmail addTarget:self action:@selector(registerColorChanged) forControlEvents:UIControlEventAllEditingEvents ];
    [self registerColorChanged];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self registerColorChanged];
}

#pragma mark 注册逻辑
- (void)pressRegister{
    if (NO==[UserAuthAPI isServerRunning]){
        [DavidlauUtils alertTitle:@"注册失败" message:@"服务器君似乎挂了，我们正努力抢救她" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        return;
    }
    
    // 确认帐号密码合法
    if (![DavidlauUtils isPhoneNumber:self.textPhoneNo.text]) {
        NSString *warning = [NSString stringWithFormat: @"请填%d位手机号码",PHONE_LEN];
        [DavidlauUtils alertTitle:@"提示" message:warning delegate:nil cancelBtn:@"取消" otherBtnName:nil];
    }else if (![DavidlauUtils isPasswd:self.textPasswd.text]) {
        NSString *warning = [NSString stringWithFormat: @"密码需要大于%d位",PASSWD_MIN_LEN-1];
        [DavidlauUtils alertTitle:@"提示" message:warning delegate:nil cancelBtn:@"取消" otherBtnName:nil];
    }else if (![DavidlauUtils isValidateEmail:self.textEmail.text]) {
        NSString *warning = [NSString stringWithFormat: @"请确保邮箱地址正确"];
        [DavidlauUtils alertTitle:@"提示" message:warning delegate:nil cancelBtn:@"取消" otherBtnName:nil];
    }else{
        // 符合条件 异步联网确认登录
//        [DavidlauUtils alertTitle:@"提示" message:@"正在注册并登录" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
        
        self.uid = self.textPhoneNo.text;
        NSDictionary *json = [UserAuthAPI signUpUid:self.uid
                                              phone:self.textPhoneNo.text
                                             passwdMd5:[self.textPasswd.text md5]
                                              email:self.textEmail.text
                                               name:self.textName.text];
        NSString *result;
        if(json){
            result = [json objectForKey:@"result"];
            if([result isEqualToString:@"sign up success"]){
                
                
                //TODO: Store User Login Info to NSUserDefault
            
                if (TRUE == [UserAuthAPI verifyUid:self.uid passwdMd5:[self.textPasswd.text md5]]) {
                    //成功登录，保存用户信息并跳转
                    
                    NSString *valueToSave = self.uid;
                    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:APP_USER_UID_KEY];
                    valueToSave = [self.textPasswd.text md5];
                    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:APP_USER_PASSWD_KEY];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    UIStoryboard *mainStoryboad = [UIStoryboard storyboardWithName:@"MainAndSettings" bundle:nil];
                    if (mainStoryboad){
                        [self presentViewController:[mainStoryboad instantiateInitialViewController]
                                           animated:YES
                                         completion:nil];
                    }
                }else{
                    [DavidlauUtils alertTitle:@"登录失败 请重新注册" message:result delegate:self cancelBtn:@"取消" otherBtnName:nil];
                }
                
                
            }else{
                if ([result isEqualToString:@"uid occupied"]) {
                    result = @"手机号已被占用，请试试其他号码";
                }else if ([result isEqualToString:@"uid occupied"]) {
                    result = @"请重试";
                }
                [DavidlauUtils alertTitle:@"注册失败" message:result delegate:self cancelBtn:@"取消" otherBtnName:nil];
            }
        }else{
            [DavidlauUtils alertTitle:@"服务器无响应，请稍候再试" message:result delegate:self cancelBtn:@"取消" otherBtnName:nil];
        }
    }
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (SIGNUP_BTN_ROW==indexPath.row && SIGNUP_BTN_SECTION==indexPath.section) {
        NSLog(@"Register pressed!");
        [self pressRegister];
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
