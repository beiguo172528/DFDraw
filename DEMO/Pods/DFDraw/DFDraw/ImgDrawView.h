//
//  ImgDrawView.h
//  Iat
//
//  Created by Junco on 16/4/24.
//  Copyright © 2016年 Friend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawPath.h"
#import "DfImageView.h"
#import "DfDrawView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

// 导航栏（navigationbar）尺寸
#define NavbarWidth  self.navigationController.navigationBar.frame.size.width
#define NavbarHeight self.navigationController.navigationBar.frame.size.height

// 状态栏(statusbar)尺寸
#define StatusbarWidth  [[UIApplication sharedApplication] statusBarFrame].size.width
#define StatusbarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

CGContextRef newBitmapContextSuitableForSize(CGSize size);

typedef NS_OPTIONS(NSUInteger, DfDrawState)
{
    DfDrag     = 0,          // 0
    DfDraw     = 1 << 0,     // 1
};

@interface ImgDrawView : UIView <DfDrawDelegate>
{
    CGContextRef ctx;
    UIImage *img;
    //DfImageView *dfImageView;
    UIImageView *dfImageView;
    DfDrawView  *dfDrawView;

    CGRect     _oldImageViewFrame;
    NSInteger  navbarHeight;
    CGFloat    lastScale;
    CGPoint    lastPoint;
    NSInteger  DfState;
}
@property (nonatomic, strong) NSMutableArray *paths;

//初始化
- (void)initWithImage: (UIImage *)image withNavigationbarHeight:(NSInteger)navigationbarHeight;

- (void)setState: (DfDrawState)state;
- (DfDrawState)getState;

- (UIColor *) getLineColor;
- (void)      setLineColor: (UIColor *)lineColor;

- (int)  getLineWidth;
- (void) setLineWidth:(int)lineWidth;

- (void) undo;

- (UIImage *) getImage;

@end
