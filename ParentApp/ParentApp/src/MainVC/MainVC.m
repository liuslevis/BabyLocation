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

@synthesize selectedChildIndex=_selectedChildIndex ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)updateScreenInfo{
    // TODO: 添加头像
    self.navigationItem.title = (NSString *)[self.childNameList objectAtIndex:self.selectedChildIndex];
    // 显示孩子位置
    [self pressShow:self];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.mapView.delegate = self;
    
    if (DAVIDDEBUG){
        // 演示使用：直接设置孩子列表
        self.childUidList = [NSArray arrayWithObjects: @"David",@"Mike",nil];
        self.childNameList = [NSArray arrayWithObjects: @"小新",@"小葵",nil];

        self.childAvatars = [NSArray arrayWithObjects: // TODO: change to
                             [UIImage imageNamed:@"boy"],[UIImage imageNamed:@"girl"], nil];
    }else{
        // TODO: 从服务器下载这个家长的孩子列表
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

- (IBAction)pressShow:(id)sender {
    NSLog(@"pressShow:查看 %@ 的位置",[self curChildName]);
    [self showHistoryRouteOfChild:[self curChildUid]];
    // 添加Pin
    ChildrenMapAnnotation *childAnnotation = [[ChildrenMapAnnotation alloc] initWithCoordinates:self.lastLocation.coordinate
                                                                                          title:self.curChildName subtitle:@"2分钟前"
                                                                                           name:self.curChildName
                                                                                            uid:self.curChildUid
                                                                                         avatar:self.curChildAvatar];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:childAnnotation];
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    if(self.mapView.annotations.firstObject){
        [self.mapView selectAnnotation:childAnnotation animated:YES];// 显示气泡
    }
    
    [self focusOnLastLocation];// 移动camera到Pin处
    
}

- (NSString *)curChildName{
    return (NSString *)[self.childNameList objectAtIndex:self.selectedChildIndex];
}

- (UIImage *)curChildAvatar{
    return (UIImage *)[self.childAvatars objectAtIndex:self.selectedChildIndex];
}

- (NSString *)curChildUid{
    return (NSString *)[self.childUidList objectAtIndex:self.selectedChildIndex];
}

- (void)focusOnLastLocation{
    [self.mapView setCamera:[MKMapCamera cameraLookingAtCenterCoordinate:self.lastLocation.coordinate fromEyeCoordinate:self.lastLocation.coordinate eyeAltitude:5000]];
}

#pragma mark Show History Line of a Child
// 显示某人textName的历史轨迹
- (void)showHistoryRouteOfChild:(NSString *)name{
    NSString *url = [NSString stringWithFormat:URL_TRACK_REQ_WITH_NAME,name];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSError *error;
    // TODO: change to Async
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (response==nil) {
        NSLog(@"ERR: no echo from server when query history :%@",url);
        return;
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    NSArray *timeseq = [json objectForKey:@"timeseq"];
    NSArray *longseq = [json objectForKey:@"longseq"];
    NSArray *latseq = [json objectForKey:@"latseq"];
    if ([timeseq count]!=[longseq count] || [longseq count]!=[latseq count] || [timeseq count]==0){
        NSLog(@"WARNING: the track download has wrong format!");
        return;
    }else{// Draw Track
        NSInteger len = [timeseq count];
        NSMutableArray *locations = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i<len; i++) {
//            NSLog(@" ts:%@,lat,long:%@",(NSString *)[timeseq objectAtIndex:i],(NSString *)[longseq objectAtIndex:i]);
            double latitude = [(NSString *)[latseq objectAtIndex:i] doubleValue];
            double longitude= [(NSString *)[longseq objectAtIndex:i] doubleValue];
            [locations addObject:[[CLLocation alloc]
                                  initWithLatitude:latitude
                                  longitude:longitude]];
        }
        // add overlay 画历史轨迹
        [self drawLineWithLocationArray:[locations copy]];
    }
}
// 用PolyLine和位置点画地图
- (void)drawLineWithLocationArray:(NSArray *)locationArray
{
    int pointCount = [locationArray count];
    CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < pointCount; ++i) {
        CLLocation *location = [locationArray objectAtIndex:i];
        coordinateArray[i] = [location coordinate];
        if (i==pointCount-1){
            self.lastLocation = location;
        }
    }
    // a overlay:MKPolyline with many points
    self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    [self.mapView setVisibleMapRect:[self.routeLine boundingMapRect]];
    [self.mapView addOverlay:self.routeLine];
    free(coordinateArray);
    coordinateArray = NULL;
}

#pragma mark - MKMapViewDelegate of Overlap
// provide a renderer for a overlay:routeLine
- (MKPolylineRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if(overlay == self.routeLine) {
        if(nil == self.routeLineRenderer) {
            self.routeLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:self.routeLine] ;
            self.routeLineRenderer.fillColor = [UIColor redColor];
            self.routeLineRenderer.strokeColor = [UIColor redColor];
            self.routeLineRenderer.lineWidth = 5;
        }
        return self.routeLineRenderer;
    }
    return nil;
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
        
        // Create a UIButton object add to AnnotationView
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        [annotationView setRightCalloutAccessoryView:rightButton];
        
        // Avatar on left
        NSString *childName = [(ChildrenMapAnnotation *)annotation name];
        UIImageView *leftImageView = [[UIImageView alloc] initWithImage:((ChildrenMapAnnotation *)annotation).avatar];
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
    self.selectedChildIndex = index;
    [self updateScreenInfo];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
