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

    
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var ref: DatabaseReference!
    var handle: DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        renderMarkers()
    }
    
    func renderMarkers(){
        self.ref = Database.database().reference()
        let itemsRef = self.ref.child("items")
        handle = itemsRef.observe(.value, with: {(snapshot) in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot{
                //access this object as a dictionary
                let obj = rest.value! as! NSDictionary
                
                //create lat and long variables
                let lat: Double = obj["lattitude"]! as! Double
                let long: Double = obj["longitude"]! as! Double
                
                //create marker
                let title = obj["user"]! as? String
                self.addMarker(lat, long, title!)
            }
        })
    }
    
    func addMarker(_ lat: CLLocationDegrees, _ long: CLLocationDegrees, _ title: String){
        let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let marker = GMSMarker(position: position)
        marker.title = title
        marker.map = self.mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:14)
        mapView.animate(to: camera)
        
        self.locationManager.stopUpdatingLocation()
    }
    

}
