//
//  UIImage.h
//  Iat
//
//  Created by Junco on 16-3-11.
//  Copyright (c) 2016年 Friend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (extend)


//按比例改变图片大小
-(UIImage*)changeImageSizeWithOriginalImage:(UIImage*)image percent:(float)percent;
//圆形
-(UIImage*)circleImage:(UIImage*)image;
//截取部分图像
//
-(UIImage*)getSubImage:(CGRect)rect;
//- (UIImage *)getSubImage:(UIImageView*)imageView cropFrame:(CGRect)cropFrame;
//等比例缩放
-(UIImage*)scaleToSize:(CGSize)size;

-(UIImage *)rotateImage:(UIImage *)aImage with:(UIImageOrientation)theorient;

-(UIImage *)fixOrientation:(UIImage *)aImage;

@end
