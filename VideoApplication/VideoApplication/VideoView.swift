//
//  VideoView.swift
//  VideoApplication
//
//  Created by 高扬 on 16/1/10.
//  Copyright (c) 2016年 高扬. All rights reserved.
//

import UIKit

class VideoView: ZXVideoView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    lazy var zoomInBtn:UIButton = {
        var btn = self.createNormalButton("VKVideoPlayer_zoom_in")
        btn.snp_makeConstraints(closure: { (make) -> Void in
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.right.equalTo(self.videoBottomArea).offset(-10)
            make.centerY.equalTo(self.videoBottomArea)
        })
        return btn
        }()
    
    lazy var zoomOutBtn:UIButton = {
        var btn = self.createNormalButton("VKVideoPlayer_zoom_out")
        btn.snp_makeConstraints(closure: { (make) -> Void in
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.center.equalTo(self.zoomInBtn)
        })
        return btn
        }()
    
    lazy var playBtn:UIButton = {
        var btn = self.createNormalButton("VKVideoPlayer_play")
        btn.snp_makeConstraints(closure: { (make) -> Void in
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.left.equalTo(self.videoBottomArea).offset(10)
            make.centerY.equalTo(self.videoBottomArea)
        })
        return btn
        }()
    
    lazy var pauseBtn:UIButton = {
        var btn = self.createNormalButton("VKVideoPlayer_pause")
        btn.snp_makeConstraints(closure: { (make) -> Void in
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.center.equalTo(self.playBtn)
        })
        return btn
        }()
    
    lazy var leftLabel:UILabel = {
        var label:UILabel = UICreaterUtils.createLabel(12, UIColor.whiteColor(), "00:00:00", true, self.videoBottomArea)
        label.textAlignment = NSTextAlignment.Center
        label.snp_makeConstraints(closure: { (make) -> Void in
            make.left.equalTo(self.playBtn.snp_right).offset(5)
            make.width.equalTo(50)
            make.centerY.equalTo(self.videoBottomArea)
        })
        return label
        }()
    
    lazy var rightLabel:UILabel = {
        var label:UILabel = UICreaterUtils.createLabel(12, UIColor.whiteColor(), "00:00:00", true, self.videoBottomArea)
        label.textAlignment = NSTextAlignment.Center
        label.snp_makeConstraints(closure: { (make) -> Void in
            make.right.equalTo(self.zoomInBtn.snp_left).offset(-5)
            make.width.equalTo(50)
            make.centerY.equalTo(self.videoBottomArea)
        })
        return label
        }()
    
    private func createNormalButton(url:String)->UIButton{
        var btn = UIButton()
        BatchLoaderUtil.loadFile(url, callBack: { (image, params) -> Void in
            btn.setImage(image, forState: UIControlState.Normal)
        })
//        btn.addTarget(self, action:Selector(action), forControlEvents: UIControlEvents.TouchUpInside)
        self.videoBottomArea.addSubview(btn)
        return btn
    }
    
    lazy var operateView:UIView = {
        var back:UIView = UIView()
        back.backgroundColor = UIColor.clearColor()
        self.addSubview(back)
        back.snp_makeConstraints(closure: { (make) -> Void in
            make.left.right.top.bottom.equalTo(self)
        })
        return back
        }()
    
    lazy var videoBottomArea:UIView = {
        var back:UIView = UIView()
        back.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        self.operateView.addSubview(back)
        back.snp_makeConstraints(closure: { (make) -> Void in
            make.width.bottom.equalTo(self.operateView)
            make.height.equalTo(self.operateView).dividedBy(7)
        })
        return back
        }()
    
    lazy var progressSld:UISlider = {
        var progressView:UISlider = UISlider()
        self.videoBottomArea.addSubview(progressView)
        progressView.minimumValue = 0
        progressView.maximumValue = 1
        progressView.snp_makeConstraints(closure: { (make) -> Void in
            make.left.equalTo(self.leftLabel.snp_right).offset(10)
            make.right.equalTo(self.rightLabel.snp_left).offset(-10)
            make.centerY.equalTo(self.videoBottomArea)
        })
        progressView.minimumTrackTintColor = UIColor.whiteColor() //当前进度颜色
        progressView.maximumTrackTintColor = UIColor.lightGrayColor()//背景色
        progressView.continuous = true
        //        progressView.addTarget(self, action: <#Selector#>, forControlEvents: UIControlEvents.ValueChanged)
        
        BatchLoaderUtil.loadFile("kr-video-player-point", callBack: { (image, params) -> Void in
            progressView.setThumbImage(image, forState: UIControlState.Normal)
        })
        return progressView
        }()
    
    
}
