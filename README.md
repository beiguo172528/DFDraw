部分功能如图：

 ![img](https://github.com/beiguo172528/DFDraw/blob/main/img/111.jpeg)
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

