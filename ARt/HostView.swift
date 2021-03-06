//
//  HostView.swift
//  ARt
//
//  Created by Brendan DeMilt on 4/6/18.
//  Copyright © 2018 Multiplaugmented Mentalities. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity
import SceneKit



class HostView: UIViewController{
    
    
  
    @IBOutlet var label: UILabel!
    
    @IBOutlet var beginButton: UIButton!
    
    var sessionName: String!
    var hostSession: SessionManager!
    
    
    @IBAction func sessionStart(_ sender: UIButton) {
        self.hostSession.sendStateChange()
        self.performSegue(withIdentifier: "hostMoveToAR", sender: self)
        
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        
        self.performSegue(withIdentifier: "unwindToMenu", sender: self)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let sessionInput = UIAlertController(title: "Input host name", message: nil, preferredStyle: .alert)
        
        sessionInput.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in self.performSegue(withIdentifier: "unwindToMenu", sender: self) }))
        sessionInput.addTextField(configurationHandler: {textField in textField.placeholder = ""})
        sessionInput.addAction(UIAlertAction(title: "Enter", style: .default, handler: {action in
            
            if sessionInput.textFields?.first?.text != "" {
                self.sessionName = sessionInput.textFields?.first?.text
                self.hostSession = SessionManager(sessionTitle: self.sessionName)
                self.hostSession.delegate = self
            }
    
        }))
        
        
        self.present(sessionInput, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.destination is HostARViewController {
            let hs = segue.destination as? HostARViewController
            hs?.hostSession = self.hostSession
        }
    }
    
    
    
    
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */

    
    
  
}

extension HostView: SessionViewDelegate{
    func receivePos(manager: SessionManager, newPos: SCNVector3) {
        return
    }
    
    func setOrigin(maanager: SessionManager) {
            return
    }
    
    
    func paintDump(manager: SessionManager, newPos: SCNVector3) {
        return
    }
    
    
    
    func labelUpdated(manager: SessionManager, messageString: String) {
        
        
        OperationQueue.main.addOperation {
            self.label.text = messageString
        }
        
        
         NSLog("%@", "Data received: \(messageString)")
        
        
    }
    
    func connectedDevicesChanged(manager: SessionManager, connectedDevices: [String]) {
        print("Connection: \(connectedDevices)")
        OperationQueue.main.addOperation {
            self.label.text = "Connected to \(connectedDevices.first ?? "user...")"
            self.beginButton.isHidden = false
        }
        
    }
    
    
    
    
    
    
    
}





