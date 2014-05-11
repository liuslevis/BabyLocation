//
//  MyMapAnnotation.m
//  babylocation
//
//  Created by Lius on 14-4-26.
//  Copyright (c) 2014年 edu.sysu.lxjhjhxf.ios. All rights reserved.
//

#import "ChildrenMapAnnotation.h"

@implementation ChildrenMapAnnotation 

- (id) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
                     title:(NSString *)paramTitle
                  subtitle:(NSString *)paramSubTitle
                      name:(NSString *)name
                       uid:(NSString *)uid
                    avatar:(UIImage *)avatar
{
    
    if (self = [super init]) {
        _coordinate = paramCoordinates;
        _title = [paramTitle copy];
        _subtitle = [paramSubTitle copy];
        _avatar = [avatar copy];
        _name = [name copy];
        _uid = [uid copy];
    }
    
    return self;
}

@end

