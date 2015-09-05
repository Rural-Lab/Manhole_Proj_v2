//
//  InfoClass.swift
//  Manhole_Proj
//
//  Created by Takuro Mori on 2015/08/27.
//  Copyright (c) 2015年 Takuro. All rights reserved.
//

import UIKit
import MapKit

class AlbumListClass: UIViewController {
    
    @IBOutlet var myScrollView: UIScrollView?
    @IBOutlet var ChangeButton: UIButton?
    
    
    @IBOutlet var HomeButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        HomeButton?.frame = CGRectMake(10, 2, 35, 35)
        HomeButton?.setImage(UIImage(named: "Img/HomeIcon.png"), forState: .Normal)
        HomeButton?.tag = 3
        self.view.addSubview(HomeButton!)
        
        // ScrollViewを生成.
//        myScrollView = UIScrollView()
        
        // ScrollViewの大きさを設定する.
//        myScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)å
        
//        var imageCount = 7
//        var row = 4
//        var imageSize = (self.view.frame.size.width-20)/4
//        var Urlstr:String = ""
//        
//        
//        for i in 0..<imageCount/4+1{
//            if i == imageCount/4{
//                row = imageCount%4
//            }
//            if i == 0{
//                let LabelBar = UILabel(frame: CGRectMake(0, 0, self.view.frame.width, 40))
//                LabelBar.layer.position = CGPoint(x: self.view.frame.width/2, y: 20)
//                LabelBar.textAlignment = NSTextAlignment.Left
//                LabelBar.backgroundColor = UIColor.lightGrayColor()
//                LabelBar.textColor = UIColor.whiteColor()
//                LabelBar.text = "2015/08/10"
//                myScrollView!.addSubview(LabelBar)
//            }
//            for j in 0..<row{
//                // frameの値を設定する.
//                let PictButton = UIButton(frame: CGRectMake(CGFloat(j)*imageSize+10, CGFloat(i+1)*imageSize, imageSize, imageSize))
//                
//                // UIImageに画像を設定する.
////                if (i == 0 && j == 0) {
////                    Urlstr = "http://www.pref.osaka.lg.jp/attach/22799/00162227/osaka_fu.jpg"
////                }
////                if (i == 0 && j == 1) {
////                    Urlstr = "http://www.pref.osaka.lg.jp/attach/22799/00162350/nose_tyo.jpg"
////                }
////                if (i == 0 && j == 2) {
////                    Urlstr = "http://www.pref.osaka.lg.jp/attach/22799/00162323/mino_shi.jpg"
////                }
////                if (i == 0 && j == 3) {
////                    Urlstr = "http://www.pref.osaka.lg.jp/attach/22799/00162376/shimamoto_tyo.jpg"
////                }
////                if (i == 1 && j == 0) {
////                    Urlstr = "http://www.pref.osaka.lg.jp/attach/22799/00162378/osaka_shi.jpg"
////                }
////                
////                let url = NSURL(string: Urlstr)
////                var err: NSError?
////                var imageData :NSData = NSData(contentsOfURL: url!,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!
//                
//                let myImage = UIImage(named: "Img/osaka_fu.jpg")!
////                let myImage = UIImage(data: imageData)
//                
//                PictButton.setBackgroundImage(myImage, forState: .Normal)
//                PictButton.addTarget(self, action: "PushButton:", forControlEvents: .TouchUpInside)
//                PictButton.tag = i*4+j
//                
//                println(PictButton)
//                // ScrollViewにmyImageViewを追加する.
//                myScrollView!.addSubview(PictButton)
//            }
//        }
//        // ScrollViewにcontentSizeを設定する.
//        myScrollView!.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)
//        ChangeButton?.addTarget(self, action: "ChangeButton:", forControlEvents: .TouchUpInside)
//        // ViewにScrollViewをAddする.
//        self.view.addSubview(myScrollView!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func PushButton(sender:UIButton){
        println("push Button \(sender.tag)")
    }

    func ChangeButton(sender:UIButton){
        self.performSegueWithIdentifier("ChangeButtonToMap", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ChangeButtonToMap"{
            var VC : AlbumMapClass = segue.destinationViewController as! AlbumMapClass
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
//        removeAllSubviews(self.view)
        myScrollView = nil
        ChangeButton = nil
        self.view.removeFromSuperview()
    }
    
    func removeAllSubviews(parentView: UIView){
        var subviews = parentView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}


