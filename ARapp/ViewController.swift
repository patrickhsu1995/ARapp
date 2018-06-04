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

class ViewController: UIViewController, ARSCNViewDelegate {
    var sceneLocationView = SceneLocationView()

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
//
//        // Set the view's delegate
//        sceneView.delegate = self
//
//        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
//
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
        let coordinate = CLLocationCoordinate2D(latitude: 43.642509, longitude: -79.387039)
        let location = CLLocation(coordinate: coordinate, altitude: 570)
        let image = UIImage(named: "pin")!
        
        let annotationNode = LocationAnnotationNode(location: location, image: image)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        addTapGestureToSceneView()
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
    func addBox() {
        let box = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
//
//        let boxNode = SCNNode()
//        boxNode.geometry = box
//        boxNode.position = SCNVector3(0, 0, -0.2)
//        boxNode.name = "box"
//
        let coordinate = CLLocationCoordinate2D(latitude: 43.6426, longitude: -79.3871)
        let location = CLLocation(coordinate: coordinate, altitude: 102)
        
        let annotationNode = LocationNode(location: location)
        annotationNode.geometry = box
        annotationNode.position = SCNVector3(0, 0, -0.2)
        annotationNode.name = "box"

        sceneView.scene.rootNode.addChildNode(annotationNode)
        print(annotationNode.location!)
    }
    
    func dropItem(){
        
    }
    
    func addTapGestureToSceneView(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer){
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        guard let node = hitTestResults.first?.node else {return}
        node.removeFromParentNode()
        if node.name == "box"{
            let scene = SCNScene(named: "art.scnassets/ship.scn")!
            sceneView.scene = scene
        } else {
            addBox()
        }
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
