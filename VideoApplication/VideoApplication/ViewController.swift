//
//  ViewController.swift
//  VideoApplication
//
//  Created by 高扬 on 16/1/5.
//  Copyright (c) 2016年 高扬. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class ViewController: UIViewController {

    private var videoPlayer:AVPlayer!
    private var playerItem:AVPlayerItem!
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.translucent = false//    Bar的高斯模糊效果，默认为YES
    }
    
//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }
    
    //隐藏navigation tabbar 电池栏
    func toolbarHidden(bool:Bool){
        self.navigationController?.navigationBar.hidden = bool;
        self.tabBarController?.tabBar.hidden = bool;
        UIApplication.sharedApplication().setStatusBarHidden(bool, withAnimation: UIStatusBarAnimation.Fade)
    }
        
    private var mSyncSeekTimer:NSTimer!
    func playClick(){
        videoPlayer.play()
//        if !VMediaPlayer.sharedInstance().isPlaying(){
//            VMediaPlayer.sharedInstance().start()
            videoView.pauseBtn.hidden = false
            videoView.playBtn.hidden = true
//
        if mSyncSeekTimer != nil{
            mSyncSeekTimer.invalidate()
            mSyncSeekTimer = nil
        }
            mSyncSeekTimer = NSTimer.scheduledTimerWithTimeInterval(1/3, target: self, selector: "syncUIStatus", userInfo: nil, repeats: true)
//        }
    }
    
    func pauseClick(){
        videoPlayer.pause()
//        if VMediaPlayer.sharedInstance().isPlaying(){
//            VMediaPlayer.sharedInstance().pause()
            videoView.pauseBtn.hidden = true
            videoView.playBtn.hidden = false
            mSyncSeekTimer?.invalidate()
        mSyncSeekTimer = nil
////            println("暂停播放")
//        }
    }
    
    private var progressDragging:Bool = false
    private var mCurPostion:Float = 0
    private var mDuration:Float = 0
    func syncUIStatus(){
        if (!self.progressDragging) {
            mCurPostion = Float(playerItem.currentTime().value)/Float(playerItem.currentTime().timescale);// 计算当前在
//            mCurPostion = Float(videoPlayer.currentTime().value)
            videoView.progressSld.value = mCurPostion / mDuration
            videoView.leftLabel.text = timeToHumanString(Int(mCurPostion) * 1000)
            videoView.rightLabel.text = timeToHumanString((Int(mDuration) - Int(mCurPostion)) * 1000)
        }
    }
    
    func showZoomIn(){
        isFullScreen = true
        showZoomBtn()
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.LandscapeLeft.rawValue, forKey: "orientation")
        let boundsHeight = UIScreen.mainScreen().bounds.height
        videoView.snp_updateConstraints { (make) -> Void in
            make.height.equalTo(boundsHeight)
        }
    }
    
    func showZoomOut(){
        isFullScreen = false
        showZoomBtn()
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        videoView.snp_updateConstraints { (make) -> Void in
            make.height.equalTo(200)
        }
    }
    
    lazy var videoView:VideoView = {
        var back:VideoView = VideoView()
        back.backgroundColor = UIColor.blackColor()
        self.view.addSubview(back)
        return back
    }()
    
        
    func slideTouchBegin(){
        pauseClick()//先暂停
    }
    
    func slideTouchEnd(){
        var changedTime:CMTime = CMTimeMakeWithSeconds(Float64(mDuration * videoView.progressSld.value),1)
        videoPlayer.seekToTime(changedTime)
        playClick()
    }
    
    private var isFullScreen:Bool = false
    
    private func showZoomBtn(){
        videoView.zoomInBtn.hidden = isFullScreen
        videoView.zoomOutBtn.hidden = !isFullScreen
        self.toolbarHidden(isFullScreen)
    }
    
    private func initController(){
        self.title = "视频播放器"
//        videoView.frame = CGRectMake(0, 0, self.view.frame.width, 200)
        videoView.snp_makeConstraints { (make) -> Void in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(200)
        }
        showZoomBtn()
        videoView.playBtn.hidden = false
        videoView.pauseBtn.hidden = true
        
        videoView.zoomInBtn.addTarget(self, action: "showZoomIn", forControlEvents: UIControlEvents.TouchUpInside)
        videoView.zoomOutBtn.addTarget(self, action: "showZoomOut", forControlEvents: UIControlEvents.TouchUpInside)
        videoView.playBtn.addTarget(self, action: "playClick", forControlEvents: UIControlEvents.TouchUpInside)
        videoView.pauseBtn.addTarget(self, action: "pauseClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        videoView.progressSld.addTarget(self, action: "slideTouchBegin", forControlEvents: UIControlEvents.TouchDown)
        videoView.progressSld.addTarget(self, action: "slideTouchEnd", forControlEvents: UIControlEvents.TouchUpInside)
        videoView.progressSld.addTarget(self, action: "slideTouchEnd", forControlEvents: UIControlEvents.TouchUpOutside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initController()
        
//        var videoUrl = "http://meta.video.qiyi.com/242/de25dc2b5d385a8e27304d1e6dcd1a35.m3u8"
//        var videoUrl = "http://zqgbzx.cn:6060/zwapi/videos/ZQ0005.mp4"
//        var videoUrl = "http://content.viki.com/test_ios/ios_240.m3u8"
        var videoUrl = "http://krtv.qiniudn.com/150522nextapp"
        
        self.playerItem = AVPlayerItem(URL: NSURL(string: videoUrl))
        self.videoPlayer = AVPlayer(playerItem: self.playerItem)
        //        videoPlayer.play()
        
        playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: nil)
        playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.New, context: nil)
        
//        self.videoView.frame = CGRectMake(0, 0, self.view.frame.width, 200)
        self.videoView.player = self.videoPlayer
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayDidEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: playerItem)
        
//        var asset = AVURLAsset(URL: NSURL(string: videoUrl), options: nil)
//        asset.loadValuesAsynchronouslyForKeys(["playable"]) { () -> Void in
//            dispatch_async(dispatch_get_main_queue(),{
//                
////                self.videoView.setFillMode(AVLayerVideoGravityResizeAspect)
//            })
//        }
        
//        [self.playerItem addObserver:self
//            forKeyPath:@"status"
//        options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
//        context:nil];
        
//        let vp:VMediaPlayer = VMediaPlayer.sharedInstance()
//        vp.setupPlayerWithCarrierView(videoView.operateView, withDelegate: self)
//        vp.setVideoFillMode( VMVideoFillModeFit)
////        vp.setDeinterlace(true)
////        vp.setVideoFillAspectRatio(0.5)
////        vp.useCache = true
//        vp.setDataSource(NSURL(string: videoUrl))
////        vp.decodingSchemeHint = VMDecodingSchemeHardware
//        vp.prepareAsync()
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "status"{
            if playerItem.status == AVPlayerItemStatus.ReadyToPlay{
                mDuration = Float(CMTimeGetSeconds(self.playerItem.duration))//Float(self.playerItem.duration.value)
                println("视频长度:\(self.playerItem.duration.value)")// 获取视频总长度
//                println("视频准备播放")
                syncUIStatus()
            }else if playerItem.status == AVPlayerItemStatus.Failed{
                println("视频AVPlayerStatusFailed")
            }
        }else if keyPath == "loadedTimeRanges"{
            println("计算缓冲中")
//            println("视频长度:\(self.playerItem.duration.value)")// 获取视频总长度
        }
    }
    
    //该方法已经移除
//    override func shouldAutorotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation) -> Bool
//    {
//        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
//            return true;
//        }
//        return false;
//    }
    
    private func timeToHumanString(ms:Int)->String
    {
        var h:Int = 0
        var m:Int = 0
        var s:Int = 0
        
        var seconds:Int = Int(ms) / 1000;
        h = seconds / 3600;
        m = (seconds - h * 3600) / 60;
        s = seconds - h * 3600 - m * 60;
        let result = String(format: "%02ld", h) + ":" + String(format: "%02ld", m) + ":" + String(format: "%02ld", s)
//        println("result:\(result)")
        return result
    }
    
    func moviePlayDidEnd(notification:NSNotification){
        self.videoPlayer.seekToTime(kCMTimeZero) {[weak self] _ -> Void in
            self!.videoView.progressSld.value = 0
            self!.pauseClick()
        }
    }
    
//    private var firstPlay = false
//    func mediaPlayer(player: VMediaPlayer!, didPrepared arg: AnyObject!) {
//        mDuration = Float(player.getDuration())
//        firstPlay = true
//        player.seekTo(0)//第一秒
//        player.start()
//        videoView.progressSld.value = 0
//        mSyncSeekTimer?.invalidate()
////        playClick()
////        println("开始播放")
//    }

//    func mediaPlayer(player: VMediaPlayer!, playbackComplete arg: AnyObject!) {
////        player.reset()
////        player.prepareAsync()
//        println("播放完毕")
//        mediaPlayer(player, didPrepared: NSObject())
//    }
//    
//    func mediaPlayer(player: VMediaPlayer!, error arg: AnyObject!) {
//        println("视频出错:\(arg)")
//    }
//    
//    func mediaPlayer(player: VMediaPlayer!, seekComplete arg: AnyObject!) {
//        println("seekComplete")
//        if firstPlay {
//            firstPlay = false
//            pauseClick()//停留在第一帧
//            syncUIStatus()
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

