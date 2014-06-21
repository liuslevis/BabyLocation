//
//  MapVC.h
//  BabyApp
//
//  Created by Lius on 14-6-5.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyMapAnnotation.h"
#import "UserAuthAPI.h"

@interface MapVC : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate>
@property CLLocationManager *locationManager;
//@property MyMapAnnotation *myAnnotation;

@property double latitude;
@property double longitude;
@property (strong, nonatomic) CLLocation *currentLocation;// 系统返回坐标
@property CLLocationCoordinate2D currentFixedCoord;// 中国区修正后坐标
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *focusOnMe;

- (void)beginUpdateLocationMovedEvery:(CLLocationDistance)meters;

@end
