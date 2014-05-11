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

@interface LoginTVC ()
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
    [self bindLoginBtnColorUpdate];
    
    // Fake account for Demo
    if (DAVIDDEBUG) {
        self.textPhoneNo.text = @"132123456789";
        self.textPasswd.text  = @"123456";
        self.labelLogin.textColor = DEFAULT_TINT_COLOR;
    }
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
        if (DAVIDDEBUG) { // Demo without validate
            // Pop Main UI
            
            // Init with deckVC
            ChildList* childList = [[ChildList alloc] initWithNibName:nil bundle:nil];
            [childList addButton];
            [childList addButton];
            MainPage* main = [[MainPage alloc] initWithNibName:nil bundle:nil];
            UIViewController *centerController = main;
            centerController = [[UINavigationController alloc] initWithRootViewController:centerController];
            IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:centerController
                                                                                            leftViewController:childList
                                                                                           rightViewController:nil];
            deckController.rightSize = 0;
            //main.list = childList;
            [main setList:childList];
            [deckController disablePanOverViewsOfClass:NSClassFromString(@"_UITableViewHeaderFooterContentView")];

            [self presentViewController:deckController animated:YES completion:nil];
            
        }else{// 符合条件 异步联网确认帐号
            // TODO: fill login Logic
            [DavidlauUtils alertTitle:@"提示" message:@"正在登录" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
        }
    }

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
