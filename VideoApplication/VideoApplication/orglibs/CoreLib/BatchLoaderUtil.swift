//
//  File.swift
//  ImageSlideViewTest
//
//  Created by 高扬 on 15/8/19.
//  Copyright (c) 2015年 高扬. All rights reserved.
//

//import Foundation
import UIKit

typealias LoadCompletionHandler = (image:UIImage,params:[AnyObject])->Void

private class LoaderVo:NSObject {
    var url:String
    var callBack:LoadCompletionHandler?
    var argArray:[AnyObject]
    
    init(_ url:String,_ callBack:LoadCompletionHandler?,_ argArray:[AnyObject]){
        self.url = url
        self.callBack = callBack
        self.argArray = argArray
    }
}
class BatchLoaderUtil: NSObject {
    
    private static var imageCache:Dictionary<String,UIImage> = Dictionary<String,UIImage>()
    //坑!!! 一定要用var 不然无法存数据进去
    
    private static var callBackDic:Dictionary<String,NSMutableArray> = Dictionary<String,NSMutableArray>()
    //存放所有url的callBack相关参数 类似同一个url需要多个回调 在加载完成后全部回调
    
    class func loadFile(url:String,callBack:LoadCompletionHandler?,_ args:AnyObject...){
        let targetImage:UIImage? = imageCache[url]
        if let image = targetImage{
            if let handler = callBack{
                handler(image:image,params: args)
            }
            return//直接回调
        }
        if url.componentsSeparatedByString("://").count < 2{ //不包含 说明是本地文件
            let image = UIImage(named: url) //本地加载
            if image != nil{
                imageCache.updateValue(image!, forKey: url) //存储文件
                if let handler = callBack{
                    handler(image:image!,params: args)
                }
            }
            return//直接回调
        }
        saveCallBack(url,callBack,args)
    }
    
    private static func saveCallBack(url:String,_ callBack:LoadCompletionHandler?,_ argArray:[AnyObject]){
        var paraArray:NSMutableArray? = callBackDic[url]
        var startLoad:Bool = false
        if  paraArray == nil{//不存在
            paraArray = NSMutableArray() //创建空的数组
            callBackDic.updateValue(paraArray!, forKey: url)//混存数组
            startLoad = true //可以开始加载
        }
        
        if(!checkHasCallFunc(paraArray,url,callBack)){
            let loaderVo = LoaderVo(url,callBack,argArray)
            paraArray?.addObject(loaderVo)
        }else{
            print("重复存入回调函数")
        }
        
        if startLoad{
            loadStart(url/*,callBack,argArray*/)
        }
    }
    //检查回调函数是否已经存在
    private static func checkHasCallFunc(paraArray:NSMutableArray?,_ url:String,_ callBack:LoadCompletionHandler?)->Bool{
        for para in paraArray!{ //遍历后依次回调
            _ = (para as! LoaderVo)
            //            callBack == loaderVo.callBack
            //            if (loaderVo.url == url || &callBack == &loaderVo.callBack) {
            //                return true
            //            }
        }
        return false
    }
    
    private static func loadStart(url:String/*,_ callBack:LoadCompletionHandler?,_ argArray:[AnyObject]*/){
        _ = LoaderBean(url: url,loadComplete: { bean in
            //                println("得到图片数据:\(bean.image)")
            BatchLoaderUtil.imageCache.updateValue(bean.image!, forKey: bean.url)
            //            if let handler = callBack{
            //                handler(data:bean.image!,params: argArray)
            //            }
            dispatch_async(dispatch_get_main_queue(),{//通知主线程刷新 神坑 异步加载完毕的数据在其他线程上 必须通知主线程刷新调用逻辑
                var paraArray:NSMutableArray? = BatchLoaderUtil.callBackDic[bean.url]
                BatchLoaderUtil.callBackDic.removeValueForKey(bean.url) //清除掉数据
                if paraArray != nil{
                    for para in paraArray!{ //遍历后依次回调
                        let loaderVo = (para as! LoaderVo)
                        if let handler = loaderVo.callBack {
                            handler(image:bean.image!,params: loaderVo.argArray)
                        }
                    }
                }
                paraArray = nil //释放
            })
            },loadError: { error in
                
            }
        )
        
        
    }
    
}
private class LoaderBean{
    
    var image:UIImage?
    var loadComplete:(LoaderBean)->Void?
    var loadError:(String)->Void?
    var url:String
    
    init(url:String,loadComplete:(LoaderBean)->Void,loadError:(String)->Void){
        self.url = url;
        self.loadComplete = { loadComplete($0) }
        self.loadError = { loadError($0) }
        
        connectUrl()
    }
    
    private func connectUrl(){
        let req = NSURLRequest(URL: NSURL(string:self.url)!)
        //        var conn:NSURLConnection = NSURLConnection(request: req, delegate: self)!
        ////        conn.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        //        //当前线程循环跑动
        //        conn.start() //开始加载
        
        NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue()) { [weak self](response:NSURLResponse?, data:NSData?, error:NSError?) -> Void in
            self!.image = UIImage(data: data!)
            //            self.image?.size.
            //            println(self.image)
            self!.loadComplete(self!)
        }
    }
    
    //    //Mark 将要发送请求
    //    func connection(connection: NSURLConnection, willSendRequest request: NSURLRequest, redirectResponse response: NSURLResponse?) -> NSURLRequest? {
    //      return request
    //    }
    //
    //    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
    //        //接收响应
    //    }
    //
    //    func connection(connection: NSURLConnection, needNewBodyStream request: NSURLRequest) -> NSInputStream? {
    //        //需要新的内容流
    //        return request.HTTPBodyStream
    //    }
    //
    //    func connection(connection: NSURLConnection, didSendBodyData bytesWritten: Int, totalBytesWritten: Int, totalBytesExpectedToWrite: Int) {
    //        //发送数据请求
    //    }
    //
    //    //Mark 缓存响应
    //    func connection(connection: NSURLConnection, willCacheResponse cachedResponse: NSCachedURLResponse) -> NSCachedURLResponse? {
    //        return cachedResponse
    //    }
    //
    //    //Mark 收到数据了
    //    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
    //        println("收到数据了")
    //    }
    //
    //    //Mark 加载结束
    //    func connectionDidFinishLoading(connection: NSURLConnection) {
    //        loadComplete(self)
    //    }
    
    
    
    
    
    
    
}


