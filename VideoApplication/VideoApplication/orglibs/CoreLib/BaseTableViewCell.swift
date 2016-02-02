//
//  BaseTableViewCell.swift
//  FinanceApplicationTest
//
//  Created by 高扬 on 15/10/29.
//  Copyright (c) 2015年 高扬. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
    
    required override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var indexPath:NSIndexPath = NSIndexPath(){
        didSet{
            setNeedsLayout()
        }
    }
    
    var isFirst:Bool = false
    var isLast:Bool = false
    
    var needRefresh:Bool = true //默认需要刷新
    
    var tableView:UITableView?{
        didSet{
            setNeedsLayout()
        }
    }
    
    var cellVo:CellVo?{
        didSet{
            setNeedsLayout()
        }
    }
    
    var data:Any?{
        //        set(newValue){
        //            _data = newValue
        //            setNeedsDisplay()
        //        }get{
        //            return _data
        //        }
        didSet{
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        if needRefresh {
            showSubviews()
        }
    }
    
    func showSubviews(){
        //具体实现视图都在这里
    }
    
    
}
