//
//  ViewController.m
//  DFDraw
//
//  Created by DOFAR on 2021/4/13.
//

#import "ViewController.h"
#import "ImgDrawController.h"

@interface ViewController ()<ImgDrawDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onClickBtn:(id)sender {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ImgDrawController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ImgDrawController"];
    ImgDrawController *vc = [[ImgDrawController alloc]initNib];
//    ImgDrawController *vc = [[[NSBundle mainBundle]loadNibNamed:@"ImgDrawController" owner:self options:nil] lastObject];
    [vc setDrawImage:[UIImage imageNamed:@"111"]];
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController: vc animated: YES];
//    [self presentViewController:vc animated:YES completion:nil];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)DrawImage: (UIImage *)image{
    NSLog(@"image:%@",image);
    self.imgV.image = image;
}

@end
