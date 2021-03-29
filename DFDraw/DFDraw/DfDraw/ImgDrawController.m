//
//  ViewController.m
//  Test
//
//  Created by Junco on 16/4/21.
//  Copyright © 2016年 Friend. All rights reserved.
//

#import "ImgDrawController.h"
#import "ZPColorStyleView.h"
#import "ZPPencilStyleView.h"
#import "Masonry.h"
#import "UIImage.h"
//#import "Utils.h"

#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0  alpha:((c)&0xFF)/255.0]
#define PI 3.14159265358979323846

@interface ImgDrawController ()
{
    CGContextRef iconCg;
    UIImage *img;
}

@end

@implementation ImgDrawController

- (void) initWithImage: (UIImage *) image
{
    //修正图片方向
    img = [image fixOrientation:image];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [_imgDrawView initWithImage: img withNavigationbarHeight:self.navigationController.navigationBar.frame.size.height];
    [self.view sendSubviewToBack: _imgDrawView];

    //图标绘图上下文
    iconCg = newBitmapContextSuitableForSize( CGSizeMake(30, 30) );
    
    [_WidthBtn setImage: [self drawWidthIcon: [_imgDrawView getLineWidth]] forState:UIControlStateNormal];
    [_ColorBtn setImage: [self drawColorIcon: [_imgDrawView getLineColor]] forState:UIControlStateNormal];
    [self setBtnState];
    //modified by minking begin
    self.rightButton = [[UIBarButtonItem alloc]
                        initWithTitle:@"保存"
                        style:UIBarButtonItemStylePlain
                        target:self
                        action:@selector(SaveBtnClick:)
                        ];
    [self setNavbuttonEnable:YES];
    [self DrawBtnClick:nil];
    
    // 禁用返回手势,需要开启只需设置为yes即可。默认开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    _colorBar.layer.cornerRadius    = 16;
    _linebar.layer.cornerRadius     = 16;
    
    _sampleImage.layer.cornerRadius = 15;
    //_sampleImage.layer.borderWidth  = 1;
    _sampleImage.layer.borderColor  = [[UIColor lightGrayColor] CGColor];
 
    _cancelBtn.layer.cornerRadius   = 5;
    //_cancelBtn.layer.borderWidth    = 1;
    _cancelBtn.layer.borderColor    = [[UIColor lightGrayColor] CGColor];

    _stateBtn.layer.cornerRadius    = 5;
    //_stateBtn.layer.borderWidth     = 1;
    _stateBtn.layer.borderColor     = [[UIColor lightGrayColor] CGColor];
    
    _colorButton.layer.cornerRadius = 5;
    //_colorButton.layer.borderWidth  = 1;
    _colorButton.layer.borderColor  = [[UIColor lightGrayColor] CGColor];
    
    _lineBtn.layer.cornerRadius     = 5;
    //_lineBtn.layer.borderWidth      = 1;
    _lineBtn.layer.borderColor      = [[UIColor lightGrayColor] CGColor];
    
    _colorBar.hidden    = YES;
    _linebar.hidden     = YES;
    _sampleImage.image = [self drawSampleIcon:[UIColor redColor] lineWidth:4];
    lineBarState   = 0;
    colorBarState  = 0;

    _WidthBtn.hidden = YES;
    _ColorBtn.hidden = YES;
    _SaveBtn.hidden  = YES;
    _DragBtn.hidden  = YES;
    _DrawBtn.hidden  = YES;
    _UndoBtn.hidden  = YES;
    
    
    DfState = DfDraw;
    //modified by minking end
}

-(void)setNavbuttonEnable:(BOOL)enable
{
    if(enable)
    {
        self.navigationItem.rightBarButtonItem = self.rightButton;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = NULL;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setBtnState
{
    //[self.DragBtn setImage: [UIImage imageNamed: [self.drawView getState] == DfDrag ? @"draw_drag.png" : @"draw_drag_l.png"] forState: UIControlStateNormal];
    //[self.DrawBtn setImage: [UIImage imageNamed: [self.drawView getState] == DfDraw ? @"draw_draw.png" : @"draw_draw_l.png"] forState: UIControlStateNormal];
    [self.DragBtn setImage: [UIImage imageNamed: [self.imgDrawView getState] == DfDrag ? @"drag_enable" : @"drag_disable"] forState: UIControlStateNormal];
    [self.DrawBtn setImage: [UIImage imageNamed: [self.imgDrawView getState] == DfDraw ? @"draw_enable" : @"draw_disable"] forState: UIControlStateNormal];

    [self.DragBtn setTitleColor: [self.imgDrawView getState] == DfDrag ? [UIColor whiteColor] : [UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.DrawBtn setTitleColor: [self.imgDrawView getState] == DfDraw ? [UIColor whiteColor] : [UIColor lightGrayColor] forState:UIControlStateNormal];
}


- (IBAction)DragBtnClick:(id)sender
{
    [self.imgDrawView setState: DfDrag];
    [self setBtnState];
}

- (IBAction)DrawBtnClick:(id)sender
{
    [self.imgDrawView setState: DfDraw];
    [self setBtnState];
}

- (IBAction)WidthBtnClick:(id)sender
{
    ZPPencilStyleView *pencilView = [ZPPencilStyleView pencilStyleView];
    pencilView.layer.borderColor  = [[UIColor lightGrayColor] CGColor];
    pencilView.layer.borderWidth  = 2;
    [self.view addSubview:pencilView];
    [self.view setUserInteractionEnabled:YES];
    __weak typeof(self) weakSelf = self;
    [pencilView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(self->_ColorBtn.mas_top).offset(-64);
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.right.equalTo(weakSelf.view.mas_right).offset(0);
        make.bottom.equalTo(self->_ColorBtn.mas_top).offset(0);
    }];
    
    __block ZPPencilStyleView *pencil = pencilView;
    [pencilView setPencilBlock:^(CGFloat width)
    {
        
        [self->_WidthBtn setImage: [self drawWidthIcon: width] forState: UIControlStateNormal];
        [self->_imgDrawView setLineWidth: width];
        [pencil removeFromSuperview];
    }];
}

- (IBAction)ColorBtnClick:(id)sender
{
    ZPColorStyleView *view = [ZPColorStyleView colorStyleView];
    view.layer.borderColor  = [[UIColor lightGrayColor] CGColor];
    view.layer.borderWidth  = 2;
   [self.view addSubview:view];
    __weak typeof(self) weakSelf = self;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(self->_ColorBtn.mas_top).offset(-64);
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.right.equalTo(weakSelf.view.mas_right).offset(0);
        make.bottom.equalTo(self->_ColorBtn.mas_top).offset(0);
    }];
    
    __block ZPColorStyleView *colorStyle = view;
    [view setColorBlock:^(UIColor *color)
    {
        [self->_ColorBtn setImage: [self drawColorIcon: color] forState: UIControlStateNormal];
        [self->_imgDrawView setLineColor: color];
        [colorStyle removeFromSuperview];
    }];
}

- (IBAction)UndoBtnClick:(id)sender
{
    [_imgDrawView undo];
}

- (IBAction)SaveBtnClick:(id)sender
{
    UIImage *image = [_imgDrawView getImage];
    if (_delegate)
    {
        if ([_delegate respondsToSelector:@selector(DrawImage:)])
        {
            [_delegate DrawImage:image];
            [self.navigationController popViewControllerAnimated: YES];
        }
        else
        {
            NSLog(@"%s,%d, %s \nCDPImageCropDelegate的confirmClickWithImage:方法未设置",__FILE__,__LINE__,__FUNCTION__);
        }
    }
    else
    {
        NSLog(@"%s,%d, %s \nCDPImageCropDelegate未设置",__FILE__,__LINE__,__FUNCTION__);
    }
}

- (UIImage *)drawWidthIcon: (int)width
{
    //UIGraphicsPushContext(widthIcon);
    //UIGraphicsBeginImageContext(CGSizeMake(30, 30));
    //CGContextScaleCTM(widthIcon, 1, -1);
    //CGContextTranslateCTM(widthIcon, 0, -30);
    //CGContextClearRect(widthIcon, CGRectMake(0, 0, 30, 30));
    
    //CGContextSetLineWidth(widthIcon, 3);
    //CGContextMoveToPoint(widthIcon, 0, 1);
    //CGContextAddLineToPoint(widthIcon, 29, 1);
    
    CGContextSetFillColorWithColor(iconCg, [UIColor greenColor].CGColor);
    
    //CGContextSetFillColorWithColor(widthIcon, [UIColor colorWithRed:.2 green:.2 blue:.2  alpha:1].CGColor);
    //CGContextFillRect(widthIcon, CGRectMake(0,t,30,h));
    //CGContextFillPath(widthIcon);
    
    int t = 0;
    for ( int i = 0 ; i < 3 ; ++i )
    {
        CGContextSetFillColor(iconCg, CGColorGetComponents([[UIColor colorWithRed:.2 green:.2 blue:.2  alpha:1] CGColor]) );
        CGContextFillRect(iconCg, CGRectMake(0,t,30,3));
        t += 3;
        if ( ( width + 2 ) / 3 - 1 == i)
        {
            //CGContextSetFillColor(iconCg, CGColorGetComponents([[UIColor colorWithRed:1 green:0 blue:0  alpha:1] CGColor]) );
            CGContextSetFillColor(iconCg, CGColorGetComponents([[UIColor colorWithRed:0 green:191.0f/255 blue:1  alpha:1] CGColor]) );
        }
        else
        {
            CGContextSetFillColor(iconCg, CGColorGetComponents([[UIColor colorWithRed:.5 green:.5 blue:.5  alpha:1] CGColor]) );
        }
        int h = (i+1)*3;
        CGContextFillRect(iconCg, CGRectMake(0,t,30,h));
        t += h;
    }
    CGContextSetFillColor(iconCg, CGColorGetComponents([[UIColor colorWithRed:.2 green:.2 blue:.2  alpha:1] CGColor]) );
    CGContextFillRect(iconCg, CGRectMake(0,t,30,3));
    

    //CGContextScaleCTM(widthIcon, 1, -1);
    //CGContextTranslateCTM(widthIcon, 0, -30);
    //UIGraphicsEndImageContext();
    //UIGraphicsPopContext();
    
    CGImageRef cgImage   = CGBitmapContextCreateImage(iconCg);
    UIImage   *retImage  = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return retImage;
}

- (UIImage *)drawColorIcon: (UIColor *)color
{
    CGContextClearRect(iconCg, CGRectMake(0, 0, 30, 30));
    //CGContextSetRGBStrokeColor(iconCg, 1,1,1,1.0);//画笔线的颜色
    CGContextSetRGBStrokeColor(iconCg, 0,191.0f/255,1,1.0);//画笔线的颜色
    CGContextSetLineWidth(iconCg, 1.0);//线的宽度
    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
    //CGContextAddArc(widthIcon, 15, 15, 15, 0, 2*PI, 0); //添加一个圆
    //CGContextDrawPath(widthIcon, kCGPathStroke); //绘制路径
    
    //填充圆，无边框
    //CGContextAddArc(widthIcon, 15, 15, 15, 0, 2*PI, 0); //添加一个圆
    //CGContextDrawPath(widthIcon, kCGPathFill);//绘制填充
    
    //画大圆并填充颜
    CGContextSetFillColorWithColor(iconCg, color.CGColor);//填充颜色
    CGContextSetLineWidth(iconCg, 3.0);//线的宽度
    CGContextAddArc(iconCg, 15, 15, 14, 0, 2*PI, 0); //添加一个圆
    //kCGPathFill填充非零绕数规则,kCGPathEOFill表示用奇偶规则,kCGPathStroke路径,kCGPathFillStroke路径填充,kCGPathEOFillStroke表示描线，不是填充
    CGContextDrawPath(iconCg, kCGPathFillStroke); //绘制路径加填充
    
    CGImageRef cgImage = CGBitmapContextCreateImage(iconCg);
    UIImage *retImage  = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return retImage;
}

//
- (UIImage *)drawSampleIcon: (UIColor *)color lineWidth:(CGFloat)linewidth
{
    CGContextClearRect(iconCg, CGRectMake(0, 0, 30, 30));
    //画大圆并填充颜
    CGContextSetFillColorWithColor(iconCg, color.CGColor);
    //CGContextSetFillColorWithColor(iconCg, [UIColor redColor].CGColor);//填充颜色
    CGContextSetRGBStrokeColor(iconCg, 0,0,0,0.5);//画笔线的颜色
    CGContextSetLineWidth(iconCg, 1.0);//线的宽度
    CGContextAddArc(iconCg, 15, 15, linewidth, 0, 2*PI, 0); //添加一个圆
    //kCGPathFill填充非零绕数规则,kCGPathEOFill表示用奇偶规则,kCGPathStroke路径,kCGPathFillStroke路径填充,kCGPathEOFillStroke表示描线，不是填充
    CGContextDrawPath(iconCg, kCGPathFillStroke); //绘制路径加填充
    
    CGImageRef cgImage  = CGBitmapContextCreateImage(iconCg);
    UIImage   *retImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return retImage;
}

- (IBAction)lineWidthChanged:(UISlider *)sender
{
    CGFloat width = sender.value;
    [_imgDrawView setLineWidth: width];
    _sampleImage.image = [self drawSampleIcon:[_imgDrawView getLineColor] lineWidth:[_imgDrawView getLineWidth]];
    //_linebar.hidden = YES;
}

- (IBAction)colorChanged:(UIButton *)sender
{
    UIColor *color = sender.backgroundColor;
    [_imgDrawView setLineColor: color];
    _sampleImage.image = [self drawSampleIcon:[_imgDrawView getLineColor] lineWidth:[_imgDrawView getLineWidth]];
    _colorBar.hidden   = YES;
    colorBarState      = 0;
 
}

-(void)setDrawEnable:(BOOL)disable
{
    _colorBar.hidden    = YES;
    _linebar.hidden     = YES;
    _colorButton.hidden = !disable;
    _lineBtn.hidden     = !disable;
    _sampleImage.hidden = !disable;
    _cancelBtn.hidden = !disable;
}

- (IBAction)stateBtnClicked:(id)sender
{
    DfState = 1 - DfState;
    if(DfState == DfDraw)
    {
        [_stateBtn setImage:[UIImage imageNamed:@"draw_drag"] forState:UIControlStateNormal];
        [self setDrawEnable:YES];
        [self DrawBtnClick:nil];
    }
    else
    {
        [_stateBtn setImage:[UIImage imageNamed:@"draw_draw"] forState:UIControlStateNormal];
        [self setDrawEnable:NO];
        [self DragBtnClick:nil];
    }
}

- (IBAction)cancelBtnClicked:(id)sender
{
    [_imgDrawView undo];
}

- (IBAction)colorButtonClicked:(UIButton *)sender
{
    colorBarState    = 1 - colorBarState;
    _colorBar.hidden = (colorBarState == 0);
}

- (IBAction)lineBtnClicked:(UIButton *)sender
{
    lineBarState     = 1 - lineBarState;
    _linebar.hidden  = (lineBarState == 0);
}

@end
