//
//  ChildList.m
//  sercher
//
//  Created by 林晓杨 on 14-4-28.
//  Copyright (c) 2014年 Xu. All rights reserved.
//

#import "ChildList.h"
#import "IIViewDeckController.h"
#import "AppConstants.h"

#define X 10
#define Y 30
#define WIDTH 50
#define HEIGHT 50
#define SCROLLWIDTH 70

@implementation ChildList

@synthesize myscrollview;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    index = 0;
    height = [[UIScreen mainScreen]applicationFrame].size.height;
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    myscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCROLLWIDTH, height)];
    myscrollview.directionalLockEnabled = YES;
    myscrollview.pagingEnabled = NO;
    myscrollview.backgroundColor = DEFAULT_TINT_COLOR;
    myscrollview.showsVerticalScrollIndicator =YES;
    myscrollview.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    myscrollview.showsHorizontalScrollIndicator = NO;
    myscrollview.delegate = self;
    myscrollview.delaysContentTouches = YES;
    [self.view addSubview:myscrollview];
}

-(void)addButton {
    CGRect frame = CGRectMake(X, Y + index * (HEIGHT + 10), WIDTH, HEIGHT);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = frame;
    button.backgroundColor = [UIColor redColor];
    button.tag = index;
    index++;
    [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    CGSize newSize = CGSizeMake(SCROLLWIDTH, Y + index * (HEIGHT + 10));
    myscrollview.contentSize = newSize;
    [myscrollview addSubview:button];
    NSLog(@"添加孩子%d",index);
}

-(IBAction)onClick:(id)sender{
    [self.viewDeckController closeLeftViewAnimated:YES];
    UIButton *button = sender;
    NSLog(@"Tag is %d", button.tag);
}

@end
