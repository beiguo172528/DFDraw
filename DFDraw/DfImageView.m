//
//  DrawView.m
//  Test
//
//  Created by Junco on 16/4/26.
//  Copyright © 2016年 Friend. All rights reserved.
//

#import "DfImageView.h"
#import "DrawPath.h"

@interface DfImageView () {
    UIImage *img;
}
@end

@implementation DfImageView

//初始化
- (void)initWithImage: (UIImage *)image {
    img = image;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctxx = UIGraphicsGetCurrentContext();
    //CGFloat scale = [UIScreen mainScreen].scale;

    CGContextScaleCTM(ctxx, self.bounds.size.width/img.size.width, self.bounds.size.height/img.size.height);
    //CGContextTranslateCTM(ctxx, 0, -img.size.height);
    
    // draw original image into the context
    CGRect imageRect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(ctxx, imageRect, img.CGImage);
}



@end
