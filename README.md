# MGAvatarImageView
从相册选择或者拍照后将图片裁剪成矩形后显示出来
该控件只有两个文件:

`MGAvatarImageView.h`，`MGAvatarImageView.m`

直接继承自`UIImageView`，所以使用过程中可以把它当做`UIImageView`来使用。
## Usage

```
- (void)viewDidLoad {
    [super viewDidLoad];
    MGAvatarImageView *avatarIV = [[MGAvatarImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    avatarIV.delegate = self; //如果控制器需要拿到最终的UIImage对象，则需要代理
    [self.view addSubview:avatarIV];
}

#pragma mark - MGAvatarImageViewDelegate
- (void)imageView:(MGAvatarImageView *)imageView didSelectImage:(UIImage *)image {
    //该方法在用户选中、裁剪完图片之后会将结果传递过来
}
```

