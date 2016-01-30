//
//  ZXVideoView.h
//  demo
//
//  Created by shaw on 15/7/25.
//  Copyright (c) 2015年 shaw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ZXVideoView : UIControl

@property (nonatomic,strong) AVPlayer *player;

-(void)setFillMode:(NSString *)fillMode;
//获取加载进度
-(CMTimeRange)getCMTimeRange;

@end
