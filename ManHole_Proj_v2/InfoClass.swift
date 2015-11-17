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
    var PopUpWindow:UIWindow?
    var InfoImageView:UIImageView?
    var Infotext:UITextView?
    
    var ManholeName = ""
    
    var flag: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        print("Info")
        InfoFlag = true
        flag = false
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        CameraInit()
        
        sceneInit(ManholeName)
        if ManholeName == "Manhole1" {
            InfoCount=2
            createImage(UIImage(named: "Img/shop01.jpg")!, x: 50, y: 0, z: 0, Type: "Info1")
            createImage(UIImage(named: "Img/shop02.jpg")!, x: 0, y: 0, z:50, Type: "Info2")
        }
        else if ManholeName == "Manhole2" {
            InfoCount=3
            createImage(UIImage(named: "Img/shop01.jpg")!, x: 50, y: 0, z: 0, Type: "Info1")
            createImage(UIImage(named: "Img/shop02.jpg")!, x: 0, y: 0, z: 50, Type: "Info2")
            createImage(UIImage(named: "Img/shop03.jpg")!, x: -50, y: 0, z: 0, Type: "Info3")
        }
        
        motionInit()
//        createword("Hello",x: 0.0,y: -50.0,z: 0.0)
        
        //TitleLabel?.text = ManholeName + ":Infomation"
        TitleLabel?.text = "\nArea Information"
        TitleLabel?.numberOfLines = 2
        TitleLabel?.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.29, alpha: 1.0)
        if ManholeName == "Manhole1"{
            TitleButtom?.text = "〒" + "大阪府大阪市北区"
        }else if ManholeName == "Manhole2"{
            TitleButtom?.text = "〒" + "滋賀県草津市草津"
        }
        
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

        InfoButtoninit()
        InfoWindowinit()
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
            let VC : GraffitiClass = segue.destinationViewController as! GraffitiClass
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
        PopUpWindow = nil
        InfoButton = nil
        
        self.view.removeFromSuperview()
//        removeAllSubviews(self.view)
    }
    
    func removeAllSubviews(parentView: UIView){
        let subviews = parentView.subviews
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
        //let videoInput = (try! AVCaptureDeviceInput.deviceInputWithDevice(myDevice))
        let videoInput = (try! AVCaptureDeviceInput(device: myDevice))
        
        // セッションに追加.
        mySession.addInput(videoInput)
        
        // 出力先を生成.
        myImageOutput = AVCaptureStillImageOutput()
        
        // セッションに追加.
        mySession.addOutput(myImageOutput)
        
        // 画像を表示するレイヤーを生成.
     //let myVideoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.layerWithSession(mySession) as AVCaptureVideoPreviewLayer
        let myVideoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: mySession)
        
     //   let myVideoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer
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
        InfoButton?.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height-70)
        InfoButton?.setTitle("Get infomation", forState: .Normal)
        InfoButton?.addTarget(self, action: "GetInformation:", forControlEvents: .TouchUpInside)
        self.view.addSubview(InfoButton!)

        InfoButton?.hidden = true
    }
    
    func InfoWindowinit(){
        PopUpWindow = UIWindow(frame: CGRectMake(0, 0, self.view.frame.width-40, self.view.frame.width-40))
        PopUpWindow?.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        PopUpWindow?.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
        self.view.addSubview(PopUpWindow!)
        PopUpWindow?.hidden = true
        
        let CancelButton = UIButton(frame: CGRectMake(0, 0, 30, 30))
        CancelButton.setImage(UIImage(named: "Img/Cancel.png"), forState: .Normal)
        CancelButton.addTarget(self, action: "CancelPush:", forControlEvents: .TouchUpInside)
        PopUpWindow?.addSubview(CancelButton)
        
        InfoImageView = UIImageView(frame: CGRectMake(0, 0, PopUpWindow!.frame.width-40, 150))
        InfoImageView?.layer.position = CGPoint(x: PopUpWindow!.frame.width/2, y: PopUpWindow!.frame.height*2/5)
        InfoImageView?.image = UIImage(named: "Img/shop03content.jpg")
        PopUpWindow?.addSubview(InfoImageView!)
        
        Infotext = UITextView(frame: CGRectMake(0, 0, PopUpWindow!.frame.width-40, 130))
        Infotext?.layer.position = CGPoint(x: PopUpWindow!.frame.width/2, y: PopUpWindow!.frame.height*3/4)
        Infotext?.font = UIFont.systemFontOfSize(20)
        Infotext?.text = "Shop\nレストラン"
        Infotext?.editable = false
        Infotext?.resignFirstResponder()
        PopUpWindow?.addSubview(Infotext!)
        
    }
    
    func GetInformation(sender:UIButton){
        print(sender.tag)
        switch sender.tag{
        case 10:
            InfoImageView?.image = UIImage(named: "Img/shop01.jpg")
            Infotext?.text = "Shop\nAngela\n012-345-6789"
        case 11:
            InfoImageView?.image = UIImage(named: "Img/shop02.jpg")
            Infotext?.text = "Shop\nグラン・ゴジエ\n012-345-6789"
        case 12:
            InfoImageView?.image = UIImage(named: "Img/shop03content.jpg")
            Infotext?.text = "Historic spot\n史跡草津宿\n077-567-0030"
        default:
            break
        }
        PopUpWindow?.hidden = false
    }
    
    func CancelPush(sender:UIButton){
        PopUpWindow?.hidden = true
    }
}


