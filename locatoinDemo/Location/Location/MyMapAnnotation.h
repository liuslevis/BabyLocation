//
//  MyMapAnnotation.h
//  babylocation
//
//  Created by Lius on 14-4-26.
//  Copyright (c) 2014年 edu.sysu.lxjhjhxf.ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface MyMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign, readonly)     CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly)       NSString *title;
@property (nonatomic, copy, readonly)       NSString *subtitle;

- (id) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
                     title:(NSString *)paramTitle
                  subTitle:(NSString *)paramSubTitle;
@end
