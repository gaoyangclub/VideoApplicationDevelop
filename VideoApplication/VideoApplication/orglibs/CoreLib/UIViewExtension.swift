//
//  UIViewExtension.swift
//  CoreGraphicsTest
//
//  Created by 高扬 on 15/10/1.
//  Copyright (c) 2015年 高扬. All rights reserved.
//

import UIKit
import ObjectiveC

extension UIView {
    
//    private var xoTag: UInt = 0
////    public var data:Any?
//    var tags: UInt {
//        get {
//            return (objc_getAssociatedObject(self, &xoTag) as? UInt)!
//        }
//        set(newValue) {
//            objc_setAssociatedObject(self, &xoTag, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
//        }
//    }
    
    /** 删除所有的子视图 */
    func removeAllSubViews(){
        if subviews.count == 0{
            return
        }
        for sub in subviews{
            sub.removeFromSuperview()
        }
//        for i in subviews.count - 1...0 {
//            var sub:UIView = subviews[i] as! UIView
//            sub.removeFromSuperview()
//        }
    }
}
extension CALayer{
    /** 删除所有的子层级 */
    func removeAllSubLayers(){
        if sublayers == nil || sublayers!.count == 0{
            return
        }
        for sub in sublayers!{
            sub.removeFromSuperlayer()
        }
//        for i in sublayers.count - 1...0 {
//            var sub:CALayer = sublayers[i] as! CALayer
//            sub.removeFromSuperlayer()
//        }
    }
}
extension UIViewController{
    var drawerController:MMDrawerController{
        get{
            return RootDrawerController.getInstance()
        }
    }
    
//    var navigationController:UINavigationController?{
//        get{
//            return RootNavigationControl.getInstance()
//        }
//    }
    
    var rootNavigationController:RootNavigationControl{
        get{
            return RootNavigationControl.getInstance()
        }
    }
    
}
//extension UIColor{
//    func copyWithAlpha(alpha:CGFloat)->UIColor{
//        var color:CGColorRef = self.CGColor
//        var newColor = CGColorCreateCopyWithAlpha(color,alpha)
//        return UIColor(CGColor: newColor)!
//    }
//}
