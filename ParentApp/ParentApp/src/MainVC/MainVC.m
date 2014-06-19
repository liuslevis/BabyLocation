//
//  MainVC.m
//  ParentApp
//
//  Created by Lius on 14-5-9.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import "MainVC.h"
#import "ChildMenuTVC.h"
#import "DavidlauUtils.h"
#import "APIDefine.h"
#import "SingleModel.h"

@interface MainVC ()
@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;
@property (weak, nonatomic) IBOutlet UIButton *btnAddBaby;
@property BOOL isJustLogin;
@end

@implementation MainVC

-(NSArray *)childAvatars{
    if (_childAvatars==nil) {
        _childAvatars = [[NSArray alloc] init];
    }
    return _childAvatars;
}

-(NSArray *)childNameList{
    if (_childNameList==nil) {
        _childNameList = [[NSArray alloc] init];
    }
    return _childNameList;
}

-(NSArray *)childRouteRendererList{
    if (_childRouteRendererList==nil) {
        _childRouteRendererList = [[NSArray alloc] init];
    }
    return _childRouteRendererList;
}

-(NSArray *)childLastLocation{
    if (_childLastLocation==nil) {
        _childLastLocation = [[NSArray alloc] init];
    }
    return _childLastLocation;
}

-(NSArray *)childRouteList{
    if (_childRouteList==nil) {
        _childRouteList = [[NSArray alloc] init];
    }
    return _childRouteList;
}

-(NSArray *)childLocationsList{
    if (_childLocationsList==nil) {
        _childLocationsList = [[NSArray alloc] init];
    }
    return _childLocationsList;
}

- (NSString *)curChildName{
    if ([self.childNameList count]>self.curChildIndex) {
        return (NSString *)[self.childNameList objectAtIndex:self.curChildIndex];
    }
    return nil;
}

- (UIImage *)curChildAvatar{
    if ([self.childAvatars count]>self.curChildIndex) {
        return (UIImage *)[self.childAvatars objectAtIndex:self.curChildIndex];
    }
    return nil;
}

- (NSString *)curChildUid{
    if ([self.childUidList count]>self.curChildIndex) {
        return (NSString *)[self.childUidList objectAtIndex:self.curChildIndex];
    }
    return nil;
}

- (NSString *)childNameForIndex:(int)childIndex{
    if ([self.childNameList count]>childIndex) {
        return (NSString *)[self.childNameList objectAtIndex:childIndex];
    }
    return nil;
}

- (NSString *)childUidForIndex:(int)childIndex{
    if ([self.childUidList count]>childIndex) {
        return (NSString *)[self.childUidList objectAtIndex:childIndex];
    }
    return nil;
}
- (UIImage *)childAvatarForIndex:(int)childIndex{
    if ([self.childAvatars count]>childIndex) {
        return (UIImage *)[self.childAvatars objectAtIndex:childIndex];
    }
    return nil;
}

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
    NSLog(@"MainVC viewDidLoad{");
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    self.isJustLogin = YES;
    self.curChildIndex = 0;
    
    // 设置 MainVC 监听 Model的值，若改变则 self.updateScreen
    [self setKVOFromModel:SingleModel.sharedInstance];

//    if (DEMO_MODE){
//        // 演示使用：直接设置孩子列表
////        self.childUidList = [NSArray arrayWithObjects: @"XiaoKui",@"David",nil];
////        self.childNameList = [NSArray arrayWithObjects: @"小葵",@"小新",nil];
////        self.childAvatars = [NSArray arrayWithObjects: // TODO: change to
////                             [UIImage imageNamed:@"girl"],[UIImage imageNamed:@"boy"], nil];
//    }else{// RELEASE MODE
//}
    NSLog(@"MainVC viewDidLoad}");
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
    if ([[SingleModel sharedInstance].friends count] > 0) {
        NSLog(@"viewWillAppear friend count:%d",[[SingleModel sharedInstance].friends count]);
        self.btnAddBaby.hidden = YES;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"MainVC viewDidAppear{");
    [super viewDidAppear:animated];
    //更新小孩信息，默认选择第一个小孩 显示其位置
    if (self.isJustLogin) {
        self.isJustLogin = NO;
        [self pressUpdateModel:self];
    }else{
        if ([[SingleModel sharedInstance].friends count] > 0) {
            NSLog(@"viewDidAppear friend count:%d",[[SingleModel sharedInstance].friends count]);
            self.btnAddBaby.hidden = YES;
            [self didFinishedSelectChildAtIndex:self.curChildIndex];
        }
    }
    
    NSLog(@"MainVC viewDidAppear}");
}

// 设置KVO，当SingleModel有update，通知MainVC
- (void)setKVOFromModel:(SingleModel *)singleton
{
    [singleton addObserver:self forKeyPath:@"friends" options:0 context:nil];
    [singleton addObserver:self forKeyPath:@"userInfo" options:0 context:nil];
}

// KVO动作,当SingleModel改变，自动更新VC，自动更新屏幕
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"friends"]){
        NSLog(@"MainVC KVO: Model's friends changed, Kids num:%d!",[SingleModel sharedInstance].friends.count );
        
        self.childUidList = [[NSArray alloc] init];
        self.childNameList = [[NSArray alloc] init];
        self.childAvatars = [[NSArray alloc] init];
        // 更新MainVC内的孩子信息
        for (id kidInfo in SingleModel.sharedInstance.friends){
            if(kidInfo){
                NSString *kid_uid = ((UserInfo*)kidInfo).uid ? ((UserInfo*)kidInfo).uid:@"";
                NSString *kid_nickname = ((UserInfo*)kidInfo).nickname ? ((UserInfo*)kidInfo).nickname:@"";
                UIImage *kid_avatar = ((UserInfo*)kidInfo).avatar ? ((UserInfo*)kidInfo).avatar :[UIImage imageNamed:@"happyface"];
                
                self.childUidList = [self.childUidList arrayByAddingObject:kid_uid];
                self.childNameList = [self.childNameList arrayByAddingObject:kid_nickname];
                self.childAvatars = [self.childAvatars arrayByAddingObject:kid_avatar];
            }
        }
        // TODO 更新地图信息
        
    }
    if ([keyPath isEqualToString:@"userInfo"]){
        NSLog(@"MainVC KVO: Model userInfo changed!");

    }
}

// 更新SingleModel的信息，并显示儿童信息
- (IBAction)pressUpdateModel:(id)sender {
    self.btnUpdate.enabled = NO;
    NSLog(@"MainVC pressUpdateModel");

    // 准备等待菊花
    UIActivityIndicatorView __block  *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake (30, 30, 80, 80);
    indicator.center = self.view.center;
    [self.mapView insertSubview:indicator atIndex:100]; // to be on the safe side
    [self.mapView bringSubviewToFront:indicator];
    [indicator startAnimating];
    
    // 异步更新Model的好友列表(Sync 耗时）
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SingleModel sharedInstance] updateSync];
        
        // 任务完成 消除等待菊花
        if ([NSThread isMainThread]) {
            [indicator stopAnimating];
            [indicator removeFromSuperview];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                [indicator removeFromSuperview];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //重新选中孩子
            self.btnUpdate.enabled = YES;
            [self viewDidAppear:YES];
        });
    });
}


//更新主屏信息
-(void)updateScreenInfo{
    NSLog(@"MainVC updateScreenInfo");
    self.navigationItem.title = [self curChildName];
    // 绘制所有孩子的路径
    [self drawAllChildsRouteLine];
    // 绘制所有孩子的Annotation，弹出一个
    [self setChildrensAnnotationsAndPopOne:self];
}

// 按下某个孩子气泡的按钮：发送消息
- (IBAction)pressSendMessage:(id)sender{
    // TODO: find out which kid to send
    [DavidlauUtils alertTitle:@"功能说明" message:@"发送语音，文字消息给孩子客户端" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
}

// 按下某个孩子气泡的按钮：设定安全区域 超出则报警
- (IBAction)pressSetSafetyArea:(id)sender{
    // TODO: find out which kid to send
    [DavidlauUtils alertTitle:@"功能说明" message:@"设定孩子的安全区域，如学校附近2km，超出则通知家长" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
}

// 按下某个孩子气泡的按钮：设定报警方式
- (IBAction)pressSetAlertMode:(id)sender{
    // TODO: find out which kid to send
    [DavidlauUtils alertTitle:@"功能说明" message:@"设置孩子离开安全区域后的报警方式：电话，电邮，短信等等" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
}
// 按键事件：显示当前选中的小孩
- (IBAction)setChildrensAnnotationsAndPopOne:(id)sender {
    NSLog(@"pressShow:查看 %@ 的位置",[self curChildUid]);
    // 添加所有孩子的最后位置Pin focus当前所选的孩子Pin
    [self.mapView removeAnnotations:self.mapView.annotations];
    for (int childIndex = 0; childIndex < [self.childLocationsList count]; childIndex++){
        NSString *childName = [self childNameForIndex:childIndex]?[self childNameForIndex:childIndex]:@"";
        NSString *childUid = [self childUidForIndex:childIndex]?[self childUidForIndex:childIndex]:@"";
        NSString *title = [childName length]>0 ? childName:@"宝贝";
//        NSString *title = [childUid length]>0 ? childUid:@"宝贝";

        NSString *subtitle = @"？分钟之前";
        // 计算多久前
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:APP_DATE_TIME_FORMAT];
        if([SingleModel sharedInstance].friends &&
           self.curChildIndex < [[SingleModel sharedInstance].friends count]){
            UserInfo *kidInfo = [[SingleModel sharedInstance].friends objectAtIndex:self.curChildIndex];
            
            if([kidInfo.lastUpdateDateTime length]==0){
                subtitle = @"无记录";
            }else{
                NSDate *lastUpdateDate = [dateFormat dateFromString:kidInfo.lastUpdateDateTime];
                NSTimeInterval interval = [lastUpdateDate timeIntervalSinceNow];
                subtitle = [DavidlauUtils howLongIsTheInterval:interval];
                if (VERBOSE_MODE) NSLog(@"last update time of kid uid %@ - %@ - %f - lastdate %@", kidInfo.uid, [DavidlauUtils howLongIsTheInterval:interval],interval,kidInfo.lastUpdateDateTime);

            }
            


        }
        // Annotation的图标（笑脸）
        UIImage *childAvatar = [self childAvatarForIndex:childIndex]?[self childAvatarForIndex:childIndex]:[UIImage imageNamed:@"happyface"];
        
        //地图气泡Annotation 放在最后的位置
        NSArray *lastChildLocations =[self.childLocationsList objectAtIndex:childIndex];
        CLLocation *lastLocation = [lastChildLocations lastObject];
        NSLog(@"create child anno:%@ %@", childUid,childName);
        // 注意！Annotation title一定要有内容，不然 气泡不出来
        ChildrenMapAnnotation *childAnnotation = [[ChildrenMapAnnotation alloc] initWithCoordinates:lastLocation.coordinate
                                                                                              title:title subtitle:subtitle
                                                                                               name:childName
                                                                                                uid:childUid
                                                                                             avatar:childAvatar];
        [self.mapView addAnnotation:childAnnotation];
        
        // 如果是当前选中的小孩，则
        if(childIndex == self.curChildIndex){
            [self.mapView selectAnnotation:childAnnotation animated:YES];// 显示气泡
            [self focusOnLocation:lastLocation];// 移动camera到Pin处
        }
        NSLog(@"press show cur childuid:%@", childUid);
    }
    // 同时显示2个小孩。如果注释掉，则只显示选中的小孩
//    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

// camera移动到经纬度location
- (void)focusOnLocation:(CLLocation *)location{
    [self.mapView setCamera:[MKMapCamera cameraLookingAtCenterCoordinate:location.coordinate fromEyeCoordinate:location.coordinate eyeAltitude:5000]];
}

// 从Model读取每个小孩的位置，并添加Overlay (显示轨迹）
- (void)drawAllChildsRouteLine {
    self.childRouteList = [[NSArray alloc] init];
    self.childLocationsList = [[NSArray alloc] init];
    for (int childIndex = 0; childIndex < [SingleModel.sharedInstance.friends count]; childIndex++) {
        // 绘画显示路径 RouteLine
        UserInfo *child = [SingleModel.sharedInstance.friends objectAtIndex:childIndex];
        NSArray *locations = child.history_location;
        if (locations!=nil) {
            MKPolyline *route =[self generateRouteFromLocations:locations];
            route.title = [NSString stringWithFormat:@"%d",childIndex];
            self.childRouteList = [self.childRouteList arrayByAddingObject:route];
            self.childLocationsList = [self.childLocationsList arrayByAddingObject:locations];
        }
    }
    if(VERBOSE_MODE) NSLog(@"MainVC drawAllChildsRouteLine: addOverlays %d", [self.childRouteList count]);
    [self.mapView addOverlays:self.childRouteList];
}

// 生成 MKPolyline routeline
- (MKPolyline *)generateRouteFromLocations:(NSArray *)locations{
    int pointCount = [locations count];
    CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    for (int i = 0; i < pointCount; ++i) {
        CLLocation *location = [locations objectAtIndex:i];
        coordinateArray[i] = [location coordinate];
    }
    return [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
}

#pragma mark - MKMapViewDelegate for Overlap
// TODO: deprecated in iOS 7
// 渲染 overlays，改变路线颜色在这里
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    NSLog(@"call vewForOverLay");
    if([overlay class] == MKPolyline.class)
    {
        MKOverlayView* overlayView = nil;
        MKPolyline* polyline = (MKPolyline *)overlay;
        MKPolylineView  * routeLineView = [[MKPolylineView alloc] initWithPolyline:polyline];
        
        if([polyline.title isEqualToString:@"0"])
        {
            routeLineView.fillColor = [UIColor blueColor];
            routeLineView.strokeColor = [UIColor blueColor];
        }
        else if([polyline.title isEqualToString:@"1"])
        {
            routeLineView.fillColor = [UIColor redColor];
            routeLineView.strokeColor = [UIColor redColor];
        }
        else if([polyline.title isEqualToString:@"2"])
        {
            routeLineView.fillColor = [UIColor orangeColor];
            routeLineView.strokeColor = [UIColor orangeColor];
        }
        else if([polyline.title isEqualToString:@"3"])
        {
            routeLineView.fillColor = [UIColor brownColor];
            routeLineView.strokeColor = [UIColor brownColor];
        }
        else if([polyline.title isEqualToString:@"4"])
        {
            routeLineView.fillColor = [UIColor greenColor];
            routeLineView.strokeColor = [UIColor greenColor];
        }
        else if([polyline.title isEqualToString:@"5"])
        {
            routeLineView.fillColor = [UIColor yellowColor];
            routeLineView.strokeColor = [UIColor yellowColor];
        }
        else{
            routeLineView.fillColor = [UIColor blueColor];
            routeLineView.strokeColor = [UIColor blueColor];
        }
        
        routeLineView.lineWidth = 10;
        routeLineView.lineCap = kCGLineCapSquare;
        overlayView = routeLineView;
        return overlayView;
    } else {
        return nil;
    }
}

#pragma mark - MKMapViewDelegate of Annotation
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView{
    NSLog(@"didSelectAnnotationView");
    // do some lazily job, i.e. download img for view
    if ([aView.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
        NSLog(@"leftCalloutAccessoryView found, do download image: no");
        UIImageView *imageView = (UIImageView *)aView.leftCalloutAccessoryView;
        imageView.image = [self curChildAvatar];
    }else{
        NSLog(@"leftCalloutAccessoryView No");
    }
}

// 地图气泡Annotation
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    if ([annotation isKindOfClass:[ChildrenMapAnnotation class]]) {
        NSString *IDENT = @"Children Annotation";
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:IDENT];
        if(!annotationView)
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:IDENT];
        
        annotationView.annotation = annotation;
        annotationView.canShowCallout = YES;
        
        // Cutom AnnotationView
        
        // 气泡Annotation中的按钮 Multiple UIButtons on right
        /*
        int numOfButton = 3;
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32*numOfButton, 32)];

        UIButton *button =[[UIButton alloc] initWithFrame:CGRectMake(32*0, 0, 32, 32)];
        if([UIImage imageNamed:@"message"])
            [button setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pressSendMessage:) forControlEvents:UIControlEventTouchDown];
        [rightView addSubview:button];

        button =[[UIButton alloc] initWithFrame:CGRectMake(32*1, 0, 32, 32)];
        if([UIImage imageNamed:@"location"])
            [button setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pressSetSafetyArea:) forControlEvents:UIControlEventTouchDown];
        [rightView addSubview:button];

        button =[[UIButton alloc] initWithFrame:CGRectMake(32*2, 0, 32, 32)];
        if([UIImage imageNamed:@"notification"])
            [button setImage:[UIImage imageNamed:@"notification"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pressSetAlertMode:) forControlEvents:UIControlEventTouchDown];
        [rightView addSubview:button];
        
        [annotationView setRightCalloutAccessoryView:rightView];
          */
        
        // Avatar on left 孩子头像
        UIImageView *leftImageView = [[UIImageView alloc] initWithImage:((ChildrenMapAnnotation *)annotation).avatar];
        CGFloat resizedWidth = 48;
        CGFloat resizedHeight = 48;
        leftImageView.frame = CGRectMake(0, 0, resizedWidth, resizedHeight);
        leftImageView.center = leftImageView.superview.center;

        [annotationView setLeftCalloutAccessoryView:leftImageView];
        
        NSLog(@"create viewForAnnotation:%@", ((ChildrenMapAnnotation *)annotation).uid);
        
        return annotationView;
    }
    return nil;
}

# pragma mark set ChildMenuTVC Delegate before Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    id destinationVC = [segue destinationViewController];
    if ([destinationVC isKindOfClass:[ChildMenuTVC class]]) {
        NSLog(@"set childTVC delegate");
        [((ChildMenuTVC *)destinationVC) setDelegate:(id<ChildMenuTVCDelegate>)self];
    }
}

-(void)didFinishedSelectChildAtIndex:(int)index{
    self.curChildIndex = index;
    [self updateScreenInfo];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
