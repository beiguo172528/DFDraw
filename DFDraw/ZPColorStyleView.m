//
//  ZPColorStyleView.m
//  绘图小画板
//
//  Created by ios on 16-1-5.
//  Copyright (c) 2016年 ios. All rights reserved.
//

#import "ZPColorStyleView.h"
@interface ZPColorStyleView()

- (IBAction)white:(id)sender;
- (IBAction)red:(id)sender;
- (IBAction)yellow:(id)sender;
- (IBAction)blue:(id)sender;

- (IBAction)green:(id)sender;

- (IBAction)black:(id)sender;

@end

@implementation ZPColorStyleView

+ (instancetype)colorStyleView{
 return [[[NSBundle mainBundle]loadNibNamed:@"ZPColorStyleView" owner:nil options:nil]lastObject];}

- (IBAction)white:(UIButton *)sender {
    if(self.colorBlock){
        self.colorBlock(sender.backgroundColor);
    }
    
}

- (IBAction)red:(UIButton *)sender {
    if(self.colorBlock){
        self.colorBlock(sender.backgroundColor);
    }
    
}

- (IBAction)yellow:(UIButton *)sender {
    if(self.colorBlock){
        self.colorBlock(sender.backgroundColor);
    }
    
}

- (IBAction)blue:(UIButton *)sender {
    if(self.colorBlock){
        self.colorBlock(sender.backgroundColor);
    }
    
}

- (IBAction)green:(UIButton *)sender {
    if(self.colorBlock){
        self.colorBlock(sender.backgroundColor);
    }
    
}

- (IBAction)black:(UIButton *)sender {
    if(self.colorBlock){
        self.colorBlock(sender.backgroundColor);
    }
    
}
@end
