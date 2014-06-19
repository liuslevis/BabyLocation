//
//  ChildMenuTVC.m
//  ParentApp
//
//  Created by Lius on 14-5-10.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import "ChildMenuTVC.h"

@interface ChildMenuTVC ()
@end

@implementation ChildMenuTVC

# pragma mark Delegate
@synthesize delegate;

#pragma mark Init
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [SingleModel.sharedInstance.friends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Children Tabel View Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Children Tabel View Cell"];
    }

    UserInfo *kidInfo = (UserInfo *)[SingleModel.sharedInstance.friends objectAtIndex:indexPath.row];
    if(kidInfo){
        cell.textLabel.text = [kidInfo.nickname length]> 0 ? kidInfo.nickname :kidInfo.uid;
        if (kidInfo.avatar){
            cell.imageView.image = kidInfo.avatar;
        }else{
            cell.imageView.image = [UIImage imageNamed:@"happyface"];

//            if([kidInfo.gender isEqualToString:@"boy"]){
//                cell.imageView.image = [UIImage imageNamed:@"boy"];
//            }else if([kidInfo.gender isEqualToString:@"girl"]){
//                cell.imageView.image = [UIImage imageNamed:@"girl"];
//            }else{
//                cell.imageView.image = [UIImage imageNamed:@"happyface"];
//
//            }
        }
    }
    return cell;
}


- (void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)path {
    // change delegate's current selected children status
    [self.delegate didFinishedSelectChildAtIndex:path.row];
    [self.navigationController popToRootViewControllerAnimated:YES];
}



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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//}


@end
