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
        
        //adding tap gesture to the view
        addTapGestureToSceneView()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentAltitude = locations.last?.altitude
        currentCoordiantes = location
        print(currentCoordiantes)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        // Create a session configuration
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.planeDetection = .horizontal
//
//        // Run the view's session
//        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
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
        let objDropLocation = CLLocation(coordinate: currentCoordiantes, altitude: currentAltitude)
        let image = UIImage(named: "pin")!
        
        //create the object to be dropped
        let dropObject = LocationAnnotationNode(location: objDropLocation, image: image)
        
        print("attempting to add object to current location")
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: dropObject)
    }
    
    func addTapGestureToSceneView(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
        sceneLocationView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer){
//        let tapLocation = recognizer.location(in: sceneView)
//        let hitTestResults = sceneView.hitTest(tapLocation)
//        guard let node = hitTestResults.first?.node else {return}
//        node.removeFromParentNode()
        dropItem()

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
