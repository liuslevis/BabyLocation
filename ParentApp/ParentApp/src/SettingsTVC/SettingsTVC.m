//
//  SettingsTVC.m
//  ParentApp
//
//  Created by Lius on 14-5-24.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import "SettingsTVC.h"
#import "AppConstants.h"
#import "DavidlauUtils.h"

@interface SettingsTVC ()

@end

@implementation SettingsTVC

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)pressLogout
{
    NSLog(@"Logout pressed!");
    // TODO: get alert work
//    [DavidlauUtils alertTitle:@"" message:@"确认登出？" delegate:self cancelBtn:@"取消" otherBtnName:@"登出"];
    
    // 清除NSUserDefault的用户数据
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:APP_USER_PASSWD_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:APP_USER_UID_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // 跳转到主界面
    UIStoryboard *mainStoryboad = [UIStoryboard storyboardWithName:@"Login_iPhone" bundle:nil];
    if (mainStoryboad){
        [self presentViewController:[mainStoryboad instantiateInitialViewController]
                           animated:YES
                         completion:nil];
    }
}

- (void)pressCloseApp
{
    NSLog(@"CloseApp pressed!");
    [DavidlauUtils alertTitle:@"待完成" message:@"把GPS关闭 发送通知给服务器 用户离线 跳转到HOME" delegate:self cancelBtn:@"取消" otherBtnName:nil];
    
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (LOGOUT_BTN_ROW==indexPath.row && LOGOUT_BTN_SECTION==indexPath.section) {
        [self pressLogout];
    }
    if (CLOSE_APP_BTN_ROW==indexPath.row && CLOSE_APP_BTN_SECTION==indexPath.section) {
        [self pressCloseApp];
    }

}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
