//
//  MapVC.m
//  BabyApp
//
//  Created by Lius on 14-6-5.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import "MapVC.h"
#import "MainViewController.h"
#import "AppConstants.h"

@interface MapVC ()
@end

@implementation MapVC

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
    // Do any additional setup after loading the view.
    
    // Init MapKitView
    self.mapView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    self.mapView.delegate = self;
    
    self.mapView.showsUserLocation = YES;
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
    
    // Begin Update My Location, every 20m
    [self beginUpdateLocationMovedEvery:UPDATE_LOCATION_EVERY_METERS];
}

- (IBAction)showMe:(id)sender
{
    [self focusMyLocation];
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
- (void)beginUpdateLocationMovedEvery:(CLLocationDistance)meters {
    NSLog(@"beginUpdateLocationMovedEvery:%f meters!",meters);
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
    self.locationManager.distanceFilter = meters;// notify me only 100m passed
    
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
    self.currentLocation = [locations lastObject];

    CLLocationCoordinate2D coor = self.currentLocation.coordinate;
    self.latitude =  coor.latitude;
    self.longitude = coor.longitude;
    NSLog(@" update loation lat:%f long:%f",self.latitude,self.longitude);
    
    // Send RESTful request , tell server where i am
    NSString *uid = [MainViewController getUid];
    [UserAuthAPI updateLocationWithUid:uid atCLLocation:self.currentLocation];
    
    // Focus on my location
    [self focusMyLocation];
}

- (void)focusMyLocation
{
    NSLog(@"focus on me");
    // set camera
    [self.mapView setCamera:[MKMapCamera cameraLookingAtCenterCoordinate:self.currentLocation.coordinate fromEyeCoordinate:self.currentLocation.coordinate eyeAltitude:5000]];
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


#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView{
    NSLog(@"didSelectAnnotationView");
    // do some lazily job, i.e. download img for view
}


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
