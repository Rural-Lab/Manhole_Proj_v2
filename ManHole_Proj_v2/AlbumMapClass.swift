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
        myPin.title = "福知山"
        myPin.subtitle = "2015/08/19"
        myMapView.addAnnotation(myPin)
        var myPin2: MKPointAnnotation = MKPointAnnotation()
        myPin2.coordinate = CLLocationCoordinate2DMake(34.8939, 135.8059)
        myPin2.title = "宇治"
        myPin2.subtitle = "2015/08/19"
        myMapView.addAnnotation(myPin2)
        var myPin3: MKPointAnnotation = MKPointAnnotation()
        myPin3.coordinate = CLLocationCoordinate2DMake(34.8846, 135.7000)
        myPin3.title = "八幡"
        myPin3.subtitle = "2015/08/19"
        myMapView.addAnnotation(myPin3)
        var myPin4: MKPointAnnotation = MKPointAnnotation()
        myPin4.coordinate = CLLocationCoordinate2DMake(35.5256, 139.3111)
        myPin4.title = "ふじみ野市"
        myPin4.subtitle = "2015/08/10"
        myMapView.addAnnotation(myPin4)
        var myPin5: MKPointAnnotation = MKPointAnnotation()
        myPin5.coordinate = CLLocationCoordinate2DMake(35.3721, 140.1119)
        myPin5.title = "千葉市"
        myPin5.subtitle = "2015/08/10"
        myMapView.addAnnotation(myPin5)
        var myPin6: MKPointAnnotation = MKPointAnnotation()
        myPin6.coordinate = CLLocationCoordinate2DMake(35.1825, 139.1841)
        myPin6.title = "大磯町"
        myPin6.subtitle = "2015/08/10"
        myMapView.addAnnotation(myPin6)
        
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

        self.view.addSubview(TitleLabel!)
        ChangeButton?.addTarget(self, action: "ClickButton:", forControlEvents: .TouchUpInside)
        ChangeButton?.tag = 2
        HomeButton?.frame = CGRectMake(10, 2, 35, 35)
        HomeButton?.addTarget(self, action: "ClickButton:", forControlEvents: .TouchUpInside)
        HomeButton?.setImage(UIImage(named: "Img/HomeIcon.png"), forState: .Normal)
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


