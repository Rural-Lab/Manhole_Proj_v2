//
//  InfoClass.swift
//  Manhole_Proj
//
//  Created by Takuro Mori on 2015/08/27.
//  Copyright (c) 2015年 Takuro. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage

class GraffitiClass: GraffitiSubClass, UITextFieldDelegate {
    
    // セッション.
    var mySession : AVCaptureSession!
    // デバイス.
    var myDevice : AVCaptureDevice!
    // 画像のアウトプット.
    var myImageOutput : AVCaptureStillImageOutput!
    
    var ManholeName = ""
    
    @IBOutlet var HomeButton:UIButton?
    @IBOutlet var ChangeButton:UIButton?
    @IBOutlet var TitleLabel:UILabel?
    
    var SelectWindow:UIWindow?
    var subWindow:UIWindow?
    
    var myTextField: UITextField?
    var CurrentImage:UIImage?
    var imageView: UIImageView?
    var CurrentSubView = "None"

    var Cur_image : UIImage! = nil
    var canvas_View : UIImageView?
    var touchedPoint : CGPoint = CGPointZero
    var bezierPath : UIBezierPath! = nil
    var firstMovedFlag : Bool = true
    var red :CGFloat=0.91
    var green :CGFloat = 0.3
    var blue :CGFloat = 0.24
    var width :CGFloat = 5.0
    
    @IBAction func tapscreen(sender: AnyObject) {
        
        self.view.endEditing(true)
    }
    //-------------------------------viewDidLoad-------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InfoFlag = false
        
        CameraInit()
        sceneInit(ManholeName)
        motionInit()
        LoadFile(ManholeName)
        buttonInit()
        textFieldInit()
        imageViewInit()
        SelectWindowInit()
        makesuSubWindowInit()
        CanvasInit()
    }
    
    //-------------------------------viewDidDisappear-------------------------------------
    //viewDidDisappear
    override func viewDidDisappear(animated: Bool) {
        
        SelectWindow?.removeFromSuperview()
        
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
        SelectWindow = nil
        subWindow = nil
        myTextField?.delegate = nil
        myTextField = nil
        CurrentImage=nil
        imageView = nil
        canvas_View = nil
        Cur_image=nil
        bezierPath=nil
        
        print("diddispaer")
//        removeAllSubviews(self.view)
        
        self.view.removeFromSuperview()
    }

    //removeAllSubviews
    func removeAllSubviews(parentView: UIView){
        let subviews = parentView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    //-------------------------------Initialize-------------------------------------
    //Camera Initialize
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
        let videoInput = (try! AVCaptureDeviceInput(device: myDevice))
        
        // セッションに追加.
        mySession.addInput(videoInput)
        
        // 出力先を生成.
        myImageOutput = AVCaptureStillImageOutput()
        
        // セッションに追加.
        mySession.addOutput(myImageOutput)
        
        // 画像を表示するレイヤーを生成.
//        let myVideoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(mySession) as AVCaptureVideoPreviewLayer
        let myVideoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: mySession) as AVCaptureVideoPreviewLayer
        //        myVideoLayer.frame = self.view.bounds
        myVideoLayer.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        myVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        //         Viewに追加.
        self.view.layer.addSublayer(myVideoLayer)
        
        // セッション開始.
        mySession.startRunning()
        
    }
    
    //button Initialize
    func buttonInit(){
        ChangeButton?.addTarget(self, action: "ClickButton:", forControlEvents: .TouchUpInside)
        ChangeButton?.tag = 2
        ChangeButton?.setImage(UIImage(named: "Img/areainfo.png"), forState: .Normal)
        
        HomeButton?.addTarget(self, action: "ClickButton:", forControlEvents: .TouchUpInside)
        HomeButton?.setImage(UIImage(named: "Img/home.png"), forState: .Normal)
//        HomeButton?.frame = CGRectMake(10, 2, 35, 35)
        HomeButton?.tag = 3
        
        TitleLabel?.text = "\nCanvas"
        TitleLabel?.numberOfLines = 2
        self.view.addSubview(TitleLabel!)
        self.view.addSubview(HomeButton!)
        self.view.addSubview(ChangeButton!)
    }
    
    //textField Initialize
    func textFieldInit(){
        myTextField = UITextField(frame: CGRectMake(0,0,200,60))
        myTextField?.placeholder = "Enter text!!"
        myTextField?.delegate = self
        myTextField?.borderStyle = UITextBorderStyle.RoundedRect
        myTextField?.layer.position = CGPoint(x:self.view.bounds.width/2,y:self.view.bounds.height/2);
        self.view.addSubview(myTextField!)
        myTextField?.hidden = true
    }
    
    func imageViewInit(){
        imageView = UIImageView(frame: CGRectMake(0, 0, 100, 100))
        imageView?.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        self.view.addSubview(imageView!)
        imageView?.hidden = true
    }

    //SelectWindow Initialize
    func SelectWindowInit(){
        let IconWidth = self.view.frame.width/6
        let marginWidth = self.view.frame.width/15
        SelectWindow = UIWindow(frame: CGRectMake(0, self.view.frame.height-IconWidth, self.view.frame.width, IconWidth))
        SelectWindow?.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7)
        SelectWindow?.makeKeyWindow()
        self.SelectWindow?.makeKeyAndVisible()
        
        for i in 0..<4{
            let SelectButton=UIButton(frame: CGRectMake((IconWidth+IconWidth/5*2)*CGFloat(i)+marginWidth/2, 0, IconWidth+IconWidth/5*2, IconWidth))
            SelectButton.tag = i+1
            SelectButton.addTarget(self, action: "PushSelectButton:", forControlEvents: .TouchUpInside)
            
            switch i{
            case 0:
                let IconImage = UIImage(named: "Img/CharIcon.png")
                SelectButton.setBackgroundImage(IconImage, forState: .Normal)
            case 1:
                let IconImage = UIImage(named: "Img/IllustIcon.png")
                SelectButton.setBackgroundImage(IconImage, forState: .Normal)
                
            case 2:
                let IconImage = UIImage(named: "Img/StampIcon.png")
                SelectButton.setBackgroundImage(IconImage, forState: .Normal)
            case 3:
                let IconImage = UIImage(named: "Img/CameraIcon.png")
                SelectButton.setBackgroundImage(IconImage, forState: .Normal)
                
            default:
                break
            }
            
            self.SelectWindow!.addSubview(SelectButton)
        }
    }
    
    //makesuSubWindow
    func makesuSubWindowInit(){
        let IconWidth = self.view.frame.width/6
        
        subWindow = UIWindow(frame: CGRectMake(0, self.view.frame.height-IconWidth*2, self.view.frame.width, IconWidth))
        subWindow!.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 0.7)
        subWindow!.makeKeyWindow()
        subWindow!.makeKeyAndVisible()
        subWindow!.tag = 2
        
        self.view.addSubview(subWindow!)
        
        subWindow!.hidden = true
    }
    
    
    //CanvasInit
    func CanvasInit(){
        canvas_View = UIImageView(frame: CGRectMake(0, 0, 260, 260))
        canvas_View?.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/5*2)
        canvas_View?.image = UIImage(named: "Img/White.png")
        canvas_View?.backgroundColor = UIColor.clearColor()
        canvas_View?.layer.borderWidth = 2
        canvas_View?.layer.borderColor = UIColor(red: 0.8, green: 0.0, blue: 0.8, alpha: 0.7).CGColor
        self.view.addSubview(canvas_View!)
        Cur_image = canvas_View?.image
        canvas_View?.hidden = true
    }
    
    
    //-------------------------------textField-------------------------------------
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        SaveString(textField.text!, ManholeName: ManholeName)
        
        let tmpviwe = SelectWindow?.viewWithTag(1)
        tmpviwe?.backgroundColor = UIColor.clearColor()
        textField.resignFirstResponder()
        textField.endEditing(true)
        textField.hidden = true
        subWindow!.hidden = true
        
        return true
    }
    
    //-------------------------------Button-------------------------------------
    //Self.view Button
    func ClickButton(sender:UIButton){
        if sender.tag == 2{
            self.performSegueWithIdentifier("ChangeToInfo", sender: self)
        }else if sender.tag == 3{
            self.performSegueWithIdentifier("FromGraffitiToHome", sender: self)
        }
    }
    
    //Select Button
    func PushSelectButton(sender:UIButton){
        removeAllSubviews(subWindow!)

        subWindow?.hidden = false
        myTextField!.hidden = true
        imageView?.hidden = true
        CurrentImage=nil
        canvas_View?.hidden = true
        CurrentImage=nil
        
        for i in 1..<5{
            let tmpviwe = SelectWindow?.viewWithTag(i)
            tmpviwe?.backgroundColor = UIColor.clearColor()
        }
        
        switch sender.tag{
        case 1:
            if CurrentSubView == "Char" {
                subWindow?.hidden = true
                CurrentSubView="None"
                break
            }
            sender.backgroundColor = UIColor.whiteColor()
            CurrentSubView="Char"
            CharIcon()
            
        case 2:
            if CurrentSubView == "Illust" {
                subWindow?.hidden = true
                CurrentSubView="None"
                break
            }
            sender.backgroundColor = UIColor.whiteColor()
            CurrentSubView="Illust"
            
            IllustIcon()
            
        case 3:
            if CurrentSubView == "Stamp" {
                subWindow?.hidden = true
                CurrentSubView="None"
                break
            }
            sender.backgroundColor = UIColor.whiteColor()
            CurrentSubView="Stamp"
            StampIcon()
            
        case 4:
            if CurrentSubView == "Camera" {
                subWindow?.hidden = true
                CurrentSubView="None"
                break
            }
            sender.backgroundColor = UIColor.whiteColor()
            CurrentSubView="Camera"
            CameraIcon()
            
        default:
            break
        }
    }
    
    func PushButton(sender:UIButton){
        subWindow?.hidden = true
        removeAllSubviews(subWindow!)
    }
    
    func PushIllustButton(sender:UIButton){
        if sender.tag < 5{
            
        }
        else{
            SaveImage(Cur_image, ManholeName:ManholeName)
            canvas_View?.hidden = true
            canvas_View?.image = UIImage(named: "Img/White.png")
            Cur_image = canvas_View?.image
        }
    }
    
    func PushStampButton(sender:UIButton){
        if sender.tag < 5{
            imageView?.hidden = false
            
            switch sender.tag{
                case 1:
                    CurrentImage = UIImage(named: "Img/Stamp1.png")
                case 2:
                    CurrentImage = UIImage(named: "Img/Stamp2.png")
                case 3:
                    CurrentImage = UIImage(named: "Img/Stamp3.png")
                case 4:
                    CurrentImage = UIImage(named: "Img/Stamp4.png")
                default:
                    break
            }
            
            imageView?.image = CurrentImage
        }
        else{
            print("OKButten")
//            createword("Hello")
            SaveImage(CurrentImage!, ManholeName:ManholeName)
            imageView?.hidden = true
            CurrentImage=nil
        }
    }
    
    func PushCameraButton(sender:UIButton){
        let ViewImage = self.view.GetImage() as UIImage
        let myComposeFilter = CIFilter(name: "CIAdditionCompositing")
        
        myComposeFilter!.setValue(CIImage(image: ViewImage), forKey: kCIInputImageKey)
        
        // ビデオ出力に接続.
        let myVideoConnection = myImageOutput.connectionWithMediaType(AVMediaTypeVideo)
        
        // 接続から画像を取得.
        self.myImageOutput.captureStillImageAsynchronouslyFromConnection(myVideoConnection, completionHandler: { (imageDataBuffer, error) -> Void in
            
            // 取得したImageのDataBufferをJpegに変換.
            let myImageData : NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer)
            
            // JpegからUIIMageを作成.
            let myImage : UIImage = UIImage(data: myImageData)!
            myComposeFilter!.setValue(CIImage(image: myImage), forKey: kCIInputBackgroundImageKey)
            let finalImage : UIImage = UIImage(CIImage: myComposeFilter!.outputImage!)
            print(finalImage)
            // アルバムに追加.
            UIImageWriteToSavedPhotosAlbum(finalImage, self, "image:didFinishSavingWithError:contextInfo:", nil)
            
        })
    }

    func image(image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutablePointer<Void>) {
        if error != nil {
            //プライバシー設定不許可など書き込み失敗時は -3310 (ALAssetsLibraryDataUnavailableError)
            print(error.code)
        }
    }
    
    //-------------------------------Select Button Func-------------------------------------
    //Char Button Pushed
    func CharIcon(){
        myTextField!.hidden = false
    }
    
    //Illust Button Pushed
    func IllustIcon(){
        canvas_View?.image = UIImage(named: "Img/White.png")
        canvas_View?.backgroundColor = UIColor.clearColor()
        
        let IconWidth = self.view.frame.width/6
        let marginWidth = self.view.frame.width/15
        
        subWindow?.backgroundColor = UIColor(red: 0.8, green: 0.0, blue: 0.8, alpha: 0.7)
        
        for i in 0..<3{
            let IllustButton=UIButton(frame: CGRectMake(IconWidth*CGFloat(i)+marginWidth*CGFloat(i+1), 0, IconWidth, IconWidth))
            IllustButton.tag = i+1
            IllustButton.addTarget(self, action: "PushIllustButton:", forControlEvents: .TouchUpInside)
            
            switch i{
            case 0:
                let IconImage = UIImage(named: "Img/eraser.png")
                IllustButton.setBackgroundImage(IconImage, forState: .Normal)
            case 1:
                let IconImage = UIImage(named: "Img/Colorpallet.png")
                IllustButton.setBackgroundImage(IconImage, forState: .Normal)
            case 2:
                let IconImage = UIImage(named: "Img/lineWheight.png")
                IllustButton.setBackgroundImage(IconImage, forState: .Normal)
                //            case 3:
                //                let IconImage = UIImage(named: "Stamp4.png")
                //                IllustButton.setBackgroundImage(IconImage, forState: .Normal)
                
            default:
                break
            }
            IllustButton.enabled = false
            
            self.subWindow!.addSubview(IllustButton)
        }
        
        let EnterButton=UIButton(frame: CGRectMake(self.view.frame.width-IconWidth, 0, IconWidth, IconWidth))
        EnterButton.addTarget(self, action: "PushIllustButton:", forControlEvents: .TouchUpInside)
        EnterButton.setTitle("OK", forState: .Normal)
        EnterButton.tag = 5
        EnterButton.backgroundColor = UIColor.redColor()
        self.subWindow?.addSubview(EnterButton)
        canvas_View?.hidden = false

    }
    
    //Stamp Button Pushed
    func StampIcon(){
        let IconWidth = self.view.frame.width/6
        let marginWidth = self.view.frame.width/32
        subWindow?.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.0, alpha: 0.7)
        
        for i in 0..<4{
            let StampButton=UIButton(frame: CGRectMake(IconWidth*CGFloat(i)+marginWidth*CGFloat(i+1), 0, IconWidth, IconWidth))
            StampButton.tag = i+1
            StampButton.addTarget(self, action: "PushStampButton:", forControlEvents: .TouchUpInside)
            
            switch i{
            case 0:
                let IconImage = UIImage(named: "Img/Stamp1.png")
                StampButton.setBackgroundImage(IconImage, forState: .Normal)
            case 1:
                let IconImage = UIImage(named: "Img/Stamp2.png")
                StampButton.setBackgroundImage(IconImage, forState: .Normal)
            case 2:
                let IconImage = UIImage(named: "Img/Stamp3.png")
                StampButton.setBackgroundImage(IconImage, forState: .Normal)
            case 3:
                let IconImage = UIImage(named: "Img/Stamp4.png")
                StampButton.setBackgroundImage(IconImage, forState: .Normal)
                
            default:
                break
            }
            self.subWindow!.addSubview(StampButton)
        }
        
        let EnterButton=UIButton(frame: CGRectMake(self.view.frame.width-IconWidth, 0, IconWidth, IconWidth))
        EnterButton.addTarget(self, action: "PushStampButton:", forControlEvents: .TouchUpInside)
        EnterButton.setTitle("OK", forState: .Normal)
        EnterButton.tag = 5
        EnterButton.backgroundColor = UIColor.redColor()
        
        self.subWindow!.addSubview(EnterButton)
        
    }
    
    //Camera Button Pushed
    func CameraIcon(){
        let IconWidth = self.view.frame.width/5
        subWindow?.backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 0.8, alpha: 0.7)
        
        let SelectButton=UIButton(frame: CGRectMake(0, 0, IconWidth+IconWidth/5*2, IconWidth))
        SelectButton.layer.position = CGPoint(x: SelectWindow!.frame.width/2, y: SelectWindow!.frame.height/2)
        SelectButton.addTarget(self, action: "PushCameraButton:", forControlEvents: .TouchUpInside)
        
        let IconImage = UIImage(named: "Img/CameraIcon.png")
        SelectButton.setBackgroundImage(IconImage, forState: .Normal)
        
        subWindow!.addSubview(SelectButton)
    }

    //-------------------------------illust-------------------------------------
    
    //書くため,No.1
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.canvas_View == nil {
            return;
        }
        for touch: AnyObject in touches {
            touchedPoint = touch.locationInView(canvas_View)
            bezierPath = UIBezierPath()
            bezierPath.moveToPoint(touchedPoint)
            firstMovedFlag = true
        }
    }
    
    //書くため,No.2
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (bezierPath == nil){
            return;
        }
        for touch: AnyObject in touches {
            let currentPoint = touch.locationInView(canvas_View)
            if firstMovedFlag {
                firstMovedFlag = false
                touchedPoint = currentPoint
                return
            }
            let middlePoint = midPoint(touchedPoint, point1: currentPoint)
            bezierPath.addQuadCurveToPoint(middlePoint, controlPoint: touchedPoint)
            drawLinePreview(currentPoint)
            touchedPoint = currentPoint
        }
    }
    
    
    //書くため,No.3
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (bezierPath == nil){
            return;
        }
        for touch: AnyObject in touches {
            let currentPoint = touch.locationInView(canvas_View)
            bezierPath.addQuadCurveToPoint(currentPoint, controlPoint: touchedPoint)
            drawline()
            bezierPath = nil
        }
    }
    
    //書くため,No.4
    func drawLinePreview(endPoint:CGPoint){
        UIGraphicsBeginImageContextWithOptions(canvas_View!.bounds.size, false, 0.0)
        canvas_View!.image?.drawInRect(canvas_View!.bounds)
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), CGLineCap.Round)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), width)
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(),red,green,blue, 0.8)
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), touchedPoint.x, touchedPoint.y)
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), endPoint.x, endPoint.y)
        CGContextStrokePath(UIGraphicsGetCurrentContext())
        canvas_View?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    //書くため,No.5
    func drawline(){
        UIGraphicsBeginImageContextWithOptions(canvas_View!.bounds.size, false, 0.0)
        Cur_image.drawInRect(canvas_View!.bounds)
        bezierPath.lineWidth = width
        bezierPath.lineCapStyle = CGLineCap.Round
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(),red,green,blue, 0.8)
        bezierPath.stroke()
        Cur_image = UIGraphicsGetImageFromCurrentImageContext()
        canvas_View?.image = Cur_image
        
        UIGraphicsEndImageContext()
    }
    
    //書くため,No.6
    func midPoint(point0:CGPoint, point1:CGPoint) ->CGPoint{
        let x = point0.x + point1.x
        let y = point0.y + point1.y
        return CGPointMake(x/2.0, y/2.0)
    }
    
    //-------------------------------Segue-------------------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        SelectWindow?.hidden = true
        subWindow?.hidden = true
        if segue.identifier == "FromGraffitiToHome"{
            var VC : TopPage = segue.destinationViewController as! TopPage
        }
        else if segue.identifier == "ChangeToInfo"{
            let VC : InfoClass = segue.destinationViewController as! InfoClass
            VC.ManholeName = self.ManholeName
        }
    }

    
}

extension UIView {
    
    func GetImage() -> UIImage{
        
        // キャプチャする範囲を取得.
        let rect = self.bounds
        
        // ビットマップ画像のcontextを作成.
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        
        // 対象のview内の描画をcontextに複写する.
        self.layer.renderInContext(context)
        
        // 現在のcontextのビットマップをUIImageとして取得.
        let capturedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // contextを閉じる.
        UIGraphicsEndImageContext()
        
        return capturedImage
    }
}


