//
//  MainViewController.m
//  BabyApp
//
//  Created by Lius on 14-6-5.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import "MainViewController.h"
#import "QRCodeGenerator.h"
#import "UserAuthAPI.h"
#import "AppConstants.h"
#import "MapVC.h"

#define PUBLISHER_ID @"56OJwTr4uNHFJbrW5F"
#define PLACEMENT_ID @"16TLuznlAprmkNUEA85xGVHs"

@interface MainViewController ()
{
    CGSize _adSize;
    CGFloat _adX, _adY;
}
@property (weak, nonatomic) IBOutlet UIImageView *QRImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISwitch *statusSwitch;
@property (weak, nonatomic) IBOutlet UIButton *retryButton;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
#pragma mark TODO:DEBUG模拟器测试失败 initWithNibName:Banner没有执行
    // banner
    if (self)
    {
        NSLog(@"init with nib: Banner");
        self.title = NSLocalizedString(@"Banner", @"Banner");
        
        // 确定广告尺寸及位置
        //Set the size and origin
        _adX = 0;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            if (!([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)) {
                _adY = 20;
            }else{
            }
        }
        else
        {
            _adY = 20;
        }
    }
    return self;
}

- (void)killAd
{
    [_dmAdView removeFromSuperview];
    _dmAdView = nil;
}

- (void)hideAd
{
    [_dmAdView removeFromSuperview];
}

- (void)initAd
{
    if (_dmAdView==nil) {
        [UIApplication sharedApplication].statusBarHidden = YES;
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        _adY = screenHeight - FLEXIBLE_SIZE.height;
        _adX = 0;
        //////////////////////////////////////////////////////////////////////////////////////////
        // 创建广告视图，此处使用的是测试ID，请登陆多盟官网（www.domob.cn）获取新的ID
        _dmAdView = [[DMAdView alloc] initWithPublisherId:PUBLISHER_ID
                                              placementId:PLACEMENT_ID];
        // 设置广告视图的位置 宽与高设置为0即可 该广告视图默认是横竖屏自适应 但需要在旋转时调用orientationChanged 方法
        _dmAdView.frame = CGRectMake(_adX, _adY, FLEXIBLE_SIZE.width,FLEXIBLE_SIZE.height);
        _dmAdView.delegate = self;

        [_dmAdView setKeywords:self.getUid];
    }
    
    
    _dmAdView.rootViewController = self; // set RootViewController
    [self.view addSubview:_dmAdView];
    [_dmAdView loadAd]; // start load advertisement
    
    ///////////////////////////////////////////////////////////////////////////////////////
    // 检查评价提醒，此处使用的是测试ID，请登陆多盟官网（www.domob.cn）获取新的ID
    // Check for rate please get your own ID from Domob website
    //    DMTools *_dmTools = [[DMTools alloc] initWithPublisherId:PUBLISHER_ID];
    //    [_dmTools checkRateInfo];
    //    [_dmTools release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"viewDidLoad");
    [self showUid];
    
    // switch target-action
    [self.statusSwitch addTarget:self
                 action:@selector(switchAction)
       forControlEvents:UIControlEventValueChanged];
    
    // Generate QR
    self.QRImageView.image = [self formQRwithCode:self.uidLabel.text ofSize:self.QRImageView.bounds.size.width];
    
    // 正式版隐藏二维码下的UID
    if (DEMO_MODE==NO) {
        self.uidLabel.hidden = YES;
    }
}

// 每次点击该Tab VC，ping服务器并修改联通状态
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"ping server");
    [self pingServerAndThenBeginUpdateAsync];
}

- (void)switchAction
{
    NSLog(@"switch:%d", self.statusSwitch.on);
    if (self.statusSwitch.on==YES) {
        self.statusLabel.text = ONLINE;
        self.retryButton.hidden = YES;
    }else{
        self.statusLabel.text = OFFLINE;
        self.retryButton.hidden = NO;
    }
}

- (void)pingServerAndThenBeginUpdateAsync
{
#pragma mark TODO: implmnt Async
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(UserAuthAPI.isServerRunning){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.statusLabel.text = ONLINE;
                self.statusSwitch.on = YES;
                self.retryButton.hidden = YES;
                // 地图VC执行  Update My Location, every 500m
                MapVC *mapVC = (MapVC *)[self.tabBarController.viewControllers objectAtIndex:1];
                [mapVC beginUpdateLocationMovedEvery:UPDATE_LOCATION_EVERY_METERS];
                
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.statusLabel.text = OFFLINE;
                self.statusSwitch.on = NO;
                self.retryButton.hidden = NO;
                // 地图VC执行  Update My Location, every 500m
                MapVC *mapVC = (MapVC *)[self.tabBarController.viewControllers objectAtIndex:1];
                [mapVC beginUpdateLocationMovedEvery:UPDATE_LOCATION_EVERY_METERS];
            });
        }
    });
    
}

-(UIImage *)formQRwithCode:(NSString *)code ofSize:(CGFloat)size {
    return [QRCodeGenerator qrImageForString:code imageSize:size];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [_dmAdView removeFromSuperview]; // 将⼲⼴广告试图从⽗父视图中移除
}

- (IBAction)pressRetry:(id)sender {
    // Try Connect to server
    [self pingServerAndThenBeginUpdateAsync];

    
    // 广告开关 Switch Ad on/off
//    if (_dmAdView==nil) {
//        [self initAd];
//    }else{
//        [self killAd];
//    }
}

//针对Banner的横竖屏⾃自适应⽅方法 //method For multible orientation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    [_dmAdView orientationChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _dmAdView.delegate = nil;
}

+ (NSString *)getUid
{
    // Uid is IDFV
    //如果用户将属于此Vender的所有App卸载，则idfv的值会被重置，即再重装此Vender的App，idfv的值和之前不同。
    // TODO IDFV/IDAD 保存到Keychain
    NSString *IDFV = [[[UIDevice alloc] identifierForVendor] UUIDString];
    return IDFV;

//    NSString *IDFA = [[[ASIdentifierManager alloc] advertisingIdentifier] UUIDString];
//    return IDFA;
    
    
    
    
}

- (NSString *)getUid
{
    return [MainViewController getUid];
}

- (void)showUid
{
    self.uidLabel.text = self.getUid;
}

@end
