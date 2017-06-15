//
//  MGAvatarImageView.m
//  MGAvatarImageView
//
//  Created by mango on 2017/6/15.
//  Copyright © 2017年 mango. All rights reserved.
//

#import "MGAvatarImageView.h"


@interface MGAvatarImageView()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
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
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_imageViewDidTap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}


- (UIViewController *)sourceViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - private method
- (void)p_imageViewDidTap {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.sourceViewController.view];
#endif
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_8_0
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self p_openCamera];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self p_openPhotoLibrary];
    }]];
    [self.sourceViewController presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)p_openCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self p_showErrorMessage:@"该设备没有相机"];
        return;
    }
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerImage.delegate = self;
    pickerImage.allowsEditing = self.imageType == MGAvatarImageViewTypeAvatar ? YES : NO;
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
    NSLog(@"index:%ld", buttonIndex);
    switch (buttonIndex) {
        case 0:
            //拍照
            [self p_openCamera];
            break;
        case 1:
            //相册
            [self p_openPhotoLibrary];
            break;
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
