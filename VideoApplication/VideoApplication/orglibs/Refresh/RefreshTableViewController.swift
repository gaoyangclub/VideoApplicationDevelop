//
//  RefreshTableViewController.swift
//  PullRefreshScrollerTest
//
//  Created by 高扬 on 15/10/27.
//  Copyright (c) 2015年 高扬. All rights reserved.
//

import UIKit

class RefreshTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    var refreshContaner:RefreshContainer!
    var tableView:UITableView!
    var isDispose:Bool = false
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        initTableArea()
    }
    
    private func initTableArea(){
        self.navigationController?.navigationBar.translucent = false//    Bar的高斯模糊效果，默认为YES
        self.automaticallyAdjustsScrollViewInsets = false//YES表示自动测量导航栏高度占用的Insets偏移
        
        if tableView == nil{
            tableView = UITableView()
            tableView?.separatorStyle = UITableViewCellSeparatorStyle.None //去掉Cell自带线条
            tableView.backgroundColor = UIColor.clearColor()
            self.view.addSubview(tableView)
            tableView.dataSource = self
            tableView.delegate = self
            
            refreshContaner = RefreshContainer()
            //        refreshContaner.addSubview(tableView)
            //        refreshContaner.backgroundColor = UIColor.brownColor()
            self.view.addSubview(refreshContaner)
            refreshContaner.scrollerView = tableView
            refreshContaner.snp_makeConstraints { [weak self](make) -> Void in //[weak self]
                self!.refreshContanerMake(make)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableArea()
    }
    
    func refreshContanerMake(make:ConstraintMaker)-> Void{
        make.left.right.top.bottom.equalTo(self.view)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 0//tableView.numberOfRowsInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        return UITableViewCell()//tableView.cellForRowAtIndexPath(indexPath)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        isDispose = true //该对象已经销毁
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
