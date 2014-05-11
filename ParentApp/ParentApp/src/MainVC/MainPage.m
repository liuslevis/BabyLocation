//
//  MainPage.m
//  sercher
//
//  Created by 林晓杨 on 14-4-28.
//  Copyright (c) 2014年 Xu. All rights reserved.
//

#import "MainPage.h"
#import "IIViewDeckController.h"
#import "QRTest.h"

@implementation MainPage

//@synthesize list;
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

-(void) dealloc {
    [locationManager setDelegate:nil];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    /**/
    self.viewDeckController.leftSize = 240;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Children" style:UIBarButtonItemStyleBordered target:self.viewDeckController action:@selector(toggleLeftView)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:self action:@selector(openSettings:)];
    self.navigationItem.title = @"child's name";
    [myMapView setShowsUserLocation:YES];
    [myMapView setDelegate:self];
}

-(void)setList:(ChildList *)childList {
    list = childList;
}

-(IBAction)test:(id)sender {
    [list addButton];
}

-(IBAction)openSettings:(id)sender {
    NSLog(@"press Settings");
//    QRTest *qrTest = [[QRTest alloc]init];
    
    UIViewController *settingVC = [[UIStoryboard storyboardWithName:@"Setting" bundle:nil] instantiateViewControllerWithIdentifier:@"mainNaviVC"];
    if(settingVC) [self presentViewController:settingVC animated:YES completion:^{}];
}

#pragma mark - Private

- (void)findDirectionsFrom:(MKMapItem *)source
                        to:(MKMapItem *)destination
{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = source;
    request.destination = destination;
    request.requestsAlternateRoutes = YES;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         
         if (error) {
             
             NSLog(@"error:%@", error);
         }
         else {
             
             MKRoute *route = response.routes[0];
             
             [myMapView addOverlay:route.polyline];
         }
     }];
}

#pragma mark - MKMapViewDelegate
//
//- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
//            rendererForOverlay:(id<MKOverlay>)overlay
//{
//    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
//    renderer.lineWidth = 5.0;
//    renderer.strokeColor = [UIColor purpleColor];
//    return renderer;
//}
//
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    _coordinate.latitude = userLocation.location.coordinate.latitude;
//    _coordinate.longitude = userLocation.location.coordinate.longitude;
//    
//    //[self setMapRegionWithCoordinate:_coordinate];
//    
//    CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(31.484137685, 120.371875243);
//    CLLocationCoordinate2D coord2 = CLLocationCoordinate2DMake(32.484044745, 120.371879653);
//    points[0] = MKMapPointForCoordinate(coord1);
//    points[1] = MKMapPointForCoordinate(coord2);
//    MKPolyline *line = [MKPolyline polylineWithPoints:points count:2];
//    [myMapView addOverlay: line];
//    [self setMapRegionWithCoordinate:coord1];
//    Pin *pin = [[Pin alloc] initWithCoordinates:coord1 placeName:@"Start" description:@""];
//    [myMapView addAnnotation:pin];
//}
//
//- (void)setMapRegionWithCoordinate:(CLLocationCoordinate2D)coordinate
//{
//    MKCoordinateRegion region;
//    
//    region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(.1, .1));
//    MKCoordinateRegion adjustedRegion = [myMapView regionThatFits:region];
//    [myMapView setRegion:adjustedRegion animated:YES];
//}
//
//
//
//-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
//    NSLog(@"%@", newLocation);
//}
//
//-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    NSLog(@"Could not find location: %@", error);
//}

@end
