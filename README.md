部分功能如图：
原图：
 ![img](https://github.com/beiguo172528/DFDraw/blob/main/img/111.jpeg)
 
 操作效果图：
 ![img](https://github.com/beiguo172528/DFDraw/blob/main/img/1C46FDDA-0DE0-4ADB-A063-E255BF36A7E2.png)
 ![img](https://github.com/beiguo172528/DFDraw/blob/main/img/CBC80614-3F6D-4F74-AAEA-0A72DB5BE3F1.png)
 ![img](https://github.com/beiguo172528/DFDraw/blob/main/img/E7A10C9D-3B8D-4100-9667-6010A42F7EE7.png)
 
功能:
为了实现在app中，为已知图片为背景 在图上进行画图操作。可以选择线条粗细，及颜色。以及图片缩放等


步骤：
1. 创建
ImgDrawController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ImgDrawController"];

2.加载图片
[vc initWithImage:[UIImage imageNamed:@"111"]];
vc.delegate = self;

3.显示
[self presentViewController:vc animated:YES completion:nil];

4.返回图片
- (void)DrawImage: (UIImage *)image{
    NSLog(@"image:%@",image);
}


GitHub:https://github.com/beiguo172528
简书:https://www.jianshu.com/u/48c545d8fd58
