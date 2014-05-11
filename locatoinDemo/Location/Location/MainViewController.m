//
//  MainViewController.m
//  babylocation
//
//  Created by Lius on 14-4-26.
//  Copyright (c) 2014年 edu.sysu.lxjhjhxf.ios. All rights reserved.
//

#import "MainViewController.h"

#define URL_REQ @"http://127.0.0.1:7777/baby/%@/lat/%f/long/%f"
#define URL_TRACK_REQ_WITH_NAME @"http://127.0.0.1:7777/baby/%@/track"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // init the map kit view
    self.mapView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    self.mapView.delegate = self;
    
    self.mapView.showsUserLocation = YES;
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
    
    // add guesture to dismiss keyboard
    UITapGestureRecognizer *tapEmptyArea = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self // target: receive region
                                   action:@selector(dismissKeyboard)]; // action
    [self.view addGestureRecognizer:tapEmptyArea];
}

#pragma mark - Dismiss Keyboard
-(void)dismissKeyboard {
    NSArray *subviews = [self.view subviews];
    for (id objInput in subviews) {
        if ([objInput isKindOfClass:[UITextField class]]) {
            UITextField *theTextField = objInput;
            if ([objInput isFirstResponder]) {
                [theTextField resignFirstResponder];
            }
        }
    }
}
#pragma mark - MKMapViewDelegate
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

#pragma mark - Draw Line using Overlay: Polyline
// 显示某人textName的历史轨迹
- (IBAction)pressShowHistory:(id)sender {
    NSString *name = self.textName.text;
    NSString *url = [NSString stringWithFormat:URL_TRACK_REQ_WITH_NAME,name];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSError *error;
    // TODO: change to Async

    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (response==nil) {
        NSLog(@"ERR: no echo from server when query history");
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
            //            NSLog(@" ts,lat,long:%@",(NSString *)[longseq objectAtIndex:i]);
            
            [locations addObject:[[CLLocation alloc]
                                  initWithLatitude:[(NSString *)[latseq objectAtIndex:i] doubleValue]
                                  longitude:[(NSString *)[longseq objectAtIndex:i] doubleValue]]];
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
    }
    // a overlay:MKPolyline with many points
    self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    [self.mapView setVisibleMapRect:[self.routeLine boundingMapRect]];
    [self.mapView addOverlay:self.routeLine];
    
    free(coordinateArray);
    coordinateArray = NULL;
}

# pragma mark - MKMapViewDelegate Setting Annotation
// 显示我的位置 用大头针
- (IBAction)pressShowMyLocation:(id)sender {
    // Dismiss Keyboard
    [self dismissKeyboard];
    [self.view endEditing:YES];
    
    // set camera
    [self.mapView setCamera:[MKMapCamera cameraLookingAtCenterCoordinate:self.current.coordinate fromEyeCoordinate:self.current.coordinate eyeAltitude:5000]];
    // set annotation
//    [self.mapView removeAnnotations:self.mapView.annotations];
//    [self.mapView addAnnotation:[[MyMapAnnotation alloc] initWithCoordinates:self.current.coordinate title:@"您" subTitle:@"您的位置"]];
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView{
    NSLog(@"didSelectAnnotationView");
    // do some lazily job, i.e. download img for view
//    aView.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://cdn.v2ex.com/avatar/f3f5/9212/60952_large.png"]]];

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    NSLog(@"viewForAnno");
    NSString *IDENT = annotation.subtitle;
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:IDENT];
    if(!aView)
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                reuseIdentifier:IDENT];

    // set canShowCallout to YES and build aView’s callout accessory views here
    aView.annotation = annotation; // yes, this happens twice if no dequeue
    // maybe load up accessory views here (if not too expensive)?
    // or reset them and wait until mapView:didSelectAnnotationView: to load actual data

    return aView;
}

#pragma mark - Uploading My Location

// 实时上传我的位置
- (IBAction)pressUpdateLocation:(id)sender {
    NSLog(@"pressUpdateLocation!");
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled] ) {
        if(self.locationManager==nil){
            self.locationManager = [[CLLocationManager alloc] init] ;
            self.locationManager.delegate = self;
        }else {
            //提示用户无法进行定位操作
            NSLog(@"CLLocationMng init Failed! Check GPS!");
        }
    }
    
    // 设置精度
    //    [self.locationManager desiredAccuracy];
    // 设置位移通知 didUpdateLocations
    self.locationManager.distanceFilter = 10;// notify me only 100m passed
    
    // 开始定位
    [self.locationManager startUpdatingLocation];
    NSLog(@" start updating loation!");
}

# pragma mark - CLLocationManagerDelegation
# pragma mark get notified when moved
// 位移通知的delegate method
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    CLLocationCoordinate2D coor = currentLocation.coordinate;
    self.latitude =  coor.latitude;
    self.longitude = coor.longitude;
    NSLog(@" update loation lat:%f long:%f",self.latitude,self.longitude);
    
    // TODO: Pack it up.
    // Send RESTful request , tell server where i am
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:URL_REQ,self.textName.text,self.latitude,self.longitude]];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:nil];
    NSLog(@" Query:%@",url);
    
    // Calc Distance (Not accurate. Not official method)
    self.before = self.current;
    self.current = [locations lastObject];
    CLLocationDistance meters=[self.current distanceFromLocation:self.before];
    NSLog(@" move %f m",meters);
    
    // press show my location
//    [self pressShowMyLocation:self];
    
}

// Location更新失败的方法
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
        NSLog(@"ERROR:update location failed");
    }
}



#pragma mark - Stop Uploading My Location
// 停止上传我的位置
- (IBAction)pressStopUpdatingMyLocation:(id)sender {
    NSLog(@"pressed stop update!");
    [self.locationManager stopUpdatingLocation];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
