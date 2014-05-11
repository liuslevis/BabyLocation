//
//  MainVC.m
//  ParentApp
//
//  Created by Lius on 14-5-9.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import "MainVC.h"
#import "ChildMenuTVC.h"

@interface MainVC ()
@property (weak, nonatomic) IBOutlet UIView *placeHolder;
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
    [super viewDidLoad];
    self.mapView.delegate = self;
    
    if (DAVIDDEBUG){
        // 演示使用：直接设置孩子列表
        self.childUidList = [NSArray arrayWithObjects: @"XiaoKui",@"David",nil];
        self.childNameList = [NSArray arrayWithObjects: @"小葵",@"小新",nil];
        self.childAvatars = [NSArray arrayWithObjects: // TODO: change to
                             [UIImage imageNamed:@"girl"],[UIImage imageNamed:@"boy"], nil];
    }else{
        // TODO: 从服务器下载这个家长的孩子信息列表  若下载失败 提示 （移出ViewDidLoad）
        
    }
    // 默认选择第一个小孩 显示其位置
    [self updateScreenInfo];
    
    
#pragma mark 这是在NaviVC里添加childVC，成功(把下面pragma mark后注释掉可以看见这个
//    UIViewController *child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"child2"];
//    [self addChildViewController:child2];
//    [child2 didMoveToParentViewController:self];
//    // match the child size to its parent
//    CGRect frame = child2.view.frame;
//    frame.size.height = CGRectGetHeight(self.placeHolder.frame)-200;
//    frame.size.width = CGRectGetWidth(self.placeHolder.frame)-200;
//    child2.view.frame = frame;
//    [self.placeHolder addSubview:child2.view];
    
#pragma mark 这是在NaviVC里添加DeckView作为childVC，失败
//    ChildList* childList = [[ChildList alloc] initWithNibName:nil bundle:nil];
//    [childList addButton];
//    [childList addButton];
//    MainPage* main = [[MainPage alloc] initWithNibName:nil bundle:nil];
//    UIViewController *centerController = main;
//    centerController = [[UINavigationController alloc] initWithRootViewController:centerController];
//    IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:centerController
//                                                                                    leftViewController:childList
//                                                                                   rightViewController:nil];
//    deckController.rightSize = 0;
//    //main.list = childList;
//    [main setList:childList];
//    [deckController disablePanOverViewsOfClass:NSClassFromString(@"_UITableViewHeaderFooterContentView")];
//    
//    // Embedded in Navi View
//    [self addChildViewController:deckController];
//    [deckController didMoveToParentViewController:self];
//    // match the child size to its parent
//    frame = deckController.view.frame;
//    frame.size.height = CGRectGetHeight(self.placeHolder.frame);
//    frame.size.width = CGRectGetWidth(self.placeHolder.frame);
//    deckController.view.frame = frame;
//    [self.placeHolder addSubview:deckController.view];
}


//更新主屏信息
-(void)updateScreenInfo{
    self.navigationItem.title = (NSString *)[self curChildName];
    // 下载所有孩子的位置
    [self pressUpdateAllChildsRouteLine:self];
    // 显示孩子位置
    [self pressShowCurrentChild:self];
    
}

// 按键事件：显示当前选中的小孩
- (IBAction)pressShowCurrentChild:(id)sender {
    NSLog(@"pressShow:查看 %@ 的位置",[self curChildName]);
    // 添加所有孩子的最后位置Pin focus当前所选的孩子Pin
    [self.mapView removeAnnotations:self.mapView.annotations];
    for (int childIndex = 0; childIndex < [self.childLocationsList count]; childIndex++){
        NSString *childName = [self childNameForIndex:childIndex];
        NSString *childUid = [self childUidForIndex:childIndex];
        UIImage *childAvatar = [self childAvatarForIndex:childIndex];
        NSArray *lastChildLocations =[self.childLocationsList objectAtIndex:childIndex];
        CLLocation *lastLocation = [lastChildLocations lastObject];
        ChildrenMapAnnotation *childAnnotation = [[ChildrenMapAnnotation alloc] initWithCoordinates:lastLocation.coordinate
                                                                                              title:childName subtitle:@"2分钟前"
                                                                                               name:childName
                                                                                                uid:childUid
                                                                                             avatar:childAvatar];
        [self.mapView addAnnotation:childAnnotation];
        
        // 如果是当前选中的小孩，则
        if(childIndex == self.curChildIndex){
            [self.mapView selectAnnotation:childAnnotation animated:YES];// 显示气泡
            [self focusOnLocation:lastLocation];// 移动camera到Pin处
        }
    }
    // 同时显示2个小孩。如果注释掉，则只显示选中的小孩
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

- (void)focusOnLocation:(CLLocation *)location{
    [self.mapView setCamera:[MKMapCamera cameraLookingAtCenterCoordinate:location.coordinate fromEyeCoordinate:location.coordinate eyeAltitude:5000]];
}

#pragma mark Show History Line of a Child
// 下载并返回某人textName的历史轨迹
// return: NSArray of CLLocation*
- (NSArray *)downloadHistoryRouteOfChild:(int)childIndex{
    NSString *url = [NSString stringWithFormat:URL_TRACK_REQ_WITH_NAME,[self childUidForIndex:childIndex]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSError *error;
    // TODO: change to Async
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (response==nil) {
        NSLog(@"ERR: no echo from server when query history :%@",url);
        return nil;
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    NSArray *timeseq = [json objectForKey:@"timeseq"];
    NSArray *longseq = [json objectForKey:@"longseq"];
    NSArray *latseq = [json objectForKey:@"latseq"];
    if ([timeseq count]!=[longseq count] || [longseq count]!=[latseq count] || [timeseq count]==0){
        NSLog(@"WARNING: the track download has wrong format!");
        return nil;
    }else{// Draw Track
        NSInteger len = [timeseq count];
        NSLog(@"获得%@的轨迹，记录数量:%d",[self childNameForIndex:childIndex],len);
        NSMutableArray *locations = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i<len; i++) {
//            NSLog(@" ts:%@,lat,long:%@",(NSString *)[timeseq objectAtIndex:i],(NSString *)[longseq objectAtIndex:i]);
            double latitude = [(NSString *)[latseq objectAtIndex:i] doubleValue];
            double longitude= [(NSString *)[longseq objectAtIndex:i] doubleValue];
            [locations addObject:[[CLLocation alloc]
                                  initWithLatitude:latitude
                                  longitude:longitude]];
        }
        return [locations copy];
    }
}

// 按钮事件：下载每个小孩的位置，并添加Overlay (显示轨迹）
- (IBAction)pressUpdateAllChildsRouteLine:(id)sender {
    for (int childIndex = 0; childIndex < [self.childUidList count]; childIndex++) {
        // 下载、绘画显示路径 RouteLine
        NSArray *locations = [self downloadHistoryRouteOfChild:childIndex];
        if (locations!=nil) {
            MKPolyline *route =[self generateRouteFromLocations:locations];
            route.title = [NSString stringWithFormat:@"%d",childIndex];
            self.childRouteList = [self.childRouteList arrayByAddingObject:route];
            self.childLocationsList = [self.childLocationsList arrayByAddingObject:locations];
        }
    }
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
        else
        {
            routeLineView.fillColor = [UIColor orangeColor];
            routeLineView.strokeColor = [UIColor orangeColor];
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
        NSLog(@"leftCalloutAccessoryView found, do download image: yes");
//        UIImageView *imageView = (UIImageView *)aView.leftCalloutAccessoryView;
//        imageView.image = [self curChildAvatar];
    }else{
        NSLog(@"leftCalloutAccessoryView No");
    }
}

// 地图气泡Annotation
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    if ([annotation isKindOfClass:[ChildrenMapAnnotation class]]) {
        
        NSLog(@"viewForAnnotation");
        
        NSString *IDENT = @"Children Annotation";
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:IDENT];
        if(!annotationView)
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:IDENT];
        
        annotationView.annotation = annotation;
        annotationView.canShowCallout = YES;
        
        // Cutom AnnotationView
        
        // Multiple UIButtons on right
        int numOfButton = 4;
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32*numOfButton, 32)];
//        for (int i=0; i<numOfButton; i++){
//            UIButton *button =[[UIButton alloc] initWithFrame:CGRectMake(32*i, 0, 32, 32)];
//            [button setBackgroundColor:[UIColor redColor]];
//            [rightView addSubview:button];
//        }
        UIButton *button =[[UIButton alloc] initWithFrame:CGRectMake(32*0, 0, 32, 32)];
        [button setBackgroundColor:[UIColor redColor]];
        [rightView addSubview:button];

        button =[[UIButton alloc] initWithFrame:CGRectMake(32*1, 0, 32, 32)];
        [button setBackgroundColor:[UIColor blueColor]];
        [rightView addSubview:button];

        button =[[UIButton alloc] initWithFrame:CGRectMake(32*2, 0, 32, 32)];
        [button setBackgroundColor:[UIColor orangeColor]];
        [rightView addSubview:button];

        button =[[UIButton alloc] initWithFrame:CGRectMake(32*3, 0, 32, 32)];
        [button setBackgroundColor:[UIColor yellowColor]];
        [rightView addSubview:button];

        [annotationView setRightCalloutAccessoryView:rightView];
        
//        CGRect rect = annotationView.bounds;
//        NSLog(@"x=%f y=%f h=%f w=%f",rect.origin.x,rect.origin.y,rect.size.height,rect.size.width);

        // Avatar on left 孩子头像 BUG
        UIImageView *leftImageView = [[UIImageView alloc] initWithImage:((ChildrenMapAnnotation *)annotation).avatar];
        CGFloat resizedWidth = 48;
        CGFloat resizedHeight = 48;
        leftImageView.frame = CGRectMake(0, 0, resizedWidth, resizedHeight);
        leftImageView.center = leftImageView.superview.center;

        [annotationView setLeftCalloutAccessoryView:leftImageView];
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

-(void)didFindishedSelectChildAtIndex:(int)index{
    self.curChildIndex = index;
    [self updateScreenInfo];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
