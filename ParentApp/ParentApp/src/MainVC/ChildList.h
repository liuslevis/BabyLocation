//
//  ChildList.h
//  sercher
//
//  Created by 林晓杨 on 14-4-28.
//  Copyright (c) 2014年 Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ChildList : UIViewController <UIScrollViewDelegate>
{
    int index;
    int height;
}
-(void) addButton;
@property (nonatomic,retain) UIScrollView *myscrollview;
@end
