//
//  ViewController.m
//  DFDraw
//
//  Created by DOFAR on 2021/3/29.
//

#import "ViewController.h"
#import "ImgDrawController.h"

@interface ViewController ()<ImgDrawDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onClickBtn:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ImgDrawController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ImgDrawController"];
    [vc initWithImage:[UIImage imageNamed:@"111"]];
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController: vc animated: YES];
    [self presentViewController:vc animated:YES completion:nil];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)DrawImage: (UIImage *)image{
    NSLog(@"image:%@",image);
}

@end
