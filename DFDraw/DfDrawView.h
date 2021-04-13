//
//  DfDrawView.h
//  Test
//
//  Created by Junco on 16/4/26.
//  Copyright © 2016年 Friend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawPath.h"

@protocol DfDrawDelegate <NSObject>
- (void)drawPath: (DrawPath *)path;
@end

@interface DfDrawView : UIView
@property (nonatomic,weak) id <DfDrawDelegate> delegate;
@property (nonatomic) float rate;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic) int lineWidth;
@end
