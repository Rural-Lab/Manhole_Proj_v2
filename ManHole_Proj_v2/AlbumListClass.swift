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
    

    @IBOutlet var ScrollView: UIScrollView?
    
    @IBOutlet var Manhole1: UIButton?
    @IBOutlet var Manhole2: UIButton?
    @IBOutlet var Manhole3: UIButton?
    @IBOutlet var Manhole4: UIButton?
    @IBOutlet var Manhole5: UIButton?
    @IBOutlet var Manhole6: UIButton?
    @IBOutlet var Manhole7: UIButton?
    @IBOutlet var Manhole8: UIButton?
    @IBOutlet var Manhole9: UIButton?
    @IBOutlet var Manhole10: UIButton?
    @IBOutlet var Manhole11: UIButton?
    
    
    @IBOutlet var AlbumList: UILabel?
    @IBOutlet var HomeButton: UIButton?
    
    var ContentWindow: UIWindow?
    var ManholeImgView: UIImageView?
    var explanationText: UITextView?

    @IBAction func tapscreen(sender: AnyObject) {
        self.view.endEditing(true)
        println("test")
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        AlbumList?.text = "\nAlbum List"
        AlbumList?.numberOfLines = 2
        ChangeButton?.addTarget(self, action: "ClickButton:", forControlEvents: .TouchUpInside)
        ChangeButton?.setImage(UIImage(named: "Img/albummap.png"), forState: .Normal)
        ChangeButton?.tag = 2
        HomeButton?.addTarget(self, action: "ClickButton:", forControlEvents: .TouchUpInside)
        HomeButton?.setImage(UIImage(named: "Img/home.png"), forState: .Normal)
        HomeButton?.tag = 3
        self.view.addSubview(AlbumList!)
        self.view.addSubview(ChangeButton!)
        self.view.addSubview(HomeButton!)
        
        WindowInit()
        ManholeSetting()
        
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

    func ClickButton(sender:UIButton){
        if sender.tag == 2{
            self.performSegueWithIdentifier("ChangeToMap", sender: self)
        }else if sender.tag == 3{
            self.performSegueWithIdentifier("FromAlbumListToHome", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FromAlbumListToHome"{
            var VC : TopPage = segue.destinationViewController as! TopPage
        }
        if segue.identifier == "ChangeToMap"{
            var VC : AlbumMapClass = segue.destinationViewController as! AlbumMapClass
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        ManholeImgView?.image = nil
        
        myScrollView = nil
        ChangeButton = nil
        ContentWindow = nil
        ManholeImgView = nil
        explanationText = nil
        Manhole1 = nil
        Manhole2 = nil
        Manhole3 = nil
        Manhole4 = nil
        Manhole5 = nil
        Manhole6 = nil
        Manhole7 = nil
        Manhole8 = nil
        Manhole9 = nil
        Manhole10 = nil
        Manhole11 = nil
        
        removeAllSubviews(self.view)
        self.view.removeFromSuperview()
    }
    
    func removeAllSubviews(parentView: UIView){
        var subviews = parentView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    func ManholeSetting(){
        Manhole1?.setImage(UIImage(named: "Img/SaveManhole5.png"), forState: .Normal)
        Manhole2?.setImage(UIImage(named: "Img/SaveManhole6.png"), forState: .Normal)
        Manhole3?.setImage(UIImage(named: "Img/SaveManhole7.png"), forState: .Normal)
        Manhole4?.setImage(UIImage(named: "Img/SaveManhole1.png"), forState: .Normal)
        Manhole5?.setImage(UIImage(named: "Img/SaveManhole2.png"), forState: .Normal)
        Manhole6?.setImage(UIImage(named: "Img/SaveManhole3.png"), forState: .Normal)
        Manhole7?.setImage(UIImage(named: "Img/SaveManhole4.png"), forState: .Normal)
        Manhole8?.setImage(UIImage(named: "Img/osaka_fu.jpg"), forState: .Normal)
        Manhole9?.setImage(UIImage(named: "Img/SaveManhole8.png"), forState: .Normal)
        Manhole10?.setImage(UIImage(named: "Img/SaveManhole9.png"), forState: .Normal)
        Manhole11?.setImage(UIImage(named: "Img/SaveManhole10.png"), forState: .Normal)
        
        Manhole1?.tag = 11
        Manhole2?.tag = 12
        Manhole3?.tag = 13
        Manhole4?.tag = 14
        Manhole5?.tag = 15
        Manhole6?.tag = 16
        Manhole7?.tag = 17
        Manhole8?.tag = 18
        Manhole9?.tag = 19
        Manhole10?.tag = 20
        Manhole11?.tag = 21
        
        Manhole1?.addTarget(self, action: "ManholeTouch:", forControlEvents: .TouchUpInside)
        self.view.addSubview(Manhole1!)
        Manhole2?.addTarget(self, action: "ManholeTouch:", forControlEvents: .TouchUpInside)
        self.view.addSubview(Manhole1!)
        Manhole3?.addTarget(self, action: "ManholeTouch:", forControlEvents: .TouchUpInside)
        self.view.addSubview(Manhole1!)
        Manhole4?.addTarget(self, action: "ManholeTouch:", forControlEvents: .TouchUpInside)
        self.view.addSubview(Manhole1!)
        Manhole5?.addTarget(self, action: "ManholeTouch:", forControlEvents: .TouchUpInside)
        self.view.addSubview(Manhole1!)
        Manhole6?.addTarget(self, action: "ManholeTouch:", forControlEvents: .TouchUpInside)
        self.view.addSubview(Manhole1!)
        Manhole7?.addTarget(self, action: "ManholeTouch:", forControlEvents: .TouchUpInside)
        self.view.addSubview(Manhole1!)
        Manhole8?.addTarget(self, action: "ManholeTouch:", forControlEvents: .TouchUpInside)
        self.view.addSubview(Manhole1!)
        Manhole9?.addTarget(self, action: "ManholeTouch:", forControlEvents: .TouchUpInside)
        self.view.addSubview(Manhole1!)
        Manhole10?.addTarget(self, action: "ManholeTouch:", forControlEvents: .TouchUpInside)
        self.view.addSubview(Manhole1!)
        Manhole11?.addTarget(self, action: "ManholeTouch:", forControlEvents: .TouchUpInside)
        self.view.addSubview(Manhole1!)
        
        ScrollView!.addSubview(Manhole1!)
        ScrollView!.addSubview(Manhole2!)
        ScrollView!.addSubview(Manhole3!)
        ScrollView!.addSubview(Manhole4!)
        ScrollView!.addSubview(Manhole5!)
        ScrollView!.addSubview(Manhole6!)
        ScrollView!.addSubview(Manhole7!)
        ScrollView!.addSubview(Manhole8!)
        ScrollView!.addSubview(Manhole9!)
        ScrollView!.addSubview(Manhole10!)
        ScrollView!.addSubview(Manhole11!)

    }
    
    func WindowInit(){
        ContentWindow = UIWindow(frame: CGRectMake(0, 0, self.view.frame.width-30, self.view.frame.height-200))
        ContentWindow?.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        ContentWindow?.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)
        ContentWindow?.makeKeyWindow()
        self.ContentWindow?.makeKeyAndVisible()
        self.view.addSubview(ContentWindow!)
        ContentWindow?.hidden = true
        
        var CancelButton = UIButton(frame: CGRectMake(0, 0, 30, 30))
        CancelButton.setImage(UIImage(named: "Img/Cancel.png"), forState: .Normal)
        CancelButton.addTarget(self, action: "CancelPush:", forControlEvents: .TouchUpInside)
        ContentWindow?.addSubview(CancelButton)
        
        ManholeImgView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width-100, self.view.frame.width-100))
        ManholeImgView?.layer.position = CGPoint(x: ContentWindow!.frame.width/2, y: ContentWindow!.frame.width/2)
        ManholeImgView?.image = UIImage(named: "Img/White.png")
        ContentWindow?.addSubview(ManholeImgView!)
        
        explanationText = UITextView(frame: CGRectMake(0, 0, ContentWindow!.frame.width-10, ContentWindow!.frame.height/3))
        explanationText?.layer.position = CGPoint(x: ContentWindow!.frame.width/2, y: ContentWindow!.frame.height*6/7)
        explanationText?.editable = false
        explanationText?.text = "2015/08/10 \n 大阪府大阪市"
        explanationText?.font = UIFont.systemFontOfSize(20)
        ContentWindow?.addSubview(explanationText!)
        
    }
    
    func ManholeTouch(sender:UIButton){
        ContentWindow?.hidden = false
        switch sender.tag{
        case 11:
            ManholeImgView?.image = UIImage(named: "Img/SaveManhole5.png")
            explanationText?.text = "2015/08/10 \n神奈川県大磯町 "
        case 12:
            ManholeImgView?.image = UIImage(named: "Img/SaveManhole6.png")
            explanationText?.text = "2015/08/10 \n千葉県千葉市 "
        case 13:
            ManholeImgView?.image = UIImage(named: "Img/SaveManhole7.png")
            explanationText?.text = "2015/08/10 \n埼玉県ふじみ野市 "
        case 14:
            ManholeImgView?.image = UIImage(named: "Img/SaveManhole1.png")
            explanationText?.text = "2015/08/19 \n 京都府福知山市"
        case 15:
            ManholeImgView?.image = UIImage(named: "Img/SaveManhole2.png")
            explanationText?.text = "2015/08/19 \n京都府舞鶴市"
        case 16:
            ManholeImgView?.image = UIImage(named: "Img/SaveManhole3.png")
            explanationText?.text = "2015/08/19 \n京都府福知山市（三和町）"
        case 17:
            ManholeImgView?.image = UIImage(named: "Img/SaveManhole4.png")
            explanationText?.text = "2015/08/19 \n京都府八幡市 "
        case 18:
            ManholeImgView?.image = UIImage(named: "Img/osaka_fu.jpg")
            explanationText?.text = "2015/08/19 \n大阪府大阪市 "
        case 19:
            ManholeImgView?.image = UIImage(named: "Img/SaveManhole8.png")
            explanationText?.text = "2015/09/07 \n大阪府大阪市 "
        case 20:
            ManholeImgView?.image = UIImage(named: "Img/SaveManhole9.png")
            explanationText?.text = "2015/09/07 \n滋賀県草津本陣 "
        case 21:
            ManholeImgView?.image = UIImage(named: "Img/SaveManhole10.png")
            explanationText?.text = "2015/09/07 \n大阪府大阪市(一般) "
        default:
            break
        }
    }
    
    func CancelPush(sender:UIButton){
        ContentWindow?.hidden = true
    }
}


