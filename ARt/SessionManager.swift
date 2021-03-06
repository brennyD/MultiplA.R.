//
//  SessionManager.swift
//  ARt
//
//  Created by Brendan DeMilt on 4/6/18.
//  Copyright © 2018 Multiplaugmented Mentalities. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import UIKit
import SceneKit


protocol SessionViewDelegate {
    
    func connectedDevicesChanged(manager : SessionManager, connectedDevices: [String])
   // func colorChanged(manager : SessionManager, colorString: String)
    
     func receivePos(manager: SessionManager, newPos: SCNVector3)
    
    func labelUpdated(manager: SessionManager, messageString: String)
    
    func setOrigin(manager: SessionManager)
    
    func paintDump(manager: SessionManager, newPos: SCNVector3)
    
    
}



class SessionManager: NSObject{
    
    private let sessionID = "art-session"
    private let hostID: MCPeerID
    private let advertiser: MCNearbyServiceAdvertiser
    private var otherPaint: Bool!
    
    lazy var session : MCSession = {
        let session = MCSession(peer: self.hostID, securityIdentity: nil, encryptionPreference: .optional)
        session.delegate = self
        return session
    }()

    var delegate: SessionViewDelegate?
    
    
     init(sessionTitle: String){
        self.hostID = MCPeerID(displayName: sessionTitle)
        self.advertiser = MCNearbyServiceAdvertiser(peer: self.hostID, discoveryInfo: nil, serviceType: sessionID)
        
        self.otherPaint = false
        
        super.init()

        self.advertiser.delegate = self
        
        self.advertiser.startAdvertisingPeer()
        
        
    }
    
    
    deinit {
        self.advertiser.stopAdvertisingPeer()
    }
    
    
    
    func sendCoordinate(position: SCNVector3){
        print("Sending Coordinate \(position)")
        if session.connectedPeers.count > 0 {
            do {
                
                let packet = NSKeyedArchiver.archivedData(withRootObject: position)
                
                /*var temp = "\(coor)"
                temp.remove(at: String.Index)
                print(temp)*/
                
                try self.session.send( packet, toPeers: session.connectedPeers, with: .reliable)
            }
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
        }
    }
    
    func togglePaint(state: Bool){
        print("Sending Paint toggle")
        
        let message: String!
        
        if state{
            message = "true"
        }
        else{
            message = "false"
        }
        
        
        do {
            try self.session.send(message.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
        }
        catch let error {
            NSLog("%@", "Error for sending: \(error)")
        }
    }
    
    
    
    func sendStateChange(){
        print("Sending State change request")
        if session.connectedPeers.count > 0 {
            do {
                try self.session.send("SET TO AR SESSION".data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
            }
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
        }
    }
    
    
    
    func showPeers() -> [MCPeerID] {
        return self.session.connectedPeers
    }
    
    
    
    

}

extension SessionManager : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        
        
        invitationHandler(true, self.session)
        self.advertiser.stopAdvertisingPeer()

    }

    
    
}

extension SessionManager : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state)")
        
        self.delegate?.connectedDevicesChanged(manager: self, connectedDevices:
        session.connectedPeers.map{$0.displayName})
        print(session.connectedPeers)
        
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void){
        certificateHandler(true)
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        
        
        if let dict = NSKeyedUnarchiver.unarchiveObject(with: data) as! SCNVector3?{
            if otherPaint{
                self.delegate?.paintDump(manager: self, newPos: dict)
            }
            
            else{
               self.delegate?.receivePos(manager: self, newPos: dict)
            }
            
        }
        else if let rMessage = String(data: data, encoding: .utf8) as String?{
            print("DATA RECEIVED \(rMessage)")
            
            
            
            if rMessage == "false"{
                 self.otherPaint = false
                print("Paint toggled to false")
            }
            if rMessage == "true"{
                self.otherPaint = true
                print("Paint toggled to false")
            }
            
            
            if rMessage == "SET"{
                self.delegate?.setOrigin(manager: self)
                self.delegate?.labelUpdated(manager: self, messageString: rMessage)
            }
          
        }
            
            
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
    
}



