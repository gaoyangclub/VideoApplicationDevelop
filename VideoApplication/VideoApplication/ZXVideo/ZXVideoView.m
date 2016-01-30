//
//  ZXVideoView.m
//  demo
//
//  Created by shaw on 15/7/25.
//  Copyright (c) 2015年 shaw. All rights reserved.
//-----------------显示视频的view-----------------------

#import "ZXVideoView.h"

@implementation ZXVideoView

+(Class)layerClass
{
    return [AVPlayerLayer class];
}

-(AVPlayer *)player
{
    return [(AVPlayerLayer *)self.layer player];
}

-(void)setPlayer:(AVPlayer *)player
{
    [(AVPlayerLayer *)self.layer setPlayer:player];
}

-(void)setFillMode:(NSString *)fillMode
{
    [(AVPlayerLayer *)self.layer setVideoGravity:fillMode];
}

////加载进度
- (CMTimeRange)getCMTimeRange
{
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    if ([loadedTimeRanges count] > 0) {
        CMTimeRange timeRange = [[loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
        return timeRange;
    }else{
        CMTimeRange a;
        return a;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
