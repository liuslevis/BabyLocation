//
//  RegisterTVC.m
//  RegLogVeriUser
//
//  Created by Lius on 14-4-28.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import "RegisterTVC.h"

@interface RegisterTVC ()
@property (weak, nonatomic) IBOutlet UITextField *textPasswd;
@property (weak, nonatomic) IBOutlet UITextField *textEmail;
@property (weak, nonatomic) IBOutlet UITextField *textPhoneNo;
@property (weak, nonatomic) IBOutlet UILabel *labelRegister;

@end

@implementation RegisterTVC

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
    
    [self bindRegisterBtnColorUpdate];

    // tap empty place to dismiss keyboard
    UITapGestureRecognizer*tap =[[UITapGestureRecognizer alloc]                                        initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.textPasswd resignFirstResponder];
    [self.textEmail resignFirstResponder];
    [self.textPhoneNo resignFirstResponder];
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
    // TODO fill register logic
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
        [DavidlauUtils alertTitle:@"提示" message:@"正在登录" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
        // TODO: fill reg Logic
    }
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (LOGIN_BTN_ROW==indexPath.row && LOGIN_BTN_SECTION==indexPath.section) {
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
