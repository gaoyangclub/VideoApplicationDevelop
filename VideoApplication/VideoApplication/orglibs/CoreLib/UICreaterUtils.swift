//
//  UICreaterUtils.swift
//  FinanceApplicationTest
//
//  Created by 高扬 on 15/11/29.
//  Copyright (c) 2015年 高扬. All rights reserved.
//

import UIKit

class UICreaterUtils: AnyObject {
   
    static let normalLineWidth:CGFloat = 0.5
    static let normalLineColor:UIColor = UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha: 1)
    
    static let colorBlack:UIColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
    
    static let colorRise:UIColor = UIColor(red: 232/255, green: 55/255, blue: 59/255, alpha: 1)
    static let colorDrop:UIColor = UIColor(red: 135/255, green: 194/255, blue: 41/255, alpha: 1)
    static let colorFlat:UIColor = UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 1)
    
    static func createLabel(size:CGFloat,_ color:UIColor,_ text:String = "",_ sizeToFit:Bool = false,_ parent:UIView? = nil)->UILabel{
        let uiLabel = UILabel()
        if parent != nil{
            parent?.addSubview(uiLabel)
        }
        uiLabel.font = UIFont.systemFontOfSize(size)//UIFont(name: "Arial Rounded MT Bold", size: size)
        uiLabel.textColor = color
        uiLabel.text = text
        if sizeToFit{
            uiLabel.sizeToFit()
        }
        return uiLabel
    }
}
