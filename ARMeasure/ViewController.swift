//
//  ViewController.swift
//  ARMeasure
//
//  Created by Ashutosh Burde on 10/1/19.
//  Copyright © 2019 Ashutosh Burde. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var dots = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.location(in: sceneView)
            
            let hitTestResult = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult = hitTestResult.first{
                addDot(at: hitResult)
            }
        }
    }
    
    func addDot(at hitResult: ARHitTestResult){
        let sphere = SCNSphere(radius: 0.005)
        
        let material = SCNMaterial()
        
        material.diffuse.contents = UIColor.red
        
        sphere.materials = [material]
        
        let node = SCNNode()
        
        node.position = SCNVector3(x: hitResult.worldTransform.columns.3.x, y: hitResult.worldTransform.columns.3.y, z: hitResult.worldTransform.columns.3.z)
        
        node.geometry = sphere
        
        sceneView.scene.rootNode.addChildNode(node)
        
        dots.append(node)
        
        if dots.count >= 2 {
            calculate()
        }
    }
    
    func calculate (){
        let start = dots[0]
        let end = dots[1]
        
        
        let a = end.position.x - start.position.x
        
        let b = end.position.y - start.position.y
        
        let c = end.position.z - start.position.z
        
        let distance = sqrt(pow(a, 2) + pow(b, 2) + pow(c, 2))
        
        print(distance)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
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
