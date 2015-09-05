//
//  InfoClass.swift
//  Manhole_Proj
//
//  Created by Takuro Mori on 2015/08/27.
//  Copyright (c) 2015年 Takuro. All rights reserved.
//

import UIKit
import AVFoundation

class InfoClass: GraffitiSubClass{
    
    // セッション.
    var mySession : AVCaptureSession!
    // デバイス.
    var myDevice : AVCaptureDevice!
    // 画像のアウトプット.
    var myImageOutput : AVCaptureStillImageOutput!
    
    @IBOutlet var HomeButton:UIButton?
    @IBOutlet var ChangeButton:UIButton?
    @IBOutlet var TitleLabel:UILabel?
    @IBOutlet var TitleButtom: UILabel?
    
    
//    @IBOutlet var ShopSign:UIButton?
//    @IBOutlet var ShopSign2:UIButton?
//    @IBOutlet var PopupView:UIView?
//    @IBOutlet var ShopScrollView:UIScrollView?
//    @IBOutlet var ShopImageView:UIImageView?
//    @IBOutlet var BackButton:UIButton?
    
    var ManholeName = ""
    
    var flag: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        println("Info")
        InfoFlag = true
        flag = false
        
        CameraInit()
        
        motionInit(sceneInit())
//        createword("Hello",x: 0.0,y: -50.0,z: 0.0)
        
        //TitleLabel?.text = ManholeName + ":Infomation"
        TitleLabel?.text = "\nArea Information"
        TitleLabel?.numberOfLines = 2
        TitleLabel?.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.29, alpha: 1.0)
        TitleButtom?.text = "〒" + "滋賀県草津市野路"
        
        
        ChangeButton?.addTarget(self, action: "ClickButton:", forControlEvents: .TouchUpInside)
        ChangeButton?.tag = 2
        ChangeButton?.setImage(UIImage(named: "Img/illust.png"), forState: .Normal)
        
        
        HomeButton?.addTarget(self, action: "ClickButton:", forControlEvents: .TouchUpInside)
        HomeButton?.setImage(UIImage(named: "Img/home.png"), forState: .Normal)
        HomeButton?.tag = 3
        
        self.view.addSubview(TitleLabel!)
        self.view.addSubview(TitleButtom!)
        self.view.addSubview(HomeButton!)
        self.view.addSubview(ChangeButton!)
        
//        ShopSign?.addTarget(self, action: "ClickSign:", forControlEvents: .TouchUpInside)
//        //        ShopSign?.frame = CGRectMake(32, 48, 36, 40)
//        ShopSign?.tag = 10
//        self.view.addSubview(ShopSign!)
//        
//        ShopSign2?.addTarget(self, action: "ClickSign:", forControlEvents: .TouchUpInside)
//        //        ShopSign2?.frame = CGRectMake(32, 48, 36, 40)
//        ShopSign2?.tag = 11
//        self.view.addSubview(ShopSign2!)

        InfoButtoninit()
    }
    
    func ClickButton(sender:UIButton){
        if sender.tag == 2{
            self.performSegueWithIdentifier("ChangeToGraffiti", sender: self)
        }else if sender.tag == 3{
            self.performSegueWithIdentifier("FromInfoToHome", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FromInfoToHome"{
            var VC : TopPage = segue.destinationViewController as! TopPage
        }
        else if segue.identifier == "ChangeToGraffiti"{
            var VC : GraffitiClass = segue.destinationViewController as! GraffitiClass
            VC.ManholeName = self.ManholeName
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        mySession.stopRunning()
        for output in mySession.outputs {
            mySession.removeOutput(output as! AVCaptureOutput)
        }
        for input in mySession.inputs {
            mySession.removeInput(input as! AVCaptureInput)
        }
        motionManager.stopDeviceMotionUpdates()
        
        myImageOutput = nil
        myDevice = nil
        mySession = nil
        HomeButton = nil
        ChangeButton = nil
        TitleLabel = nil
        self.view.removeFromSuperview()
//        removeAllSubviews(self.view)
    }
    
    func removeAllSubviews(parentView: UIView){
        var subviews = parentView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
    }
    
    func CameraInit(){
        // セッションの作成.
        mySession = AVCaptureSession()
        
        // デバイス一覧の取得.
        let devices = AVCaptureDevice.devices()
        
        // バックカメラをmyDeviceに格納.
        for device in devices{
            if(device.position == AVCaptureDevicePosition.Back){
                myDevice = device as! AVCaptureDevice
            }
        }
        
        // バックカメラからVideoInputを取得.
        let videoInput = AVCaptureDeviceInput.deviceInputWithDevice(myDevice, error: nil) as! AVCaptureDeviceInput
        
        // セッションに追加.
        mySession.addInput(videoInput)
        
        // 出力先を生成.
        myImageOutput = AVCaptureStillImageOutput()
        
        // セッションに追加.
        mySession.addOutput(myImageOutput)
        
        // 画像を表示するレイヤーを生成.
        let myVideoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.layerWithSession(mySession) as! AVCaptureVideoPreviewLayer
        //        myVideoLayer.frame = self.view.bounds
        myVideoLayer.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        myVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        //         Viewに追加.
        self.view.layer.addSublayer(myVideoLayer)
        
        // セッション開始.
        mySession.startRunning()
        
    }

    //店情報を重ねて表示
//    func ClickSign(sender:UIButton){
//        //        let shopView = ShopView()
//        //        shopView.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
//        //        shopView.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
//        //        self.presentViewController(shopView, animated: true, completion:nil)
//        if !flag{
//            PopupView?.hidden = false
//            
//            if sender.tag == 10{
//                let shopImage01 = UIImage(named:"Img/shop01.jpg")!
//                ShopImageView?.image = shopImage01
//                self.PopupView!.addSubview(ShopImageView!)
//            }else if sender.tag == 11{
//                let shopImage02 = UIImage(named:"Img/shop02.jpg")!
//                ShopImageView?.image = shopImage02
//                self.PopupView!.addSubview(ShopImageView!)
//            }
//            
//            PopupView?.backgroundColor = UIColor.whiteColor()
//            PopupView?.layer.cornerRadius = 4.0
//            self.view.addSubview(PopupView!)
//            
//            BackButton?.setImage(UIImage(named: "Img/BackIcon.png"), forState: .Normal)
//            BackButton?.addTarget(self, action: "BackButtonAct:", forControlEvents: .TouchUpInside)
//            BackButton?.frame = CGRectMake(8, 8, 46, 30)
//            self.PopupView!.addSubview(BackButton!)
//            
//            flag = true
//        }
//    }
//    
//    func BackButtonAct(sender:UIButton){
//        PopupView?.hidden = true
//        flag = false
//    }
    
    func InfoButtoninit(){
        InfoButton = UIButton()
        InfoButton?.frame = CGRectMake(0, 0, 200, 50)
        InfoButton?.backgroundColor = UIColor.redColor()
        InfoButton?.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height-30)
        InfoButton?.setTitle("Get infomation", forState: .Normal)
        InfoButton?.addTarget(self, action: "GetInformation:", forControlEvents: .TouchUpInside)
        self.view.addSubview(InfoButton!)

        InfoButton?.hidden = true
    }
    
    func GetInformation(sender:UIButton){
        
    }
}


