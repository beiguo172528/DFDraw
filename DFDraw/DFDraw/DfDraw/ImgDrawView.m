//
//  ImgDrawView.m
//  Iat
//
//  Created by Junco on 16/4/24.
//  Copyright © 2016年 Friend. All rights reserved.
//

#import "ImgDrawView.h"
#import "UIImage.h"
//#import "Utils.h"

#define SWidth  [[UIScreen mainScreen] bounds].size.width
#define SHeight [[UIScreen mainScreen] bounds].size.height
#define BlackViewHeight (SHeight/2-(SWidth/4*3)/2)
#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0  alpha:((c)&0xFF)/255.0]

//全局函数 newBitmapContextSuitableForSize

CGContextRef newBitmapContextSuitableForSize(CGSize size)
{
    //NSLog(@"%s,%d ,%s:   image.width=%0.2f,   image.height=%0.2f",__FILE__,__LINE__,__FUNCTION__,size.width,size.height);
    CGContextRef    context    = NULL;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    context = CGBitmapContextCreate(NULL,
                                    size.width  ,//* scaleFactor,
                                    size.height ,//* scaleFactor,
                                    8,
                                    size.width*4,//* scaleFactor,
                                    colorSpace,
                                    kCGImageAlphaPremultipliedFirst);

    CGColorSpaceRelease( colorSpace );
    return context;
}



@implementation ImgDrawView

- (NSMutableArray *)paths
{
    if (!_paths)
    {
        _paths = [NSMutableArray array];
    }
    return _paths;
}


#pragma mark - DfDrawDelegate
-(void)drawPath: (DrawPath *)path
{
    [self.paths addObject: path];
    
    UIGraphicsPushContext(ctx);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -img.size.height);

    [path.color set];
    path.lineCapStyle  = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    [path stroke];
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -img.size.height);
    UIGraphicsPopContext();

    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    //Modified by minking begin
    //图片质量
    //
    UIImage *retImage = [UIImage imageWithCGImage:cgImage];
    //UIImage *retImage = [UIImage imageWithCGImage:cgImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    //Modified by minking end
    CGImageRelease(cgImage);
    //[dfImageView initWithImage: retImage];
    dfImageView.image = retImage;
}

//初始化
- (void)initWithImage: (UIImage *)image withNavigationbarHeight:(NSInteger)navigationbarHeight
{
    //modified by minking begin
    //修正方向
    img = [image fixOrientation:image];
    
    //dfImageView = [[DfImageView alloc] init];
    dfImageView = [[UIImageView alloc] initWithImage:img];
    self.backgroundColor=[UIColor blackColor];
    [self addSubview: dfImageView];
    
    //[dv initWithImage: image];
    dfImageView.userInteractionEnabled=YES;
    [self addGestureRecognizerToImageView];
 
    //调整显示尺寸
    CGSize screenSize  = [[UIScreen mainScreen] bounds].size;
    
    navbarHeight       = navigationbarHeight;
   //高度减去状态栏，导航条和按钮的高度
    screenSize.height -= navbarHeight + 64+[[UIApplication sharedApplication] statusBarFrame].size.height;
    
    int    orgImageWidth   =  image.size.width;
    int    orgImageHeight  =  image.size.height;
    float  orgImageWidthHeightRate = (float)orgImageWidth/(float)orgImageHeight;
    int    imageViewWidth  =  0;
    int    imageViewHeight =  0;
    int    imageViewLeft   =  0;
    int    imageViewtop    =  navbarHeight+[[UIApplication sharedApplication] statusBarFrame].size.height;
    
    if( orgImageWidth > orgImageHeight )
    {
        imageViewWidth  = screenSize.width;
        imageViewHeight = orgImageWidthHeightRate == 0 ? 0: imageViewWidth / orgImageWidthHeightRate;
        imageViewLeft   = 0;
        imageViewtop    += ( screenSize.height  - navbarHeight - StatusbarHeight - imageViewHeight ) / 2;
        if(imageViewHeight > screenSize.height)
        {
            imageViewHeight  = screenSize.height;
            imageViewWidth   = orgImageWidthHeightRate == 0 ? 0: imageViewHeight * orgImageWidthHeightRate;
            imageViewtop     += 0;
            imageViewLeft    = (screenSize.width - imageViewWidth)/2;
        }
    }
    else
    {
        imageViewHeight    = screenSize.height;
        imageViewWidth     = orgImageWidthHeightRate == 0 ? 0: imageViewHeight * orgImageWidthHeightRate;
        imageViewtop       += 0;
        imageViewLeft      = (screenSize.width - imageViewWidth)/2;
        if(imageViewWidth > screenSize.width)
        {
            
            imageViewWidth  = screenSize.width;
            imageViewHeight = orgImageWidthHeightRate == 0 ? 0: imageViewWidth / orgImageWidthHeightRate;
            imageViewLeft   = 0;
            imageViewtop    += ( screenSize.height  - navbarHeight - StatusbarHeight - imageViewHeight ) / 2;
        }
    }
    
    dfImageView.frame = CGRectMake( imageViewLeft , imageViewtop , imageViewWidth , imageViewHeight);
    //modified by minking end
    
    //imgView.center = self.center;
    _oldImageViewFrame  = dfImageView.frame;
    
    dfDrawView          = [[DfDrawView alloc] init];
    dfDrawView.frame    = dfImageView.frame;
    dfDrawView.center   = self.center;
    dfDrawView.delegate = self;
    dfDrawView.rate     = img.size.width / dfImageView.frame.size.width;
    dfDrawView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.001];
    [self addSubview: dfDrawView];
//    UIPinchGestureRecognizer *pinchGR  = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchImageView:)];
//    [dfDrawView addGestureRecognizer:pinchGR];

    ctx = newBitmapContextSuitableForSize(image.size);
    
    //modified by minking begin
    //CGContextScaleCTM(ctx, 1, -1);
    //CGContextTranslateCTM(ctx, 0, -image.size.height);

    // draw original image into the context
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextDrawImage(ctx, imageRect, image.CGImage);
    /*
    //UIGraphicsPushContext(ctx);

    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    UIImage *retImage = [UIImage imageWithCGImage:cgImage];
    //NSLog(@"%s,%d:   image.width=%0.2f,   image.height=%0.2f",__FILE__,__LINE__,image.size.width,image.size.height);
    //NSLog(@"%s,%d:retImage.width=%0.2f,retImage.height=%0.2f",__FILE__,__LINE__,retImage.size.width,retImage.size.height);
    CGImageRelease(cgImage);

    [dfImageView initWithImage: retImage];
    */
    //Modified by minking end
}

- (UIColor *) getLineColor
{
    return dfDrawView == nil ? nil : dfDrawView.lineColor ;
}

- (void) setLineColor: (UIColor *)lineColor
{
    if (dfDrawView != nil)
    {
        dfDrawView.lineColor = lineColor;
    }
}

- (int) getLineWidth
{
    return dfDrawView == nil ? 0 : dfDrawView.lineWidth ;
}

- (void) setLineWidth:(int)lineWidth
{
    if (dfDrawView != nil)
    {
        dfDrawView.lineWidth = lineWidth ;
    }
}


- (void)drawRect:(CGRect)rect
{
}

-(void)singleTouch
{
    [self setState:DfDraw];
}

//imageView添加手势
-(void)addGestureRecognizerToImageView
{
    /*
    //单指绘图
    UIPanGestureRecognizer *singleFingerDrawGR = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(singleTouch)];
    singleFingerDrawGR.minimumNumberOfTouches = 1;
    singleFingerDrawGR.maximumNumberOfTouches = 1;
//    [imgView addGestureRecognizer:singleFingerDrawGR];
    [dfImageView addGestureRecognizer:singleFingerDrawGR];
    */
    
    //拖动
    UIPanGestureRecognizer   *doubleFingerPanGR    = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImageView:)];
    doubleFingerPanGR.minimumNumberOfTouches = 1;
    doubleFingerPanGR.maximumNumberOfTouches = 1;
    [dfImageView addGestureRecognizer:doubleFingerPanGR];

    //缩放
    //
    UIPinchGestureRecognizer *pinchGR  = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchImageView:)];
    //UIPinchGestureRecognizer *pinchGR  = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [dfImageView addGestureRecognizer:pinchGR];
}

#pragma mark - 手势相关

//拖动
-(void)panImageView:(UIPanGestureRecognizer *) panGR
{
    CGPoint translation = [panGR translationInView: self];
    panGR.view.center   = CGPointMake( panGR.view.center.x + translation.x , panGR.view.center.y + translation.y );
    [panGR setTranslation:CGPointZero inView: self];
    
    if ( panGR.state == UIGestureRecognizerStateEnded )
    {
        [self changeFrameForGestureView:panGR.view];
    }
}

//缩放
-(void)pinchImageView:(UIPinchGestureRecognizer *)pinchGR
{
    pinchGR.view.transform = CGAffineTransformScale(pinchGR.view.transform,pinchGR.scale,pinchGR.scale);
    pinchGR.scale = 1;
    
    if ( pinchGR.state == UIGestureRecognizerStateEnded )
    {
        if ( pinchGR.view.transform.a<1||pinchGR.view.transform.d < 1 )
        {
            [UIView animateWithDuration:0.25 animations:^
            {
                pinchGR.view.transform = CGAffineTransformIdentity;
                pinchGR.view.frame     = self->_oldImageViewFrame;
                pinchGR.view.center    = [UIApplication sharedApplication].delegate.window.center;
            }];
        }
        else
        {
            [self changeFrameForGestureView:pinchGR.view];
        }
    }
}

//新缩放算法 有问题
-(void)handlePinchGesture:(UIPinchGestureRecognizer *)PinchGR
{
    if (PinchGR.state == UIGestureRecognizerStateBegan)
    {
        lastScale = 1.0;
        lastPoint = [PinchGR locationInView:self];
    }
    if ( PinchGR.state == UIGestureRecognizerStateEnded )
    {
        if ( PinchGR.view.transform.a<1||PinchGR.view.transform.d < 1 )
        {
            [UIView animateWithDuration:0.25 animations:^
             {
                 PinchGR.view.transform = CGAffineTransformIdentity;
                 PinchGR.view.frame     = self->_oldImageViewFrame;
                 PinchGR.view.center    = [UIApplication sharedApplication].delegate.window.center;
             }];
            return;
        }
        else
        {
            //[self changeFrameForGestureView:PinchGR.view];
        }
    }
    // Scale
    CGFloat scale = 1.0 - (lastScale - PinchGR.scale);
    [self.layer setAffineTransform:
     CGAffineTransformScale([self.layer affineTransform],
                            scale,
                            scale)];
    lastScale = PinchGR.scale;
    
    // Translate
    CGPoint point = [PinchGR locationInView:self];
    [self.layer setAffineTransform:
     CGAffineTransformTranslate([self.layer affineTransform],
                                point.x - lastPoint.x,
                                point.y - lastPoint.y)];
    lastPoint = [PinchGR locationInView:self];
    
}

//调整手势view的frame
-(void)changeFrameForGestureView:(UIView *)view
{
    CGSize screenSize     = [[UIScreen mainScreen] bounds].size;
    //高度减去导航条和按钮的高度
    screenSize.height -= navbarHeight + 64+[[UIApplication sharedApplication] statusBarFrame].size.height;
    
    int blackViewHeight   = (screenSize.height - _oldImageViewFrame.size.height)/2;
    int topOffset         = navbarHeight+[[UIApplication sharedApplication] statusBarFrame].size.height;
    
    CGRect frame = view.frame;
    
    if ( frame.origin.x > 0 )
    {
        frame.origin.x=0;
        
    }
    
    if ( frame.origin.y > topOffset + blackViewHeight )
    {
        frame.origin.y= topOffset + blackViewHeight;
    }

    if ( CGRectGetMaxX(frame) < screenSize.width )
    {
        frame.origin.x=frame.origin.x + ( screenSize.width - CGRectGetMaxX(frame) );
    }
    if( frame.size.width < screenSize.width)
    {
        frame.origin.x = (screenSize.width - frame.size.width)/2;
    }
    
    if ( CGRectGetMaxY(frame) < ( topOffset + screenSize.height - blackViewHeight ) )
    {
        frame.origin.y =  ( topOffset + screenSize.height - blackViewHeight ) - frame.size.height;
    }
    
    //
    /*
    if (frame.origin.y>BlackViewHeight)
    {
        frame.origin.y=BlackViewHeight;
    }
    if (CGRectGetMaxX(frame)<SWidth)
    {
        frame.origin.x=frame.origin.x+(SWidth-CGRectGetMaxX(frame));
    }
    if (CGRectGetMaxY(frame)<(SHeight-BlackViewHeight))
    {
        frame.origin.y=frame.origin.y+(SHeight-BlackViewHeight-CGRectGetMaxY(frame));
    }
    //*/
    
    [UIView animateWithDuration:0.25 animations:^
    {
        view.frame = frame;
    }];
}

- (void)setState: (DfDrawState)state
{
    DfState = state;
    dfDrawView.hidden = state != DfDraw;
    dfDrawView.frame  = !dfDrawView.hidden ? dfImageView.frame : CGRectMake(0,0,0,0);
    dfDrawView.rate   = img.size.width / dfImageView.frame.size.width;
}

- (DfDrawState)getState
{
    return dfDrawView.hidden ? DfDrag : DfDraw;
}

- (void) undo
{
    [self.paths removeLastObject];
    ctx = newBitmapContextSuitableForSize(img.size);
    // CGContextScaleCTM(ctx, 1, -1);
    // CGContextTranslateCTM(ctx, 0, -img.size.height);
    
    // draw original image into the context
    CGRect imageRect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(ctx, imageRect, img.CGImage);

    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -img.size.height);
    UIGraphicsPushContext(ctx);
    [self.paths enumerateObjectsUsingBlock:^(DrawPath *path, NSUInteger idx, BOOL *stop)
    {
        [path.color set];
        path.lineCapStyle  = kCGLineCapRound;
        path.lineJoinStyle = kCGLineJoinRound;
        [path stroke];
    }];
    UIGraphicsPopContext();
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -img.size.height);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    //Modified by minking begin
    //图片质量
    //
    UIImage *retImage = [UIImage imageWithCGImage:cgImage];
    //UIImage *retImage = [UIImage imageWithCGImage:cgImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    //Modified by minking end
    
    CGImageRelease(cgImage);
    //[dfImageView initWithImage: retImage];
    dfImageView.image = retImage;
    
}

- (UIImage *) getImage
{
    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    //UIImage *retImage = [UIImage imageWithCGImage:cgImage];
    //CGImageRelease(cgImage);

    CGContextRef ctx2 = newBitmapContextSuitableForSize(img.size);
    //CGContextScaleCTM( ctx2, 1, -1 );
    //CGContextTranslateCTM( ctx2, 0, -img.size.height );
    CGRect imageRect  = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage( ctx2, imageRect, cgImage );
    CGImageRelease( cgImage );
    
    cgImage           = CGBitmapContextCreateImage(ctx2);
    //Modified by minking begin
    //图片质量
    //
    UIImage *retImage = [UIImage imageWithCGImage:cgImage];
    //UIImage *retImage = [UIImage imageWithCGImage:cgImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    //Modified by minking end
    CGImageRelease(cgImage);
    
    return retImage;
}

@end
