# MGAvatarImageView
从相册选择或者拍照后将图片裁剪成矩形后显示出来
该控件只有两个文件:

`MGAvatarImageView.h`，`MGAvatarImageView.m`

直接继承自`UIImageView`，所以使用过程中可以把它当做`UIImageView`来使用。
## Usage

```
- (void)viewDidLoad {
    [super viewDidLoad];
    //最少的配置只需要以下两行代码即可实现所有功能
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
}

#pragma mark - MGAvatarImageViewDelegate
- (void)imageView:(MGAvatarImageView *)imageView didSelectImage:(UIImage *)image {
    //该方法在用户选中、裁剪完图片之后会将结果传递过来
}
```
也可以在合适的地方，比如点击MGAvatarImageView所在TableView的cell的时候，调用`- (void)show`方法弹出Sheet选择列表。

