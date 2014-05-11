//
//  MyMapAnnotation.h
//  babylocation
//
//  Created by Lius on 14-4-26.
//  Copyright (c) 2014年 edu.sysu.lxjhjhxf.ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface ChildrenMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign, readonly)     CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly)       NSString *title;
@property (nonatomic, copy, readonly)       NSString *subtitle;
@property (nonatomic, copy, readonly)       NSString *name;
@property (nonatomic, copy, readonly)       NSString *uid;
@property (nonatomic, copy, readonly)       UIImage *avatar;

- (id) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
                     title:(NSString *)paramTitle
                  subtitle:(NSString *)paramSubTitle
                    name:(NSString *)name
                     uid:(NSString *)uid
                     avatar:(UIImage *)avatar;

@end
