//
//  ViewController.m
//  MGAvatarImageView
//
//  Created by mango on 2017/6/15.
//  Copyright © 2017年 mango. All rights reserved.
//

#import "ViewController.h"
#import "MGAvatarImageView.h"

@interface ViewController ()<MGAvatarImageViewDelegate>
@property(nonatomic, weak)UIImageView *anotherIV;
@property(nonatomic, weak)MGAvatarImageView *avatarIV;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //使用前要先往info.plist中添加Privacy - Camera Usage Description和Privacy - Photo Library Usage Description，具体可以查看该工程的info.plist。
    //MGAvatarImageView使用的语言为本地语言，可以在Project -> info -> Locolizations中添加相应语言
    MGAvatarImageView *avatarIV = [[MGAvatarImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    avatarIV.backgroundColor = [UIColor grayColor];
    avatarIV.delegate = self;
    self.avatarIV = avatarIV;
    [self.view addSubview:avatarIV];
    
    UIImageView *anotherIV = [[UIImageView alloc] initWithFrame:CGRectMake(100, 300, 200, 200)];
    self.anotherIV = anotherIV;
    [self.view addSubview:anotherIV];
}

#pragma mark - MGAvatarImageViewDelegate
- (void)imageView:(MGAvatarImageView *)imageView didSelectImage:(UIImage *)image {
    self.anotherIV.image = image;
}
@end
