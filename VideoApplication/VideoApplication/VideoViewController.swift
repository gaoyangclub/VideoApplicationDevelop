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

class VideoViewController: UIViewController,NSURLConnectionDataDelegate {//AVAssetResourceLoaderDelegate

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
    private var isFirstPlay:Bool = true
    private var isPlaying:Bool = false
    private var mSyncSeekTimer:NSTimer!
    func playClick(){
        
        if isFirstPlay {
            startOperateTimer()//开始计时
            isFirstPlay = false
        }else{
            resetOperateTimer()//计时重置
        }
        
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
        
        isPlaying = true
    }
    
    func pauseClick(){
        doVideoPause(true)
    }
    
    private func doVideoPause(isClick:Bool = false){
        resetOperateTimer()//计时重置
        videoPlayer.pause()
        //        if VMediaPlayer.sharedInstance().isPlaying(){
        //            VMediaPlayer.sharedInstance().pause()
        mSyncSeekTimer?.invalidate()
        mSyncSeekTimer = nil
        ////            println("暂停播放")
        //        }
        if isClick{
            videoView.pauseBtn.hidden = true //变化按钮状态
            videoView.playBtn.hidden = false
            isPlaying = false //真的暂停
        }
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
            if !mDuration.isNaN {
                videoView.rightLabel.text = timeToHumanString(Int(mDuration) * 1000) // - Int(mCurPostion)
            }
        }
    }
    
    func showZoomIn(){
        resetOperateTimer()//计时重置
        isFullScreen = true
        showZoomBtn()
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.LandscapeLeft.rawValue, forKey: "orientation")
        let boundsHeight = UIScreen.mainScreen().bounds.height
        videoView.snp_removeConstraints()
        videoView.snp_makeConstraints { (make) -> Void in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(boundsHeight)
        }
    }
    
    func showZoomOut(){
        resetOperateTimer()//计时重置
        isFullScreen = false
        showZoomBtn()
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        videoView.snp_removeConstraints()
        videoView.snp_makeConstraints { (make) -> Void in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(280)
        }
    }
    
    lazy var videoView:VideoView = {
        var back:VideoView = VideoView()
        back.backgroundColor = UIColor.blackColor()
        self.view.addSubview(back)
        return back
    }()
    
        
    func slideTouchBegin(){
//        resetOperateTimer()//计时重置
        doVideoPause()//先暂停
    }
    
    func slideTouchEnd(){
        resetOperateTimer()//计时重置
        let changedTime:CMTime = CMTimeMakeWithSeconds(Float64(mDuration * videoView.progressSld.value),1)
        seekToTime(changedTime)
    }
    
    private func seekToTime(changedTime:CMTime){
        resetBufferTime()
        videoPlayer.seekToTime(changedTime)
        if isPlaying {//一直在播放 继续播放
            playClick()
        }
    }
    
    private var isFullScreen:Bool = false
    
    private func showZoomBtn(){
        videoView.zoomInBtn.hidden = isFullScreen
        videoView.zoomOutBtn.hidden = !isFullScreen
        self.toolbarHidden(isFullScreen)
    }
    
    private lazy var volumeView:MPVolumeView = {
        let view = MPVolumeView()
        self.view.addSubview(view)
        for sub in view.subviews{
            if sub.isKindOfClass(NSClassFromString("MPVolumeSlider")!){
                self.volumeViewSlider = sub as! UISlider
            }
        }
        return view
    }()
    
    private var volumeViewSlider:UISlider!
    
    private func initController(){
        self.title = "视频播放器"
        
        volumeView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        volumeView.hidden = false
        
        do{
            try AVAudioSession.sharedInstance().setActive(true)
        }catch{
            
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "volumeChanged:", name: "AVSystemController_SystemVolumeDidChangeNotification", object: nil)
        // add event handler, for this example, it is `volumeChange:` method
        
//        videoView.frame = CGRectMake(0, 0, self.view.frame.width, 200)
        videoView.snp_makeConstraints { (make) -> Void in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(280)
        }
        
        videoView.layoutProgressView()
        
        videoView.operateView.hidden = false
        videoView.hideLoading()
        
        initGestureRecognizer()
        
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
    
    func volumeChanged(notification:NSNotification){
        //声音变化...
        print(notification.object)//获取数据
    }
    
    private var panGestrue:UIPanGestureRecognizer!
//    private var tapGestrue:UITapGestureRecognizer!
    private func initGestureRecognizer(){
        if panGestrue == nil{
            panGestrue = UIPanGestureRecognizer(target: self, action: "panHandler:")
            videoView.videoCenterArea.addGestureRecognizer(panGestrue)
            panGestrue.minimumNumberOfTouches = 1
            panGestrue.maximumNumberOfTouches = 1
            //            panGestrue.delegate = self
        }
        
        let singleClickGestrue = UITapGestureRecognizer(target:self, action: "singleClickHandler:")
        videoView.videoCenterArea.addGestureRecognizer(singleClickGestrue)
        
        let doubleClickGestrue = UITapGestureRecognizer(target:self, action: "doubleClickGestrue:")
        doubleClickGestrue.numberOfTapsRequired = 2 //双击
        videoView.videoCenterArea.addGestureRecognizer(doubleClickGestrue)
        
        singleClickGestrue.requireGestureRecognizerToFail(doubleClickGestrue) //单机要让给双击
        //[singleTapOne requireGestureRecognizerToFail:doubleTapOne]; // Single tap requires double tap to fail
        
//        videoView.addTarget(self, action: "tapHandler", forControlEvents: UIControlEvents.TouchDown)
//        if tapGestrue == nil{
//        }
    }
    
//    func sideTapHandler(sender:UITapGestureRecognizer){
//        println("sideTapHandler交互")
//    }
    
    func doubleClickGestrue(sender:UITapGestureRecognizer){
        if sender.state == .Ended{
            if isPlaying {
                pauseClick()
            }else{
                playClick()
            }
        }
    }
    
    //
    func singleClickHandler(sender:UITapGestureRecognizer){
        if isFirstPlay {
            return
        }
        if sender.state == .Ended{
            if operateHideTimer != nil { //正在显示
                videoOperateHide() //隐藏
            }else{ //已经隐藏
                videoOperateShow()
            }
        }
//            else if sender.state == .Began{
//            println("UITapGestureRecognizer按下")
//            invalidateOperateTimer() //计时器关闭
//        }
    }
    
    private var isVertical:Bool? = nil
    private var currentVolume:Float!
    func panHandler(sender:UIGestureRecognizer){
        
        if sender.state == .Ended{
            if !videoView.centerTipsArea.hidden { //正在显示
                let changedTime:CMTime = CMTimeMakeWithSeconds(Float64(mDuration * videoView.centerProgressView.progress),1)
                seekToTime(changedTime)
                videoView.centerTipsArea.hidden = true
            }
            isVertical = nil
//            hideGestrueLine()
        }else if sender.state == .Began{
            
            mCurPostion = Float(playerItem.currentTime().value)/Float(playerItem.currentTime().timescale);// 计算当前在
//            videoView.centerProgressView.progress = mCurPostion / mDuration
//            videoView.centerTimeLabel.text = "+00:00"
            currentVolume = videoPlayer.volume
            prePoint = sender.locationOfTouch(0, inView: videoView)
//            println("按下位置x:\(prePoint.x)")
        }
        else if sender.numberOfTouches() > 0{
            let nowPoint:CGPoint = sender.locationOfTouch(0, inView: videoView)
            let dirtX = nowPoint.x - prePoint!.x
            let dirtY = nowPoint.y - prePoint!.y
            if isVertical == nil{
                isVertical = abs(dirtX) < abs(dirtY)
            }
            if !isVertical!{ //横向移动
                var s = Float(dirtX)/5 //添加的秒数
                //            println("增加的秒数\(s)")
                if s + mCurPostion < 0 {
                    s = -mCurPostion //最小
                }else if s + mCurPostion > mDuration {
                    s = mDuration - mCurPostion//最大
                }
                doVideoPause()//先暂停
                videoView.centerTipsArea.hidden = false
                videoView.centerTimeLabel.text = timeToHumanString(Int(s) * 1000,showSign: true)
                if !mDuration.isNaN {
                    videoView.centerProgressLabel.text = timeToHumanString(Int(mCurPostion) * 1000) + "/" + timeToHumanString(Int(mDuration) * 1000)
                    videoView.centerProgressView.progress = (mCurPostion + s) / mDuration
                }
            }else{ //纵向移动
                var s = -Float(dirtY)/200.0 //添加的音量
//                println("增加的音量\(s)")
                //            println("增加的秒数\(s)")
                if s + currentVolume < 0 {
                    s = -currentVolume //最小
                }else if s + currentVolume > 1 {
                    s = 1 - currentVolume//最大
                }
                print("音量值\(currentVolume + s)")
//                videoPlayer.volume = currentVolume + s
                volumeViewSlider.setValue(currentVolume + s, animated: false)
                volumeViewSlider.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
                
//                MPMusicPlayerController.applicationMusicPlayer()
//                MPMusicPlayerController.applicationMusicPlayer().volume = currentVolume + s
                // send UI control event to make the change effect right now.
            }
        }
    }
    
//    private var addedPostion:Float = 0
    
    private var prePoint:CGPoint!
//    private func measureGestruePoint(sender:UIGestureRecognizer){
//        let nowPoint:CGPoint = sender.locationOfTouch(0, inView: videoView)
//        if prePoint == nil{
//            prePoint = nowPoint
//        }
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initController()
        
//        var videoUrl = "http://218.205.83.162/160/40/66/letv-uts/14/ver_00_22-1002484284-avc-935033-aac-64000-7438834-936873903-cc1080e4e939b8e86fa33e438105c908-1444561006245.m3u8?crypt=87aa7f2e222&b=1007&nlh=3072&nlt=45&bf=18&p2p=1&video_type=mp4&termid=2&tss=ios&geo=CN-11-0-4&platid=3&splatid=304&its=0&qos=4&fcheck=0&mltag=1&path=221.181.202.101&proxy=3719678044,1862352336,3719678033&uid=1879763363.rp&keyitem=GOw_33YJAAbXYE-cnQwpfLlv_b2zAkYctFVqe5bsXQpaGNn3T1-vhw..&ntm=1453644000&nkey=1f9e53d7e14f763d7ea66c91ca6580c5&nkey2=5000fcd629984a5742a2cda91ffe6b68&mmsid=35839261&tm=1453632956&key=d4902d2a57050d18eefeec2107d3efe9&playid=0&vtype=22&cvid=1332521249192&payff=0&p1=0&p2=06&ostype=macos&hwtype=un&uuid=1632956843139455_2&vid=23742262&errc=0&gn=311&buss=4701&cips=112.10.233.163"
//        var videoUrl = "http://zqgbzx.cn:6060/zwapi/videos/ZQ0005.mp4"
        var videoUrl = "http://krtv.qiniudn.com/150522nextapp"
//        var videoUrl = "http://content.viki.com/test_ios/ios_240.m3u8"
        
        
        let url = NSURL(string: videoUrl)
//        let value = url?.resourceValuesForKeys([NSURLTotalFileAllocatedSizeKey], error: NSErrorPointer())
//        println(value)  //AVVideoWidthKey
        
        let con = NSURLConnection(request: NSURLRequest(URL: url!), delegate: self)
        
//        let assets = AVURLAsset(URL: url, options: nil)
//        assets.resourceLoader.setDelegate(self,queue: dispatch_get_main_queue())
        
        self.playerItem = AVPlayerItem(URL: NSURL(string: videoUrl)!)//AVPlayerItem(asset: assets)
        self.videoPlayer = AVPlayer(playerItem: self.playerItem)
        //replaceCurrentItemWithPlayerItem //替换资源包
//        println(assets.creationDate)
        //        videoPlayer.play()
        
//        AVVideoCodecKey
        
        playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: nil)
        playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.New, context: nil)
        
//        self.videoView.frame = CGRectMake(0, 0, self.view.frame.width, 200)
        self.videoView.player = self.videoPlayer
//        NSURLFileSizeKey
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayDidEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: playerItem)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlaybackStalled:", name: AVPlayerItemPlaybackStalledNotification, object: playerItem)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "movieTimeJumped:", name: AVPlayerItemTimeJumpedNotification, object: playerItem)
        
//        var asset = AVURLAsset(URL: NSURL(string: videoUrl), options: nil)
//        asset.loadValuesAsynchronouslyForKeys(["playable"]) { () -> Void in
////            AVKeyValueStatus status=[asset statusOfValueForKey:@"tracks" error:nil];
//            println(assets.creationDate)
//            
////            dispatch_async(dispatch_get_main_queue(),{
////                
//////                self.videoView.setFillMode(AVLayerVideoGravityResizeAspect)
////            })
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
    
    private var totalFileSize:Int!
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        print("获取文件\(data)")
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        connection.cancel()
        totalFileSize = Int(response.expectedContentLength)
//        println("totalFileSize:\(totalFileSize)")
        print("文件大小:\(Float(totalFileSize) / 1000.00)k")
//        connection.start()
    }
    
    private var operateHideTimer:NSTimer!
    
    private func invalidateOperateTimer(){
        if operateHideTimer != nil{
            operateHideTimer.invalidate()
            operateHideTimer = nil
        }
    }
    
    //计时器时间重置
    private func resetOperateTimer(){
        if operateHideTimer != nil{
            startOperateTimer()
        }
    }
    
    private func startOperateTimer(){
        invalidateOperateTimer()
        operateHideTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "videoOperateHide",userInfo: nil, repeats:false)
    }
    
    func videoOperateHide(){
        invalidateOperateTimer()
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.videoView.operateView.alpha = 0 //隐藏
        })
        self.videoView.showCenterAreaToSide()
    }
    
    func videoOperateShow(){
        startOperateTimer()
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.videoView.operateView.alpha = 1 //隐藏
        })
        self.videoView.showCenterAreaToBase()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "status"{
            if playerItem.status == AVPlayerItemStatus.ReadyToPlay{
                mDuration = Float(CMTimeGetSeconds(self.playerItem.duration))//Float(self.playerItem.duration.value)
                syncUIStatus()
//                startOperateTimer()
            }else if playerItem.status == AVPlayerItemStatus.Failed{
                print("视频AVPlayerStatusFailed")
            }else{
                print("视频状态:\(playerItem.status)")
            }
        }else if keyPath == "loadedTimeRanges"{
//            if nowBufferTime != nil{
//                prevBufferTime = nowBufferTime
//            }
            let nowBufferTime = self.availableDuration()
////            println("缓冲进度：\(bufferTime)秒 ,总共：\(durationTime)秒 ,百分比：\(progress * 100)%")
//            if nowTime != nil {
//                prevTime = nowTime
//            }
//            nowTime = mach_absolute_time()
            prevBufferTimeArr.append(nowBufferTime)
            prevTimeArr.append(mach_absolute_time())
            isBuffering = true
            
            let durationTime = Float(CMTimeGetSeconds(playerItem.duration))
            let progress = nowBufferTime/durationTime
            
            if bufferTimer == nil {
                bufferTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "bufferTimerMove",userInfo: nil, repeats:true)
            }
            self.videoView.bufferView.setProgress(progress, animated: false)
            
            if !self.videoView.loadingArea.hidden {//正在显示
                self.videoView.hideLoading()
            }
//            for obj in playerItem.tracks{
//                var track = obj as! AVPlayerItemTrack
//                println(track.assetTrack.totalSampleDataLength)
//            }
            
//            println("preferredPeakBitRate:\(playerItem.preferredPeakBitRate)")
//            var events = playerItem.accessLog().events
//            for event  in events{
//                let e = event as! AVPlayerItemAccessLogEvent
//              println("observedMinBitrate:\(e.observedMinBitrate),observedMaxBitrate:\(e.observedMaxBitrate)")
//            }
//            println(events)
//            println("计算缓冲中")
//            println("视频长度:\(self.playerItem.duration.value)")// 获取视频总长度
        }
    }
    
    private let sampleCount:Int = 10
    
    func bufferTimerMove(){
        var downloadRate:Float = 0
        if prevTimeArr.count > 0 && prevBufferTimeArr.count > 0 && isBuffering{
            let offset = prevTimeArr.count >= sampleCount ? sampleCount : prevTimeArr.count
            
            let nowTime = prevTimeArr[prevTimeArr.count - 1]
            let prevTime = prevTimeArr[prevTimeArr.count - offset]
            
            let nowBufferTime = prevBufferTimeArr[prevTimeArr.count - 1]
            let prevBufferTime = prevBufferTimeArr[prevTimeArr.count - offset]
            
            let durationTime = Float(CMTimeGetSeconds(playerItem.duration))
            let needDelay = Float(nowTime - prevTime)/1000000000
            downloadRate = (nowBufferTime - prevBufferTime) / durationTime * Float(totalFileSize) / needDelay //文件大小
            
            if downloadRate.isNaN{
                downloadRate = 0.0
            }
            isBuffering = false
        }else{
            resetBufferTime()
        }
        videoView.downloadLabel.text = "当前速度:" + getDownloadRateString(downloadRate)
        videoView.downloadLabel.sizeToFit()
    }
    
    private func getDownloadRateString(downloadRate:Float)->String{
        if downloadRate > 1000000 {
            return "\(downloadRate / 1000000)M/s"
        }else if downloadRate > 1000 {
            return "\(downloadRate / 1000)Kb/s"
        }
        return "\(downloadRate / 1000)b/s"
    }
    
    private func resetBufferTime(){
//        nowTime = nil
//        prevTime = nil
//        nowBufferTime = nil
//        prevBufferTime = nil
        prevTimeArr.removeAll()
        prevBufferTimeArr.removeAll()
    }
    
    private var bufferTimer:NSTimer!
    
    private var prevTimeArr:[UInt64] = []
    private var prevBufferTimeArr:[Float] = []
    private var isBuffering:Bool = false
    
//    private var prevTime:UInt64?
//    private var nowTime:UInt64!
//    private var prevBufferTime:Float?
//    private var nowBufferTime:Float!
    
    //加载进度
    private func availableDuration()->Float{
//        let loadedTimeRanges = playerItem.loadedTimeRanges
//        if loadedTimeRanges.count > 0{
//            println(loadedTimeRanges[0])
//            let timeRange:NSObject = (loadedTimeRanges[0] as! NSObject).valueForKey("CMTimeRangeValue") as! NSObject
//            println(timeRange.valueForKey("start"))
            
//            if loadedTimeRanges[0] is CMTimeRange{
                let timeRange:CMTimeRange = videoView.getCMTimeRange()//CMTimeRangeValue(loadedTimeRanges.first)
                let startSeconds = Float(CMTimeGetSeconds(timeRange.start));
                let durationSeconds = Float(CMTimeGetSeconds(timeRange.duration));
                return (startSeconds + durationSeconds)
//            }
//        }
//        return 0
    }
    
    private func timeToHumanString(var ms:Int,showSign:Bool = false)->String
    {
        var sign = "+"
        if ms < 0{
            sign = "-"
            ms = -ms
        }
        
        var h:Int = 0
        var m:Int = 0
        var s:Int = 0
        
        let seconds:Int = Int(ms) / 1000;
        h = seconds / 3600;
        m = (seconds - h * 3600) / 60;
        s = seconds - h * 3600 - m * 60;
        let result = (showSign ? sign : "") + (h > 0 ? String(format: "%02ld", h) + ":" : "") + String(format: "%02ld", m) + ":" + String(format: "%02ld", s)
//        println("result:\(result)")
        return result
    }
    
    func moviePlayDidEnd(notification:NSNotification){
        videoReset()
    }
    
    private func videoReset(){
        self.videoPlayer.seekToTime(kCMTimeZero) {[weak self] _ -> Void in
            self!.isFirstPlay = true
            self!.videoView.progressSld.value = 0
            self!.pauseClick()
            self!.videoOperateShow()
            self!.invalidateOperateTimer() //计时器关闭
        }
    }
    
    //非操作性视频播放中断(网速卡等)
    func moviePlaybackStalled(notification:NSNotification){
//        print("moviePlaybackStalled")
        videoPlayer.play()
        videoView.showLoading()
    }
    
    func movieTimeJumped(notification:NSNotification){
//        println("movieTimeJumped")
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
//            doVideoPause()//停留在第一帧
//            syncUIStatus()
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        //将observer全部移除
        //...
    }


}

