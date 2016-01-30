//
//  UIViewController.swift
//  VideoApplication
//
//  Created by 高扬 on 16/1/24.
//  Copyright (c) 2016年 高扬. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        self.title = "视频播放器"
        
        super.viewDidLoad()

        let vvc = VideoViewController()
//        vvc.navigationController// = self.navigationController
        addChildViewController(vvc)
        
        self.view.addSubview(vvc.view)
//        self.view.userInteractionEnabled = false
        vvc.view.snp_makeConstraints { (make) -> Void in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(260)
        }
        
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
