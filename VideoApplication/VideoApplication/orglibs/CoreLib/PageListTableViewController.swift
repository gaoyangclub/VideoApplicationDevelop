//
//  PageListTableViewController.swift
//  BestPalmPilot
//
//  Created by admin on 16/1/18.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit

class PageListTableViewController: BaseTableViewController {

    var pageSO:PageListSO?// = self.createPageSO()
    var hasSetUp:Bool = false
    var showFooter:Bool = true
    var hasFirstRefreshed:Bool = false //第一次刷新界面
    
    override func loadView() {
        super.loadView()
        pageSO = createPageSO()
    }
    
    func createPageSO()->PageListSO{
        return PageListSO()
    }
    
    /** 头部下拉全部刷新 */
    func headerRequest(pageSO:PageListSO?,callback:((hasData:Bool,sorttime:String) -> Void)!){
        
    }
    
    /** 底部上拉刷新 */
    func footerRequest(pageSO:PageListSO?,callback:((hasData:Bool,sorttime:String) -> Void)!){
        
    }
    
    func setupRefresh(){
        self.hasSetUp = true
        
        self.refreshContaner.addHeaderWithCallback(RefreshHeaderView.header(),callback: { [weak self] ()-> Void in
//            self?.pageSO?.pagenumber = PageListSO.firstPageNumber//重新清零
           self?.pageSO?.sorttime = ""
            
            self?.headerRequest((self!.pageSO)){ [weak self] hasData,lastUpdateTime in//获取数据完毕 刷新界面
                self?.pageSO?.sorttime = lastUpdateTime
                self?.hasFirstRefreshed = true
                if hasData {
                    self?.tableView?.reloadData()
                    self?.refreshContaner?.headerReset()
                }else{
                    self?.refreshContaner?.headerReset()
                    self?.refreshContaner?.footerNodata()
//                    self?.pageSO?.pagenumber = PageListSO.firstPageNumber //清空页数
                    self?.pageSO?.sorttime = ""
                }
            }
        })
        
        if showFooter {
            self.refreshContaner.addFooterWithCallback(RefreshFooterView.footer(),callback: { [weak self] ()-> Void in
//                let nowPage = self?.pageSO?.pagenumber
//                self?.pageSO?.pagenumber += 1//页数+1
                
                self?.footerRequest(self!.pageSO){ [weak self] hasData,lastUpdateTime in
                    self?.pageSO?.sorttime = lastUpdateTime
                    if hasData {
                        self?.tableView?.reloadData()
                        self?.refreshContaner?.footerReset()
                    }else{
                        self?.refreshContaner?.footerNodata()
//                        self?.pageSO?.pagenumber = nowPage! //页数恢复
                    }
                }
            })
        }
    }
    
    /** 滚轮是否恢复位置 */
    var contentOffsetRest:Bool = true
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if hasSetUp {
            if contentOffsetRest{
                self.refreshContaner.scrollerView.contentOffset.y = 0 //滚轮位置恢复
            }
        }else{
            self.setupRefresh()
            self.refreshContaner.headerBeginRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
class PageListSO:NSObject{
    
    static let firstPageNumber:Int = 1
    
    var objectsperpage:Int = 20 //每页显示20个
//    var pagenumber:Int = firstPageNumber//当前页码
//    var lastupdatetime:String = ""//年月日 时分秒
    var sorttime:String = "" //排序专用
    
}
