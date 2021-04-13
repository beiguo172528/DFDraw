//
//  ZPPencilStyleView.m
//  绘图小画板
//
//  Created by ios on 16-1-5.
//  Copyright (c) 2016年 ios. All rights reserved.
//

#import "ZPPencilStyleView.h"
@interface ZPPencilStyleView()

@end

@implementation ZPPencilStyleView

+ (instancetype)pencilStyleView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"ZPPencilStyleView" owner:nil options:nil]lastObject];
}

- (IBAction)Didslide:(UISlider *)sender
{
    if(self.pencilBlock)
    {
        self.pencilBlock(sender.value);
    }
}

@end
