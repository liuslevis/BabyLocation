//
//  MainPage.h
//  sercher
//
//  Created by 林晓杨 on 14-4-28.
//  Copyright (c) 2014年 Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ChildList.h"

@interface MainPage : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    
    IBOutlet MKMapView *myMapView;
    IBOutlet UIButton *test;
    
    ChildList *list;
    CLLocationCoordinate2D _coordinate;
    
    MKMapPoint points[2];
}

-(IBAction)test:(id)sender;
-(void) setList:(ChildList*)childList;

@end
