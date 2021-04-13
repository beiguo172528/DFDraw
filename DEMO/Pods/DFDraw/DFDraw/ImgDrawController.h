//
//  ImgDrawController.h
//  DFDraw
//
//  Created by DOFAR on 2021/4/13.
//

#import <UIKit/UIKit.h>
#import "ImgDrawView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ImgDrawDelegate <NSObject>
- (void)DrawImage: (UIImage * _Nullable)image;
@end

@interface ImgDrawController : UIViewController<UIImagePickerControllerDelegate>
{
    NSInteger DfState;
    NSInteger lineBarState;
    NSInteger colorBarState;
}
@property (nonatomic,weak) id <ImgDrawDelegate> delegate;

@property (weak, nonatomic) IBOutlet ImgDrawView *imgDrawView;

@property (weak, nonatomic) IBOutlet UIButton *DragBtn;
@property (weak, nonatomic) IBOutlet UIButton *DrawBtn;
@property (weak, nonatomic) IBOutlet UIButton *WidthBtn;
@property (weak, nonatomic) IBOutlet UIButton *ColorBtn;
@property (weak, nonatomic) IBOutlet UIButton *UndoBtn;
@property (weak, nonatomic) IBOutlet UIButton *SaveBtn;

@property (strong, nonatomic)   UIBarButtonItem *rightButton;
- (instancetype)initNib;
- (void)setDrawImage:(UIImage *)image;

- (IBAction)DragBtnClick:(id _Nullable)sender;
- (IBAction)DrawBtnClick:(id _Nullable)sender;
- (IBAction)WidthBtnClick:(id)sender;
- (IBAction)ColorBtnClick:(id)sender;
- (IBAction)UndoBtnClick:(id)sender;
- (IBAction)SaveBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView   *colorBar;
@property (weak, nonatomic) IBOutlet UIView *linebar;

@property (weak, nonatomic) IBOutlet UIImageView *sampleImage;
@property (weak, nonatomic) IBOutlet UIImage  *sampleBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;
@property (weak, nonatomic) IBOutlet UIButton *lineBtn;
@property (weak, nonatomic) IBOutlet UIButton *colorButton;

- (IBAction)lineWidthChanged:(UISlider *)sender;
- (IBAction)colorChanged:(UIButton *)sender;
- (IBAction)stateBtnClicked:(id)sender;
- (IBAction)cancelBtnClicked:(id)sender;
- (IBAction)colorButtonClicked:(UIButton *)sender;
- (IBAction)lineBtnClicked:(UIButton *)sender;
- (IBAction)backBtnClicked:(UIButton * _Nullable)sender;


@end

NS_ASSUME_NONNULL_END
