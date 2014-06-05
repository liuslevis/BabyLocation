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
@property CLLocation *currentLocation;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *focusOnMe;
@end
