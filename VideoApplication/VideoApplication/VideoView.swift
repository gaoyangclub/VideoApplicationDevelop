//
//  VideoView.swift
//  VideoApplication
//
//  Created by 高扬 on 16/1/10.
//  Copyright (c) 2016年 高扬. All rights reserved.
//

import UIKit
import CoreLibrary

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
        btn.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.width.height.equalTo(24)
            make.right.equalTo(self!.videoBottomArea).offset(-10)
            make.centerY.equalTo(self!.videoBottomArea)
        })
        return btn
        }()
    
    lazy var zoomOutBtn:UIButton = {
        var btn = self.createNormalButton("VKVideoPlayer_zoom_out")
        btn.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.width.height.equalTo(24)
            make.center.equalTo(self!.zoomInBtn)
        })
        return btn
        }()
    
    lazy var playBtn:UIButton = {
        var btn = self.createNormalButton("VKVideoPlayer_play")
        btn.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.width.height.equalTo(24)
            make.left.equalTo(self!.videoBottomArea).offset(10)
            make.centerY.equalTo(self!.videoBottomArea)
        })
        return btn
        }()
    
    lazy var pauseBtn:UIButton = {
        var btn = self.createNormalButton("VKVideoPlayer_pause")
        btn.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.width.height.equalTo(24)
            make.center.equalTo(self!.playBtn)
        })
        return btn
        }()
    
    lazy var leftLabel:UILabel = {
        var label:UILabel = UICreaterUtils.createLabel(12, UIColor.whiteColor(), "00:00", true, self.videoBottomArea)
        label.textAlignment = NSTextAlignment.Center
        label.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.left.equalTo(self!.playBtn.snp_right).offset(5)
            make.width.equalTo(50)
            make.centerY.equalTo(self!.videoBottomArea)
        })
        return label
        }()
    
    lazy var rightLabel:UILabel = {
        var label:UILabel = UICreaterUtils.createLabel(12, UIColor.whiteColor(), "00:00", true, self.videoBottomArea)
        label.textAlignment = NSTextAlignment.Center
        label.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.right.equalTo(self!.zoomInBtn.snp_left).offset(-5)
            make.width.equalTo(50)
            make.centerY.equalTo(self!.videoBottomArea)
        })
        return label
        }()
    
    private func createNormalButton(url:String)->UIButton{
        let btn = UIButton()
        BatchLoaderForSwift.loadFile(url, callBack: { [weak self](image) -> Void in
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
        back.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.left.right.top.bottom.equalTo(self!)
        })
        return back
        }()
    
    lazy var videoCenterArea:UIView = {
        var back:UIView = UIView()
//        back.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        self.addSubview(back)
        back.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.width.equalTo(self!)
            make.top.equalTo(self!.videoTopArea.snp_bottom)
            make.bottom.equalTo(self!.videoBottomArea.snp_top)
        })
        return back
    }()
    
    func showCenterAreaToSide(){
        videoCenterArea.snp_removeConstraints()
        videoCenterArea.snp_makeConstraints { [weak self](make) -> Void in
            make.left.right.equalTo(self!)
            make.top.bottom.equalTo(self!)
        }
    }
    func showCenterAreaToBase(){
        videoCenterArea.snp_removeConstraints()
        videoCenterArea.snp_updateConstraints { [weak self](make) -> Void in
            make.left.right.equalTo(self!)
            make.top.equalTo(self!.videoTopArea.snp_bottom)
            make.bottom.equalTo(self!.videoBottomArea.snp_top)
        }
    }
    
    lazy var videoTopArea:UIView = {
        var back:UIView = UIView()
        back.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        self.operateView.addSubview(back)
        back.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.width.top.equalTo(self!.operateView)
            make.height.equalTo(self!.operateView).dividedBy(7)
        })
        return back
    }()
    
    lazy var videoBottomArea:UIView = {
        var back:UIView = UIView()
        back.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        self.operateView.addSubview(back)
        back.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.width.bottom.equalTo(self!.operateView)
            make.height.equalTo(self!.operateView).dividedBy(7)
        })
        return back
        }()
    
    lazy var loadingArea:UIView = {
        var back:UIView = UIView()
        back.hidden = true
        back.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        self.addSubview(back)
        back.layer.cornerRadius = 5
        back.snp_makeConstraints(closure: { [weak self](make) -> Void in
//            make.width.height.greaterThanOrEqualTo(self).dividedBy(5)
            make.width.height.greaterThanOrEqualTo(80)
            make.center.equalTo(self!)
        })
        return back
    }()
    
    lazy var loadingActivityView:UIActivityIndicatorView = {
        var activityView:UIActivityIndicatorView = UIActivityIndicatorView()
        self.loadingArea.addSubview(activityView)
        activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge//显示风格
//        activityView.startAnimating()//激活指示器
        
//        activityView.hidesWhenStopped = true //停止后自动隐藏
        //        activityView.stopAnimating()//停止指示器
        activityView.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.left.right.top.bottom.equalTo(self!.loadingArea)
        })
        return activityView
    }()
    
    func showLoading(){
        loadingArea.hidden = false
        loadingActivityView.startAnimating()
        let app:UIApplication = UIApplication.sharedApplication()
        app.networkActivityIndicatorVisible = true //设置系统左上角网络活动指示器加载 一般不用专门设置
    }
    
    func hideLoading(){
        loadingArea.hidden = true
        loadingActivityView.stopAnimating()//停止指示器
        let app:UIApplication = UIApplication.sharedApplication()
        app.networkActivityIndicatorVisible = false //设置系统左上角网络活动指示器加载 一般不用专门设置
    }
    
    lazy var downloadLabel:UILabel = {
        var label:UILabel = UICreaterUtils.createLabel(12, UIColor.whiteColor(), "0b/s", true, self.operateView)
//        label.textAlignment = NSTextAlignment.Center
        label.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.left.equalTo(self!.operateView).offset(50)
            make.bottom.equalTo(self!.videoBottomArea.snp_top).offset(-10)
        })
        return label
    }()
    
    lazy var centerTipsArea:UIView = {
        var back:UIView = UIView()
        back.hidden = true
        back.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        self.addSubview(back)
        back.layer.cornerRadius = 5
        back.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.width.height.greaterThanOrEqualTo(self!).dividedBy(3)
            make.width.greaterThanOrEqualTo(140)
            make.height.greaterThanOrEqualTo(80)
            make.center.equalTo(self!)
        })
        return back
        }()
    
    lazy var centerTimeLabel:UILabel = {
        var label:UILabel = UICreaterUtils.createLabel(40, UIColor.whiteColor(), "+00:00", true, self.centerTipsArea)
        label.textAlignment = NSTextAlignment.Center
//        label.frame = CGRectMake(0, 0, 140, 80)
//        label.center = self.centerTipsArea.center
        label.minimumScaleFactor = 10
//        label.adjustsFontSizeToFitWidth = true
//        label.numberOfLines = 1
//        label.baselineAdjustment = UIBaselineAdjustment.AlignCenters
//        label.backgroundColor = UIColor.brownColor()
        label.snp_makeConstraints(closure: { [weak self](make) -> Void in
//            make.height.equalTo(self.centerTipsArea)
//            make.width.equalTo(self.centerTipsArea).offset(-10)
            make.center.equalTo(self!.centerTipsArea)
//            make.baseline.equalTo(self.centerTipsArea)
//            label.adjustsFontSizeToFitWidth = true
        })
        return label
        }()
    
    lazy var centerProgressLabel:UILabel = {
        let tempView:UIView = UIView()
        self.centerTipsArea.addSubview(tempView)
//        tempView.backgroundColor = UIColor.brownColor()
        tempView.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.left.right.equalTo(self!.centerTipsArea)
            make.top.equalTo(self!.centerTimeLabel.snp_bottom)
            make.bottom.equalTo(self!.centerProgressView.snp_top)
        })
        var label:UILabel = UICreaterUtils.createLabel(14, UIColor.lightGrayColor(), "00:00:00/00:00:00", true, tempView)
        label.textAlignment = NSTextAlignment.Center
//        label.adjustsFontSizeToFitWidth = true
        label.snp_makeConstraints(closure: { [weak self](make) -> Void in
//            make.width.equalTo(tempView).offset(-10)
            make.center.equalTo(tempView)
        })
        return label
        }()
    
    lazy var centerProgressView:UIProgressView = {
        let pView = UIProgressView()
        pView.userInteractionEnabled = false //无法交互
        self.centerTipsArea.addSubview(pView)
        pView.progress = 0
        pView.trackTintColor = UICreaterUtils.colorBlack
        pView.progressTintColor = UIColor.orangeColor()
        //        pView.setProgress(0, animated: false)
        pView.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.height.equalTo(2)
            make.left.right.bottom.centerX.equalTo(self!.centerTipsArea)
        })
        return pView
        }()
    
    lazy var progressSld:UISlider = {
        var progressView:UISlider = UISlider()
        self.videoBottomArea.addSubview(progressView)
        progressView.minimumValue = 0
        progressView.maximumValue = 1
        progressView.minimumTrackTintColor = UIColor.orangeColor()//UIColor.whiteColor() //当前进度颜色
        progressView.maximumTrackTintColor = UIColor.clearColor()//UIColor.lightGrayColor()//背景色
        progressView.continuous = true
        //        progressView.addTarget(self, action: <#Selector#>, forControlEvents: UIControlEvents.ValueChanged)
        
        BatchLoaderForSwift.loadFile("kr-video-player-point", callBack: { [weak self](image) -> Void in
            progressView.setThumbImage(image, forState: UIControlState.Normal)
        })
        return progressView
        }()
    
    lazy var bufferView:UIProgressView = {
        let pView = UIProgressView()
        self.videoBottomArea.addSubview(pView)
        pView.progress = 0
        pView.trackTintColor = UIColor.clearColor()//FlatUIColors.silverColor(alpha: 1)//UIColor.orangeColor()
        pView.progressTintColor = UIColor.lightGrayColor()//UIColor.whiteColor().darkerColor()
//        pView.setProgress(0, animated: false)
        return pView
        }()
    
    private lazy var backLineView:UIView = {
        let pView = UIView()
        pView.backgroundColor = UICreaterUtils.colorBlack
        self.videoBottomArea.addSubview(pView)
        return pView
    }()
    
    //进度条布局
    func layoutProgressView(){
        backLineView.snp_makeConstraints { [weak self](make) -> Void in
            make.left.equalTo(self!.leftLabel.snp_right).offset(10)
            make.right.equalTo(self!.rightLabel.snp_left).offset(-10)
            make.centerY.equalTo(self!.videoBottomArea)
            make.height.equalTo(2)
        }
        
        bufferView.snp_makeConstraints(closure: { [weak self](make) -> Void in //[unown self]
            make.left.right.height.centerY.equalTo(self!.backLineView)
        })
        
        progressSld.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.left.right.equalTo(self!.backLineView)
            make.centerY.equalTo(self!.backLineView).offset(-0.6)
        })
    }
    
    
}
