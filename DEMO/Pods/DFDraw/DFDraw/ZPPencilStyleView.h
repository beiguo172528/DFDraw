//
//  ZPPencilStyleView.h
//  绘图小画板
//
//  Created by ios on 16-1-5.
//  Copyright (c) 2016年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPPencilStyleView : UIView
@property(nonatomic,copy)void(^pencilBlock)(CGFloat width);

+ (instancetype)pencilStyleView;
@end
