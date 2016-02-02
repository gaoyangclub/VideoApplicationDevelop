//
//  RoundTagView.swift
//  BestPalmPilot
//
//  Created by admin on 16/1/19.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit

class RoundTagView:UIView{
    
    var tagSize:CGFloat = 10{
        didSet{
            setNeedsLayout()
        }
    }
    var tagColor:UIColor = UIColor.grayColor(){
        didSet{
            setNeedsLayout()
        }
    }
    
    var tagText:String = ""{
        didSet{
            setNeedsLayout()
        }
    }
    
    //    private lazy var tagLabel:UILabel = {
    //       let labal = UICreaterUtils.createLabel(10, UIColor.grayColor(), "")
    //        return labal
    //    }()
    private var tagLabel:UILabel!
    //    private var subView:UIView!
    
    override func layoutSubviews() {
        initView()
    }
    
    private func initView(){
        if tagLabel == nil{
            tagLabel = UICreaterUtils.createLabel(tagSize, tagColor, "",true,self)
            tagLabel.textAlignment = NSTextAlignment.Center
            //            subView = UIView()
            //            addSubview(subView)
            
            tagLabel.snp_makeConstraints { [weak self](make) -> Void in
                make.center.equalTo(self!)
            }
            
            self.layer.borderColor = tagColor.CGColor
            self.layer.borderWidth = 0.6
            self.layer.cornerRadius = 3
            self.snp_makeConstraints { [weak self](make) -> Void in
                make.width.greaterThanOrEqualTo(20)
                make.width.equalTo(self!.tagLabel).offset(6)
                make.height.equalTo(self!.tagLabel).offset(2)
            }
        }
        tagLabel.text = tagText
        tagLabel.font = UIFont.systemFontOfSize(tagSize)
        tagLabel.textColor = tagColor
        tagLabel.sizeToFit()
    }
}
