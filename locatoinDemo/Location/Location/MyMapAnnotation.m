//
//  MyMapAnnotation.m
//  babylocation
//
//  Created by Lius on 14-4-26.
//  Copyright (c) 2014年 edu.sysu.lxjhjhxf.ios. All rights reserved.
//

#import "MyMapAnnotation.h"

@implementation MyMapAnnotation 

- (id) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
                     title:(NSString *)paramTitle
                  subTitle:(NSString *)paramSubTitle
{
    
    if (self = [super init]) {
        _coordinate = paramCoordinates;
        _title = [paramTitle copy];
        _subtitle = [paramSubTitle copy];
    }
    
    return self;
}

@end

