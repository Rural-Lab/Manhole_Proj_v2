//
//  InfoClass.swift
//  Manhole_Proj
//
//  Created by Takuro Mori on 2015/08/27.
//  Copyright (c) 2015年 Takuro. All rights reserved.
//

import UIKit
import MapKit

class AlbumMapClass: UIViewController, MKMapViewDelegate {

    // MapView.
    var myMapView : MKMapView!
    @IBOutlet var HomeButton: UIButton?
    @IBOutlet var ChangeButton: UIButton?
    
    @IBOutlet var TitleLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MapViewの生成.
        myMapView = MKMapView()
        
        // MapViewのサイズを画面全体に.
        myMapView.frame = self.view.bounds
        
        // Delegateを設定.
        myMapView.delegate = self
        
        // MapViewをViewに追加.
        self.view.addSubview(myMapView)
        
        var myPin: MKPointAnnotation = MKPointAnnotation()
        myPin.coordinate = CLLocationCoordinate2DMake(35.1748, 135.0707)
        myPin.title = "京都府福知山市"
        myPin.subtitle = "2015/08/19"
        myMapView.addAnnotation(myPin)
        var myPin2: MKPointAnnotation = MKPointAnnotation()
        myPin2.coordinate = CLLocationCoordinate2DMake(35.2829, 135.2310)
        myPin2.title = "京都府舞鶴市"
        myPin2.subtitle = "2015/08/19"
        myMapView.addAnnotation(myPin2)
        var myPin3: MKPointAnnotation = MKPointAnnotation()
        myPin3.coordinate = CLLocationCoordinate2DMake(34.8846, 135.7000)
        myPin3.title = "京都府八幡市"
        myPin3.subtitle = "2015/08/19"
        myMapView.addAnnotation(myPin3)
        var myPin4: MKPointAnnotation = MKPointAnnotation()
        myPin4.coordinate = CLLocationCoordinate2DMake(35.5256, 139.3111)
        myPin4.title = "ふじみ野市"
        myPin4.subtitle = "2015/08/10"
        myMapView.addAnnotation(myPin4)
        var myPin5: MKPointAnnotation = MKPointAnnotation()
        myPin5.coordinate = CLLocationCoordinate2DMake(35.3721, 140.1119)
        myPin5.title = "千葉県千葉市"
        myPin5.subtitle = "2015/08/10"
        myMapView.addAnnotation(myPin5)
        var myPin6: MKPointAnnotation = MKPointAnnotation()
        myPin6.coordinate = CLLocationCoordinate2DMake(35.1825, 139.1841)
        myPin6.title = "神奈川県大磯町"
        myPin6.subtitle = "2015/08/10"
        myMapView.addAnnotation(myPin6)
        var myPin7: MKPointAnnotation = MKPointAnnotation()
        myPin7.coordinate = CLLocationCoordinate2DMake(35.13, 135.14)
        myPin7.title = "京都府福知山市（三和町）"
        myPin7.subtitle = "2015/08/19"
        myMapView.addAnnotation(myPin7)
        var myPin8: MKPointAnnotation = MKPointAnnotation()
        myPin8.coordinate = CLLocationCoordinate2DMake(34.7027, 135.4995)
        myPin8.title = "大阪府大阪市"
        myPin8.subtitle = "2015/09/07"
        myMapView.addAnnotation(myPin8)
        var myPin9: MKPointAnnotation = MKPointAnnotation()
        myPin9.coordinate = CLLocationCoordinate2DMake(35.0113, 135.5647)
        myPin9.title = "滋賀県草津本陣"
        myPin9.subtitle = "2015/09/07"
        myMapView.addAnnotation(myPin9)
        var myPin10: MKPointAnnotation = MKPointAnnotation()
        myPin10.coordinate = CLLocationCoordinate2DMake(35.13, 135.14)
        myPin10.title = "大阪府大阪市(一般)"
        myPin10.subtitle = "2015/09/07"
        myMapView.addAnnotation(myPin10)

        
        // 中心点の緯度経度.
        let myLat: CLLocationDegrees = 38.2586
        let myLon: CLLocationDegrees = 137.6850
        let myCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(myLat, myLon)
        
        // 縮尺.
        let myLatDist : CLLocationDistance = 1500000
        let myLonDist : CLLocationDistance = 1500000
        
        // Regionを作成.
        let myRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(myCoordinate, myLatDist, myLonDist);
        
        // MapViewに反映.
        myMapView.setRegion(myRegion, animated: true)
        
        TitleLabel?.text = "\nMap"
        TitleLabel?.numberOfLines = 2
        self.view.addSubview(TitleLabel!)
        ChangeButton?.addTarget(self, action: "ClickButton:", forControlEvents: .TouchUpInside)
        ChangeButton?.setImage(UIImage(named: "Img/albumlist.png"), forState: .Normal)
        ChangeButton?.tag = 2
        HomeButton?.addTarget(self, action: "ClickButton:", forControlEvents: .TouchUpInside)
        HomeButton?.setImage(UIImage(named: "Img/home.png"), forState: .Normal)
        HomeButton?.tag = 3
        self.view.addSubview(HomeButton!)
        self.view.addSubview(ChangeButton!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        println("regionDidChangeAnimated")
    }
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation === mapView.userLocation { // 現在地を示すアノテーションの場合はデフォルトのまま
            return nil
        } else {
            let identifier = "annotation"
            if let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("annotation") { // 再利用できる場合はそのまま返す
                return annotationView
            } else { // 再利用できるアノテーションが無い場合（初回など）は生成する
                
                let annotationView:MKAnnotationView
                let manhole:UIImage
                if(annotation.title == "京都府福知山市"){
                    annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    manhole = UIImage(named: "Img/SaveManhole1.png")!
                }else if(annotation.title == "京都府福知山市（三和町）"){
                    annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    manhole = UIImage(named: "Img/SaveManhole3.png")!
                }else if(annotation.title == "京都府舞鶴市"){
                    annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    manhole = UIImage(named: "Img/SaveManhole2.png")!
                }else if(annotation.title == "京都府八幡市"){
                    annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    manhole = UIImage(named: "Img/SaveManhole4.png")!
                }else if(annotation.title == "神奈川県大磯町"){
                    annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    manhole = UIImage(named: "Img/SaveManhole5.png")!
                }else if(annotation.title == "千葉県千葉市"){
                    annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    manhole = UIImage(named: "Img/SaveManhole6.png")!
                }else if(annotation.title == "埼玉県ふじみ野市"){
                    annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    manhole = UIImage(named: "Img/SaveManhole7.png")!
                }else if(annotation.title == "大阪府大阪市"){
                    annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    manhole = UIImage(named: "Img/SaveManhole8.png")!
                }else if(annotation.title == "滋賀県草津本陣"){
                    annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    manhole = UIImage(named: "Img/SaveManhole9.png")!
                }else if(annotation.title == "大阪府大阪市(一般)"){
                    annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    manhole = UIImage(named: "Img/SaveManhole10.png")!
                }else{
                    annotationView = MKAnnotationView()
                    manhole = UIImage()
                }
                
                let size = CGSize(width: 30, height: 30)
                
                UIGraphicsBeginImageContext(size)
                manhole.drawInRect(CGRectMake(0, 0, size.width, size.height))
                var resizeImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                annotationView.image = resizeImage // ここで好きな画像を設定します
                
                return annotationView
                
            }
        }
    }
    
    func ClickButton(sender:UIButton){
        if sender.tag == 2{
            self.performSegueWithIdentifier("ChangeToMap", sender: self)
        }else if sender.tag == 3{
            self.performSegueWithIdentifier("FromMapToHome", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FromMapToHome"{
            var VC : TopPage = segue.destinationViewController as! TopPage
        }
        else if segue.identifier == "ChangeToMap"{
            var VC : AlbumListClass = segue.destinationViewController as! AlbumListClass
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
//        removeAllSubviews(self.view)
        myMapView = nil
        HomeButton = nil
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


