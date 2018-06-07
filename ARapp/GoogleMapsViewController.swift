//
//  GoogleMapsViewController.swift
//  ARapp
//
//  Created by Patrick Hsuan Hsu on 2018-05-31.
//  Copyright © 2018 Patrick Hsuan Hsu. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase

class GoogleMapsViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        renderObjects()
    }
    
    func renderObjects(){
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:14)
        mapView.animate(to: camera)
        
        self.locationManager.stopUpdatingLocation()
    }
    

}
