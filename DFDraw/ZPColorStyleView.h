//
//  ZPColorStyleView.h
//  绘图小画板
//
//  Created by ios on 16-1-5.
//  Copyright (c) 2016年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPColorStyleView : UIView
@property(nonatomic,copy)void(^colorBlock)(UIColor *color);
+ (instancetype)colorStyleView;
@end
