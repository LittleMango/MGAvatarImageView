//
//  MGAvatarImageView.h
//  MGAvatarImageView
//
//  Created by mango on 2017/6/15.
//  Copyright © 2017年 mango. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MGAvatarImageViewType) {
    MGAvatarImageViewTypeAvatar,        //将图片裁剪成正方形
    MGAvatarImageViewTypeOriginScale,   //保持图片的原始尺寸
};

@class MGAvatarImageView;
@protocol MGAvatarImageViewDelegate <NSObject>

- (void)imageView:(MGAvatarImageView *)imageView didSelectImage:(UIImage*)image;


@end
@interface MGAvatarImageView : UIImageView
@property(nonatomic, weak)id<MGAvatarImageViewDelegate> delegate;
/** 图片是否直接使用原始图片的宽高比例，默认是NO*/
@property(nonatomic, assign)MGAvatarImageViewType imageType;

@end
