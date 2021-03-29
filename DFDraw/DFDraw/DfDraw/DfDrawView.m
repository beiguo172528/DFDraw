//
//  DfDrawView.m
//  Test
//
//  Created by Junco on 16/4/26.
//  Copyright © 2016年 Friend. All rights reserved.
//

#import "DfDrawView.h"
#import "DrawPath.h"
//#import "Utils.h"

@interface DfDrawView() {
    DrawPath *path;
    DrawPath *path2;
}
@end

@implementation DfDrawView

- (id) init {
    if (self = [super init]) {
        _lineColor = [UIColor redColor];
        _lineWidth = 4;
    }
    return self;
}

//触摸事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    
    CGPoint loc = [touch locationInView:touch.view];
    
    path = [[DrawPath alloc] init];
    path.color = self.lineColor; //HEXCOLOR(0xFFFF0000);
    path.lineWidth = self.lineWidth;
    [path moveToPoint:loc];
    
    path2 = [[DrawPath alloc] init];
    path2.color = self.lineColor; //HEXCOLOR(0xFFFF0000);
    path2.lineWidth = self.lineWidth;
    [path2 moveToPoint: CGPointMake(loc.x * self.rate, loc.y * self.rate)];

    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    
    CGPoint loc = [touch locationInView:touch.view];
    //[path addLineToPoint:loc];
    CGPoint cp = CGPointMake((loc.x+path.currentPoint.x)/2, (loc.y+path.currentPoint.y)/2);
    [path addQuadCurveToPoint: loc controlPoint: cp];
    CGPoint loc2 = CGPointMake(loc.x * self.rate, loc.y * self.rate);
    //[path2 addLineToPoint: loc2];
    cp = CGPointMake((loc2.x+path2.currentPoint.x)/2, (loc2.y+path2.currentPoint.y)/2);
    [path2 addQuadCurveToPoint: loc2 controlPoint: cp];
    
    [self setNeedsDisplay];
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(drawPath:)]) {
            [_delegate drawPath: path2];
        }
        else {
            NSLog(@"%s,%d, %s \nDfDrawDelegate的drawPath:方法未设置",__FILE__,__LINE__,__FUNCTION__);
        }
    }
    else{
        NSLog(@"%s,%d, %s \nDfDrawDelegate未设置",__FILE__,__LINE__,__FUNCTION__);
    }

    [path closePath];
    path = nil;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (path != nil) {
        [path.color set];
        path.lineCapStyle = kCGLineCapRound;
        path.lineJoinStyle = kCGLineJoinRound;
        [path stroke];
    }
}

@end
