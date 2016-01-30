//
//  RefreshHeaderView.swift
//  PullRefreshScrollerTest
//
//  Created by 高扬 on 15/9/4.
//  Copyright (c) 2015年 高扬. All rights reserved.
//

import UIKit

class RefreshHeaderView: RefreshBaseView {
    
    class func header()->RefreshHeaderView{
        let header:RefreshHeaderView  = RefreshHeaderView()
        return header
    }
    
    override func willMoveToSuperview(newSuperview: UIView!) {
        super.willMoveToSuperview(newSuperview)
        if(newSuperview != nil){
            self.frame = CGRectMake(0.0, 0.0, newSuperview!.frame.width, CGFloat(RefreshHeaderHeight))
            //            scrollView.contentInset.bottom = CGFloat(RefreshFooterHeight);
            //            self.scrollView.contentInset.top = self.frame.size.height
            //            self.scrollView.contentOffset.y = 0
        }
    }
    
    override var State:RefreshState{
        willSet {
            if  State == newValue{
                return;
            }
            oldState = State
            showArrowState(newValue)
        }
        didSet{
            switch State{
            case .Normal:
                self.statusLabel.text = RefreshHeaderPullToRefresh as String
                //                println("headerHeight:\(self.frame.size.height)")
                if RefreshState.Refreshing == oldState {
                    scrollView?.userInteractionEnabled = false
                    self.arrowImage!.transform = CGAffineTransformIdentity
                    //                self.lastUpdateTime = NSDate()
                    
//                    var mainTable:UIView? = self.scrollView?.getWrapperView()//.subviews[0] as! UIView
                    //                    println(mainTable?.frame.origin.y)
                    UIView.animateWithDuration(RefreshSlowAnimationDuration, animations: {
                        //self.frame.size.height
                        //                        self.scrollView.contentOffset.y = -self.scrollView.contentInset.top
                        //                        println("top:\(self.scrollView.contentInset.top)")
                        
//                        self.scrollView?.frame.origin.y = 0
                        self.scrollView?.contentInset.top = 0
                        },completion:{ ani in
                            //                        println("ani:\(ani)");
                            self.scrollView?.userInteractionEnabled = true
//                            println("scrollView交互打开")
                            //                            self.scrollView.contentInset.top = 0
                            //                            self.scrollView.bounces = true
                    })
                }else {
                    UIView.animateWithDuration(RefreshSlowAnimationDuration, animations: {
                        self.arrowImage!.transform = CGAffineTransformIdentity
                        },completion:{ ani in
                            //                        println("ani:\(ani)");
//                                                        self.scrollView?.userInteractionEnabled = true
//                            println("scrollView交互打开")
                    })
                }
                break
            case .Pulling:
                self.statusLabel.text = RefreshHeaderReleaseToRefresh as String
                UIView.animateWithDuration(RefreshSlowAnimationDuration, animations: {
                    self.arrowImage!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI ))
                })
                break
            case .Refreshing:
                //                for any in self.scrollView!.subviews{
                //                    print(any)
                //                }
                //                var count = self.scrollView?.subviews.count
                //                scrollView.bounces = false
                //                scrollView.contentInset.top = 0
//                var mainTable:UIScrollView? = self.scrollView?.getWrapperView()//.subviews[0] as! UIView
//                var offset = -self.scrollView?.contentOffset.y
                //                self.bounds.origin.y = -offset;//-self.frame.size.height
                //                mainTable?.contentInset.top = self.frame.size.height
//                var top = scrollView?.contentInset.top
                
                
//                self.scrollView?.frame.origin.y = self.frame.size.height//offset//self.frame.size.height
//                scrollView?.contentOffset.y -= (self.frame.size.height)// + CGFloat(top!))
//                self.scrollView?.contentInset.top = self.frame.size.height
                
                self.statusLabel.text = RefreshHeaderRefreshing as String;
                scrollView.userInteractionEnabled = false
//                println("scrollView交互关闭")
                self.hidden = false
                UIView.animateWithDuration(RefreshSlowAnimationDuration, animations: {
                    //                    self.bounds.origin.y = -self.frame.size.height
                    //                    mainTable?.frame.origin.y = self.frame.size.height
                    //                    println(mainTable?.frame.origin.y)
                    //                    self.scrollView.contentInset.top = 0
//                    var top:CGFloat = 0.0
                    //                    if self.oldState == .Pulling {
                    _ = self.frame.size.height// + self.scrollView.contentInset.top
                    //                    }
                    //                    else{
                    //                        top = self.frame.size.height
                    //                    }
                    //                    self.scrollView.contentInset.top = top
                    //                    self.scrollView.contentOffset.y = -top
                    if self.scrollView != nil && self.scrollView?.contentInset != nil{
                        self.scrollView?.contentInset.top = self.frame.size.height
                    }
                    },completion:{ _ in
                        //                        println("ani:\(ani)");
//                                                self.scrollView?.userInteractionEnabled = true
                        //                        self.scrollView.contentInset.top = 0
                        
//                        if self.scrollView != nil && self.scrollView?.contentInset != nil{
//                            self.scrollView?.contentInset.top = self.frame.size.height
//                        }
                })
                break
            default:
                break
                
            }
        }
    }
    
    override func showSubView(){
        //状态标签
        statusLabel = UILabel()
        statusLabel.font = UIFont.boldSystemFontOfSize(13)
        statusLabel.textColor = RefreshLabelTextColor
        statusLabel.backgroundColor =  UIColor.clearColor()
        statusLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(statusLabel)
        
        //状态标签
        activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        self.addSubview(activityView)
        
        //箭头图片
        arrowImage = UIImageView(image: UIImage(named: "arrow.png"))
        self.addSubview(arrowImage!)
        arrowImage!.sizeToFit()
        
        statusLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(RefreshHeaderHeight / 4)
        }
        
        arrowImage!.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-RefreshHeaderHeight / 4)
        }
        
        activityView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.arrowImage!)
            make.centerY.equalTo(self.arrowImage!)
        }
        
        //自己的属性
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth //根据父容器宽度自动变化
        self.backgroundColor = UIColor.clearColor()
        
        self.State = RefreshState.Normal;
    }
    
    //内容大小发生变化  重写调整frame
    func adjustFrameWithContentSize2(){
        //        var rect:CGRect = self.frame
        //        rect.origin.y = -self.frame.size.height
        //        self.frame = rect
//        var rect:CGRect = self.frame
//        var originY:CGFloat = self.scrollView.contentInset.top + self.scrollView.contentOffset.y// + self.frame.size.height
//        //        println("scrollView.contentOffset.y:\(scrollView.contentOffset.y)" + "  originY:\(originY)")
//        //        if self.oldState == .Pulling {
//        
//        //        }else{
//        //            rect.origin.y = self.scrollView.contentInset.top//self.frame.size.height
//        //        }
//        if self.State == .Refreshing {
//            self.bounds.origin.y = -self.frame.size.height
//        }else{
//            self.bounds.origin.y = 0
//        }
//        rect.origin.y = originY
//        //        println("originY:\(originY)")
//        self.frame = rect
    }
    
    //滚动位置变化 调整状态
    override func adjustStateWithContentOffset()
    {
        //        if self.oldState == RefreshState.Refreshing{
        
        //        }
        let currentOffsetY:CGFloat = self.scrollView.contentOffset.y + self.scrollView.contentInset.top
        let happenOffsetY:CGFloat = 0;//-self.frame.size.height
//        println("currentOffsetY:\(currentOffsetY)")
        if (currentOffsetY >= happenOffsetY) {
            self.hidden = true
//            println("hidden:\(true)")
            return
        }else{
            self.hidden = false
//            println("hidden:\(false)")
        }
        if self.scrollView.dragging{
            if  self.State == RefreshState.Normal && currentOffsetY < -self.frame.size.height{
                self.State = RefreshState.Pulling
            }else if self.State == RefreshState.Pulling && currentOffsetY >= -self.frame.size.height{
                self.State = RefreshState.Normal
            }
        } else if self.State == RefreshState.Pulling {
            self.State = RefreshState.Refreshing
        }
        adjustFrameWithContentSize2()
    }
    
}
