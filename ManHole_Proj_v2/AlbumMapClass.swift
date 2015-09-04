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

        
        ChangeButton?.addTarget(self, action: "ClickButton:", forControlEvents: .TouchUpInside)
        ChangeButton?.tag = 2
        HomeButton?.addTarget(self, action: "ClickButton:", forControlEvents: .TouchUpInside)
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
        removeAllSubviews(self.view)
        myMapView = nil
        HomeButton = nil
        ChangeButton = nil
    }
    
    func removeAllSubviews(parentView: UIView){
        var subviews = parentView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}


