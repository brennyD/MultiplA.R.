//
//  HostView.swift
//  ARt
//
//  Created by Brendan DeMilt on 4/6/18.
//  Copyright © 2018 Multiplaugmented Mentalities. All rights reserved.
//

import Foundation
import UIKit


class HostView: UIViewController{
    
    
    @IBOutlet weak var ClientTable: UITableView!

    var sessionName: String!
    
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "unwindToMenu", sender: self)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let sessionInput = UIAlertController(title: "Input session name", message: nil, preferredStyle: .alert)
        
        sessionInput.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sessionInput.addTextField(configurationHandler: {textField in textField.placeholder = ""})
        sessionInput.addAction(UIAlertAction(title: "Enter", style: .default, handler: {action in
            
            if sessionInput.textFields?.first?.text != "" {
                self.sessionName = sessionInput.textFields?.first?.text
            } else {
                self.present(sessionInput, animated: true)
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
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
 
    
    
    
    
}