//
//  AddFriendByQRCodeVC.m
//  ParentApp
//
//  Created by Lius on 14-6-5.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import "AddFriendByQRCodeVC.h"
#import "SingleModel.h"
#import "SetFriendsNameVC.h"
#import "AppConstants.h"

@interface AddFriendByQRCodeVC () <AddFriendByQRCodeDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSString *friendUid;
@property (nonatomic, weak) SetFriendsNameVC *modalVC;

-(void)loadBeepSound;
-(void)stopReading;

@end

@implementation AddFriendByQRCodeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// <AddFriendByQRCodeDelegate> call by SetFriendNameVC
- (void)DismissModalViewAndAddFriendWithUid:(NSString *)uid andName:(NSString *)name
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[SingleModel sharedInstance] addFriend:uid withName:name];// 添加宝贝
        [[SingleModel sharedInstance] updateSync];// 更新好友列表
    });
    // 去除modal，
    [self dismissViewControllerAnimated:YES completion:nil];

    // 回到root view
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (IBAction)pressAddFriend:(id)sender {
    NSLog(@"press AddFirends");
    NSString *friendUid = [self.textField.text uppercaseString];//转成大写
    if ([friendUid length]>1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 获取好友UID
            self.friendUid = [self.textField.text uppercaseString];//转成大写
            // 跳转到设置好友名字VC with Uid
            [self performSegueWithIdentifier:@"Set Friend Name Segue" sender:self];
        });
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _captureSession = nil;
    [self loadBeepSound];
    [self startReading];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // DEMO_MODE 把 通过输入号码添加的控件隐藏
    if(DEMO_MODE==NO){
        self.addButton.hidden = YES;
        self.textField.hidden = YES;
    }
}

-(void)loadBeepSound{
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    NSError *error;
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        [_audioPlayer prepareToPlay];
    }
}

- (BOOL)startReading {
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    // <AVCaptureMetadataOutputObjectsDelegate>
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    
    return YES;
}

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
}

// <AVCaptureMetadataOutputObjectsDelegate>
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            // 识别出二维码
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_async(mainQueue, ^{
                self.textField.text = [metadataObj stringValue];
                self.statusLabel.text = @"扫描成功!";
                [self stopReading];
                
                // 获取好友UID
                self.friendUid = [self.textField.text uppercaseString];//转成大写
                
                // 跳转到设置好友名字VC with Uid
                [self performSegueWithIdentifier:@"Set Friend Name Segue" sender:self];
                

            });
            
            if (_audioPlayer) {
                [_audioPlayer play];
            }


            //press add friend btn
//            [self pressAddFriend:self];
        }
    }
}

// 传 friend uid给 SetFriendNameVC
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Set Friend Name Segue"]) {
        if ([segue.destinationViewController isKindOfClass:[SetFriendsNameVC class]]) {
            ((SetFriendsNameVC *)segue.destinationViewController).friendUid = self.friendUid;
            ((SetFriendsNameVC *)segue.destinationViewController).delegate = self;
            self.modalVC = (SetFriendsNameVC *)segue.destinationViewController;
        }
    }
}

@end
