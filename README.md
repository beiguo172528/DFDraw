部分功能如图：
 ![img](https://github.com/beiguo172528/DFDraw/blob/main/img/dfdrawGif.gif)
 
功能:
为了实现在app中，为已知图片为背景 在图上进行画图操作。可以选择线条粗细，及颜色。以及图片缩放等


步骤：
1.pod
pod 'DFDraw'

2.import
#import "ImgDrawController.h"

3. 创建
ImgDrawController *vc = [[ImgDrawController alloc]initNib];

2.加载图片
[vc setDrawImage:[UIImage imageNamed:@"111"]];
vc.delegate = self;

3.显示
[self presentViewController:vc animated:YES completion:nil];

4.返回图片
- (void)DrawImage: (UIImage *)image{
    NSLog(@"image:%@",image);
}


GitHub:https://github.com/beiguo172528

简书:https://www.jianshu.com/u/48c545d8fd58
