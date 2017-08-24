//
//  MGAvatarImageView.m
//  MGAvatarImageView
//
//  Created by mango on 2017/6/15.
//  Copyright © 2017年 mango. All rights reserved.
//

#import "MGAvatarImageView.h"
#import "UIImagePickerController+MGStatusBar.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>

@interface MGAvatarImageView()<UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate>
@property (strong , nonatomic) UIImagePickerController *imagePickerVC;
@property (strong , nonatomic) UITapGestureRecognizer *singleTap;
@property(nonatomic, weak)UIViewController *sourceViewController;
@end
@implementation MGAvatarImageView

#pragma mark - lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_showSheetView)];
        [self addGestureRecognizer:tap];
        [self setNavItemColor:[UIColor blackColor]];
    }
    return self;
}

#pragma mark - accessor
- (UIViewController *)sourceViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)setNavItemColor:(UIColor *)navItemColor {
    _navItemColor = navItemColor;
    UIBarButtonItem *appearance;
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
    appearance = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
#endif
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    appearance = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
#endif
    //设置所有导航条上item的textColor
    NSDictionary *dictNormal = @{
                                 NSForegroundColorAttributeName : _navItemColor,
                                 };
    [appearance setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
}

- (UIColor *)navImageColor {
    return _navImageColor ?: [UIColor blackColor];
}

- (UIColor *)navBarBackgroundColor {
    return _navBarBackgroundColor ?: [UIColor whiteColor];
}

- (UIColor *)sheetTitleColor {
    return _sheetTitleColor ?: [UIColor blackColor];
}

#pragma mark - public method
- (void)show {
    [self p_showSheetView];
}

#pragma mark - private method
- (void)p_showSheetView {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    choiceSheet.delegate = self;
    [choiceSheet showInView:self.sourceViewController.view];
#endif
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_8_0
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    alert.view.tintColor = self.sheetTitleColor;
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self p_cameraAuthorizationCheck];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self p_openPhotoLibrary];
    }]];
    [self.sourceViewController presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)p_cameraAuthorizationCheck {
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        // 判断授权状态
        NSString *mediaType = AVMediaTypeVideo;
        //读取设备授权状态
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if (status == AVAuthorizationStatusRestricted) { // 因为家长控制, 导致应用无法方法相机(跟用户的选择没有关系)
            [self p_showErrorMessage:@"家长控制权限限制使用该功能"];
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
            [self p_showErrorMessage:[NSString stringWithFormat:@"请去-> [设置 - 隐私 - 相机 - %@ 打开访问开关", appName]];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            [self p_openCamera];
        } else if (status == AVAuthorizationStatusNotDetermined) { // 用户还没有做出选择
            // 弹框请求用户授权
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                if (granted) {
                    [self p_openCamera];
                }
            }];
        }
    } else {
        [self p_showErrorMessage:@"该设备没有相机"];
    }
}

- (void)p_openCamera {
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerImage.delegate = self;
    pickerImage.allowsEditing = self.imageType == MGAvatarImageViewTypeAvatar ? YES : NO;
    pickerImage.navigationBar.tintColor = self.navImageColor;
    pickerImage.navigationBar.barTintColor = self.navBarBackgroundColor;
    pickerImage.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : self.navItemColor};
    pickerImage.mg_statusBarStyle = self.statusBarStyle;
    [self.sourceViewController presentViewController:pickerImage animated:YES completion:^{}];
}

- (void)p_openPhotoLibrary {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self p_showErrorMessage:@"该设备没有相册"];
        return;
    }
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    pickerImage.delegate = self;
    pickerImage.allowsEditing = self.imageType == MGAvatarImageViewTypeAvatar ? YES : NO;
    pickerImage.navigationBar.tintColor = self.navImageColor;
    pickerImage.navigationBar.barTintColor = self.navBarBackgroundColor;
    pickerImage.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : self.navItemColor};
    pickerImage.mg_statusBarStyle = self.statusBarStyle;
    [self.sourceViewController presentViewController:pickerImage animated:YES completion:^{}];
}

- (void)p_showErrorMessage:(NSString *)message {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alert show];
#endif
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_8_0
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault
                                                          handler:NULL];
    [alert addAction:defaultAction];
    [self.sourceViewController presentViewController:alert animated:YES completion:nil];
#endif
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            //拍照
            [self p_cameraAuthorizationCheck];
            break;
        case 1:
            //相册
            [self p_openPhotoLibrary];
            break;
    }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    //在高版本中，actionSheet.subviews为空数组对象，苹果限制了，运行在低版本的机子上没问题
    for (UIView *subView in actionSheet.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subView;
            label.textColor = self.sheetTitleColor;
        }
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)subView;
            [button setTitleColor:self.sheetTitleColor forState:UIControlStateNormal];
        }
    }
}
#endif

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image;
        if (self.imageType == MGAvatarImageViewTypeAvatar) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        self.image = image;
        if ([self.delegate respondsToSelector:@selector(imageView:didSelectImage:)]) {
            [self.delegate imageView:self didSelectImage:image];
        }
    }];
}
@end
