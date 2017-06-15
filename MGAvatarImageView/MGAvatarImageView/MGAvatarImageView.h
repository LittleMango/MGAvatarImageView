//
//  MGAvatarImageView.h
//  MGAvatarImageView
//
//  Created by mango on 2017/6/15.
//  Copyright © 2017年 mango. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGAvatarImageView;
@protocol MGAvatarImageViewDelegate <NSObject>

- (void)imageView:(MGAvatarImageView *)imageView didSelectImage:(UIImage*)image;


@end
@interface MGAvatarImageView : UIImageView
@property(nonatomic, weak)id<MGAvatarImageViewDelegate> delegate;


@end
