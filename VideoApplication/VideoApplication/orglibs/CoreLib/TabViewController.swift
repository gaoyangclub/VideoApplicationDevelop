//
//  TabViewController.swift
//  FinanceApplicationTest
//
//  Created by 高扬 on 15/10/17.
//  Copyright (c) 2015年 高扬. All rights reserved.
//

import UIKit

struct TabData {
    var data:Any?
    var controller:UIViewController
}

class TabViewController: UITabBarController {
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews();
//        println("viewDidLayoutSubviews")
        customTabBar();
    }
    
    var itemClass:BaseItemRenderer.Type = BaseItemRenderer.self{
        didSet{
            self.view.setNeedsLayout()
        }
    }
    
    var dataProvider:[TabData]?{
        didSet{
            self.view.setNeedsLayout()
        }
    }
    
    var tabBarHeight:CGFloat = 50{
        didSet{
            self.view.setNeedsLayout()
        }
    }
    
    private var containerView:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //隐藏自带tabBarItem
        self.tabBar.hidden=true
//        self.view.backgroundColor = UIColor.orangeColor()
        
        initContainer()
        initLine()
//        println("viewDidLoad")
    }
    
    private var lineView:UIView!
    private func initLine(){
        lineView = UIView()
        lineView.backgroundColor = UIColor.grayColor()
        
        self.view.addSubview(lineView)
        
        lineView.snp_makeConstraints(){ [weak self](make) -> Void in
            make.height.equalTo(0.5)
            make.width.equalTo(self!.view)
            make.bottom.equalTo(self!.containerView.snp_top)
        }
    }
    
    private func initContainer(){
        containerView = UIView()
        self.view.addSubview(containerView)
    }
    
    func tabSelectHandler(subView:BaseItemRenderer){
        self.selectedIndex = subView.itemIndex //选中
        stateTabChange(subView.itemIndex)
    }
    
    func getCurrentController()->UIViewController?{
        return dataProvider?[self.selectedIndex].controller
    }
    
    //自定义tabBar视图
    private func customTabBar(){
//        var height=UIScreen.mainScreen().bounds.size.height
//        var width=UIScreen.mainScreen().bounds.size.width
        //整体宽高
        if dataProvider == nil{
            return
        }
        containerView.snp_makeConstraints(){ [weak self](make) -> Void in
            make.centerX.equalTo(self!.view)
            make.height.equalTo(self!.tabBarHeight)
            make.width.equalTo(self!.view)
            make.bottom.equalTo(self!.view)
        }
//        
        let tw:UIView = self.view.subviews[0] //UITransitionView
//        tw.backgroundColor = UIColor.grayColor()
        tw.frame = CGRectMake(0,0,view.frame.width,view.frame.height - self.tabBarHeight)
        
        self.tabBar.frame.size = CGSize(width: view.frame.width,height: self.tabBarHeight)
        
        
//        selectedIndex = 0//默认选中第0个
        containerView.removeAllSubViews()
        let count = dataProvider?.count
        let subW = Float(self.view.frame.width / CGFloat(count!))
        var preView:UIView? = nil
        for i in 0..<count!{
//            var x = CGFloat(i) * subW
            
//            let itemClass:BaseItemRenderer.Type = BaseItemRenderer.self
            let subView:BaseItemRenderer = itemClass.init()
            
//            subView.frame = CGRectMake(x, 0, subW, tabBarHeight)
            containerView.addSubview(subView)
            subView.snp_makeConstraints(closure: { [weak self](make) -> Void in
                make.top.equalTo(self!.containerView)
                make.bottom.equalTo(self!.containerView)
                if preView == nil{
                    make.left.equalTo(self!.containerView)
                }else{
                    make.left.equalTo(preView!.snp_right)
                }
                make.width.equalTo(subW)
            })
            subView.itemIndex = i
            subView.selected = i == selectedIndex //直接选中
            subView.data = dataProvider![i].data;
            subView.addTarget(self, action: "tabSelectHandler:", forControlEvents: UIControlEvents.TouchUpInside)
            preView = subView
        }
        if(selectedIndex > count){//不存在的位置
            stateTabChange(0)//默认选中第0个
        }
        
        measureControllers()
    }
    
    private func stateTabChange(index:Int){
        for obj in self.containerView.subviews{
            let subView = obj as! BaseItemRenderer
            subView.selected = index == subView.itemIndex //直接选中
        }
    }
    
    private func measureControllers(){
        
        var ctrls:[UIViewController] = []
        for tabData in dataProvider!{
            ctrls.append(tabData.controller)
        }
        self.setViewControllers(ctrls,animated:true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
        
}