//
//  MainViewController.h
//  babylocation
//
//  Created by Lius on 14-4-26.
//  Copyright (c) 2014年 edu.sysu.lxjhjhxf.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyMapAnnotation.h"

@interface MainViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate>
@property CLLocationManager *locationManager;
//@property MyMapAnnotation *myAnnotation;

@property double latitude;
@property double longitude;
@property CLLocation *current;
@property CLLocation *before;
@property MKPolyline *routeLine;

@property MKPolylineRenderer *routeLineRenderer;


@property (weak, nonatomic) IBOutlet UITextField *textName;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end
