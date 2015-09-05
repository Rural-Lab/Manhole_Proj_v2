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
    
    var ManholeName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        println("Info")
        CameraInit()
        
        motionInit(sceneInit())
        createword("Hello",x: 0.0,y: -50.0,z: 0.0)
        
        TitleLabel?.text = ManholeName + ":Infomation"
        TitleLabel?.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.29, alpha: 0.7)
        ChangeButton?.addTarget(self, action: "ClickButton:", forControlEvents: .TouchUpInside)
        ChangeButton?.tag = 2
        HomeButton?.addTarget(self, action: "ClickButton:", forControlEvents: .TouchUpInside)
        HomeButton?.setImage(UIImage(named: "Img/HomeIcon.png"), forState: .Normal)
        HomeButton?.frame = CGRectMake(10, 2, 35, 35)
        HomeButton?.tag = 3
        
        self.view.addSubview(TitleLabel!)
        self.view.addSubview(HomeButton!)
        self.view.addSubview(ChangeButton!)
        

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

}


