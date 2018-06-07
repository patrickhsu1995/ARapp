//
//  ViewController.swift
//  ARapp
//
//  Created by Patrick Hsuan Hsu on 2018-05-29.
//  Copyright © 2018 Patrick Hsuan Hsu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import GoogleMaps
import ARCL
import CoreLocation
import Firebase


class ViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {
    var sceneLocationView = SceneLocationView()

    @IBOutlet var sceneView: ARSCNView!
    
    let RADIUS: Double = 50.0
    var ref: DatabaseReference!
    var handle: DatabaseHandle?
    
    var locationManager = CLLocationManager()
    var currentCoordiantes: CLLocationCoordinate2D!
    var currentAltitude: CLLocationDistance!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        
        //initialize location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        //render oobjects
        renderObjects()
        
        //adding tap gesture to the view
        addTapGestureToSceneView()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.currentAltitude = locations.last?.altitude
        self.currentCoordiantes = location
        print(currentCoordiantes)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderObjects(){
        self.ref = Database.database().reference()
        let itemsRef = self.ref.child("items")
        handle = itemsRef.observe(.value, with: {(snapshot) in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot{
                //access this object as a dictionary
                let obj = rest.value! as! NSDictionary
                
                let lat: Double = obj["lattitude"]! as! Double
                let long: Double = obj["longitude"]! as! Double
                let alt: Double = obj["altitude"]! as! Double
                
                //create a temporary coordinate object
                let tempCoord: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                if self.withinRadius(self.RADIUS, tempCoord!) {
                    let objDisplayLocation = CLLocation(coordinate: tempCoord!, altitude: alt)
                    let image = UIImage(named: "pin")!
                    
                    //create the object to be dropped
                    let displayObject = LocationAnnotationNode(location: objDisplayLocation, image: image)
                    self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: displayObject)
                }
            }
        })
    }

    //add a box to scene
    func addBox() -> SCNNode {
        let box = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)

        let boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.position = SCNVector3(0, 0, -0.2)
        boxNode.name = "box"
        
        return boxNode
    }
    
    //create and drop a pin (tentative) at the user's height
    func dropItem(){
        let objDropLocation = CLLocation(coordinate: self.currentCoordiantes, altitude: self.currentAltitude)
        let image = UIImage(named: "pin")!
        
        //create the object to be dropped
        let dropObject = LocationAnnotationNode(location: objDropLocation, image: image)
        
        //put dropped item into database
        addDropToDataBase()
        
        print("attempting to add object to current location")
        
        //add to view
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: dropObject)
    }
    
    func addDropToDataBase(){
        //generate random object ID
        let uuid = UUID().uuidString
        
        self.ref = Database.database().reference()
        let itemsReference = self.ref.child("items")
        
        //get current logged in userid
        let uid = Auth.auth().currentUser?.uid
        
        let newItemReference = itemsReference.child(uuid)
        newItemReference.setValue(["lattitude": self.currentCoordiantes.latitude, "longitude": self.currentCoordiantes.longitude, "altitude": self.currentAltitude, "user":uid!])
        
        //add to the user who dropped it
        //TODO
        
    }
    
    func withinRadius(_ radius: Double, _ tempCoord: CLLocationCoordinate2D) -> Bool{
        //TODO
        let loc1 = CLLocation(latitude: currentCoordiantes.latitude, longitude: currentCoordiantes.longitude)
        let loc2 = CLLocation(latitude: tempCoord.latitude, longitude: tempCoord.longitude)
        return (loc1.distance(from: loc2) <= radius)
    }
    
    
    func addTapGestureToSceneView(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
        sceneLocationView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer){
        promptUser()
        dropItem()
    }
    
    func promptUser(){
        
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

