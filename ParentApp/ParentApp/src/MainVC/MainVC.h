//
//  MainVC.h
//  ParentApp
//
//  Created by Lius on 14-5-9.
//  Copyright (c) 2014年 edu.sysu.davidlau.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MKMapView.h>
#import <MapKit/MKPolyline.h>
#import <MapKit/MKPolylineRenderer.h>
#import <CoreLocation/CoreLocation.h>

#import "IIViewDeckController.h"
#import "ChildList.h"
#import "MainPage.h"
#import "AppConstants.h"
#import "ChildrenMapAnnotation.h"
#import "ChildMenuTVC.h"
#import "ChildMenuTVCDelegate.h"
//#import "MyMapAnnotation.h"

@interface MainVC : UIViewController < CLLocationManagerDelegate,MKMapViewDelegate,ChildMenuTVCDelegate>

@property (strong, nonatomic) NSArray *childNameList; // names of children of parent, array of NSString *
@property (strong, nonatomic) NSArray *childUidList; // uid of each child, array of NSString *
@property (strong, nonatomic) NSArray *childAvatars; // images of each child, array of UIImage
@property (strong, nonatomic) NSArray *childRouteList; // array of MKPolyline for each children
@property (strong, nonatomic) NSArray *childLocationsList; // array of CLLocation[] for each children
@property (strong, nonatomic) NSArray *childRouteRendererList; // array of MKPolyline for children
@property (strong, nonatomic) NSArray *childLastLocation; // array of CLLocation*

@property (nonatomic) int curChildIndex; // which children is chosen in ChildMenu, KVO this

@property CLLocation *lastLocation; // properties for the chosen child 
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (NSString *)curChildName;
- (NSString *)curChildUid;
-(void)didFindishedSelectChildAtIndex:(int)index;
@end
