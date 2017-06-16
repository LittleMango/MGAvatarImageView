//
//  ViewController.m
//  MGAvatarImageView
//
//  Created by mango on 2017/6/15.
//  Copyright © 2017年 mango. All rights reserved.
//

#import "ViewController.h"
#import "MGAvatarImageView.h"

#define MatchaColor [UIColor colorWithRed:199/255.0 green:203/255.0 blue:189/255.0 alpha:1]

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
    [self.view addSubview:avatarIV];
    
    //以下属性属于选填，可以不设置，不设置则采用默认值
    avatarIV.delegate = self;
    avatarIV.navItemColor = [UIColor redColor]; //默认为blackColor
    avatarIV.navImageColor = [UIColor redColor]; //默认为blackColor
    avatarIV.navBarBackgroundColor = MatchaColor; //默认为whiteColor
    avatarIV.sheetTitleColor = [UIColor redColor]; //默认为blackColor
    avatarIV.imageType = MGAvatarImageViewTypeAvatar; //默认为MGAvatarImageViewTypeAvatar
    avatarIV.statusBarStyle = UIStatusBarStyleLightContent; // 默认为UIStatusBarStyleDefault
    self.avatarIV = avatarIV;
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.avatarIV.backgroundColor = [UIColor grayColor];
    UIImageView *anotherIV = [[UIImageView alloc] initWithFrame:CGRectMake(100, 300, 200, 200)];
    self.anotherIV = anotherIV;
    [self.view addSubview:anotherIV];
}

#pragma mark - MGAvatarImageViewDelegate
- (void)imageView:(MGAvatarImageView *)imageView didSelectImage:(UIImage *)image {
    self.anotherIV.image = image;
}

@end
