//
//  ViewController.swift
//  Swift-Motion
//
//  Created by gyoza manner on July 20, 2014
//  Copyright (c) 2014 gyoza manner. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation
import CoreLocation

public class TopPage: Recog, CLLocationManagerDelegate {
    
    //トップページのくり抜きレイヤーの準備
    var hollowRadius = 130.0 as CGFloat
    lazy var hollowPoint: CGPoint = {
        return CGPoint(
            x: CGRectGetWidth(self.view.bounds) / 2.0,
            y: CGRectGetHeight(self.view.bounds) / 2.0
        )
        }()
    
    //マンホールの画像撮影時に位置情報を取得する用
    var myLocationManager:CLLocationManager!
        var myLatitudeLabel:UILabel!
        var myLongitudeLabel:UILabel!
    
    //アルバムボタン
    @IBOutlet var AlbumButton:UIButton?
    
    @IBOutlet weak var TopTitle: UILabel!
    @IBOutlet weak var LogoImage: UIImageView!
    
    //@IBOutlet weak var LogoImage: UIImageView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        
        RecogInit()
        // トップページのレイアウトを作成.(ここから)
        var effect = UIBlurEffect(style: UIBlurEffectStyle.Light);
        
        var hollowTargetView = UIView()
        hollowTargetView = UIVisualEffectView(effect: effect);
        hollowTargetView.bounds = self.view.bounds
        hollowTargetView.layer.position = CGPoint(
            x: CGRectGetWidth(self.view.bounds) / 2.0,
            y: CGRectGetHeight(self.view.bounds) / 2.0
        )
        //        hollowTargetView.backgroundColor = UIColor.whiteColor()
        //        hollowTargetView.layer.opacity = 0.5
        //        var hollowTargetLayer = CALayer()
        //        hollowTargetLayer.bounds = self.view.bounds
        //        hollowTargetLayer.position = CGPoint(
        //            x: CGRectGetWidth(self.view.bounds) / 2.0,
        //            y: CGRectGetHeight(self.view.bounds) / 2.0
        //        )
        //        hollowTargetLayer.backgroundColor = UIColor.blackColor().CGColor
        
        //        println(hollowTargetView) デバッグ用
        
        // くり抜くための四角いマスクレイヤーを作る
        let maskLayer = CAShapeLayer()
        maskLayer.bounds = self.view.bounds
        
        // 塗りを反転させるために、pathに四角いマスクレイヤーを重ねる
        let ovalRect =  CGRect(
            x: self.hollowPoint.x - self.hollowRadius,
            y: self.hollowPoint.y - self.hollowRadius,
            width: self.hollowRadius * 2.0,
            height: self.hollowRadius * 2.0
        )
        let path =  UIBezierPath(ovalInRect: ovalRect)
        path.appendPath(UIBezierPath(rect: maskLayer.bounds))
        
        maskLayer.path = path.CGPath
        maskLayer.position = CGPoint(
            x: CGRectGetWidth(hollowTargetView.bounds) / 2.0,
            y: CGRectGetHeight(hollowTargetView.bounds) / 2.0
        )
        // マスクのルールをeven/oddに設定する
        maskLayer.fillRule = kCAFillRuleEvenOdd
        hollowTargetView.layer.mask = maskLayer
        
        // サブレイヤーとしてadd
        self.view.addSubview(hollowTargetView)
        
        // トップページのレイアウトを作成.(ここまで)
        
        AlbumButton = UIButton(frame: CGRectMake(0,0,60,60))
        let albumimage = UIImage(named: "Img/album.png")
        AlbumButton!.setBackgroundImage(albumimage, forState: .Normal)
//        AlbumButton!.backgroundColor = UIColor.darkGrayColor();
        AlbumButton!.layer.masksToBounds = true
//        AlbumButton!.setTitle("アルバム", forState: .Normal)
//        AlbumButton!.layer.cornerRadius = 20.0
        AlbumButton!.layer.position = CGPoint(x: self.view.bounds.width/8*7, y:self.view.bounds.height-50)
        AlbumButton!.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        AlbumButton!.tag = 1
        
        self.view.addSubview(AlbumButton!)
        // 撮影ボタンとアルバムボタンの作成（ここまで）
        TopTitle.text = ""
        //self.view.addSubview(TopTitle!)
        
        LogoImage.image = UIImage(named: "Img/rurallid.png")
        self.view.addSubview(LogoImage!)
        
//        LogoImage.image = UIImage(named: "Img/rurallid.png")
//        self.view.addSubview(LogoImage)
        
        
        //位置情報の取得（ここから）
        // 緯度表示用のラベルを生成.
        //        myLatitudeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30))
        //        myLatitudeLabel.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height/2+100)
        //
        //        // 軽度表示用のラベルを生成.
        //        myLongitudeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30))
        //        myLongitudeLabel.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height/2+130)
        
        
        // 現在地の取得.
        myLocationManager = CLLocationManager()
        
        myLocationManager.delegate = self
        
        // セキュリティ認証のステータスを取得.
        let status = CLLocationManager.authorizationStatus()
        
        // まだ認証が得られていない場合は、認証ダイアログを表示.
        if(status == CLAuthorizationStatus.NotDetermined) {
            println("didChangeAuthorizationStatus:\(status)");
            // まだ承認が得られていない場合は、認証ダイアログを表示.
            self.myLocationManager.requestAlwaysAuthorization()
        }
        
        // 取得精度の設定.
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 取得頻度の設定.
        myLocationManager.distanceFilter = 100
        
        //位置情報の取得（ここまで）
        
    }
    
    
    
    // ボタンイベント.
    func onClickMyButton(sender: UIButton){
        // 現在位置の取得を開始.
//        myLocationManager.startUpdatingLocation()
        if (sender.tag == 1){
            self.performSegueWithIdentifier("TopToAlbum", sender: self)
        }
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func GotoInfo(){
        self.performSegueWithIdentifier("Info", sender: self)
    }
    
    override public func prepareForSegue(segue:UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TopToAlbum"{
            var VC : AlbumMapClass = segue.destinationViewController as! AlbumMapClass
        }
        else if segue.identifier == "Info"{
            var VC : InfoClass = segue.destinationViewController as! InfoClass
            VC.ManholeName = message
        }
        
    }
    
    public func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        println("didChangeAuthorizationStatus");
        
        // 認証のステータスをログで表示.
        var statusStr = "";
        switch (status) {
        case .NotDetermined:
            statusStr = "NotDetermined"
        case .Restricted:
            statusStr = "Restricted"
        case .Denied:
            statusStr = "Denied"
        case .AuthorizedAlways:
            statusStr = "AuthorizedAlways"
        case .AuthorizedWhenInUse:
            statusStr = "AuthorizedWhenInUse"
        }
        println(" CLAuthorizationStatus: \(statusStr)")
    }
    
    
    // 位置情報取得に成功したときに呼び出されるデリゲート.
    public func locationManager(manager: CLLocationManager!,didUpdateLocations locations: [AnyObject]!){
        
        // 緯度・経度の表示.
        //        myLatitudeLabel.text = "緯度：\(manager.location.coordinate.latitude)"
        //        myLatitudeLabel.textAlignment = NSTextAlignment.Center
        //
        //        myLongitudeLabel.text = "経度：\(manager.location.coordinate.longitude)"
        //        myLongitudeLabel.textAlignment = NSTextAlignment.Center
        //
        //
        //        self.view.addSubview(myLatitudeLabel)
        //        self.view.addSubview(myLongitudeLabel)
        println(manager.location.coordinate.latitude)
        println(manager.location.coordinate.longitude)
        
    }
    
    // 位置情報取得に失敗した時に呼び出されるデリゲート.
    public func locationManager(manager: CLLocationManager!,didFailWithError error: NSError!){
        print("error")
    }
    
    override public func viewDidDisappear(animated: Bool) {
        println("disappear")
        myLocationManager = nil
        AlbumButton = nil
//        removeAllSubviews(self.view)
        self.view.removeFromSuperview()
    }
    
    func removeAllSubviews(parentView: UIView){
        var subviews = parentView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
    }
    
}