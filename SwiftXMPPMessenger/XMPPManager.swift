//
//  XMPPManager.swift
//  SwiftXMPPMessenger
//
//  Created by Peter Gosling on 5/18/16.
//  Copyright © 2016 SunfireSoft. All rights reserved.
//

import UIKit
import XMPPFramework

protocol XMPPManagerStreamDelegate {
    func didConnectToServer(bool : Bool, errorMessage : String?)
    func failedToAuthenticate(error : String)
    func didRecieveMessage(message : MessageModel)
    func didRecievePresenceFor(user : UserModel)
}

protocol XMPPManagerRosterProtocol {
    func didRecieveBuddy(user : UserModel)
}

class XMPPManager: NSObject {
    
    static let sharedInstance = XMPPManager()

    var xmppStream : XMPPStream?
    var xmppRoster : XMPPRoster?
    var xmppRosterManager : XMPPRosterMemoryStorage?
    
    var xmppManagerStreamDelegate : XMPPManagerStreamDelegate?
    
    var userWithHost : String = ""
    var password : String = ""
    
    func setXMPPDelegates() {
        xmppStream = XMPPStream()
        xmppStream?.addDelegate(self, delegateQueue: dispatch_get_main_queue())
        xmppRosterManager = XMPPRosterMemoryStorage()
        xmppRoster = XMPPRoster(rosterStorage: xmppRosterManager, dispatchQueue: dispatch_get_main_queue())
        xmppRoster?.addDelegate(self, delegateQueue: dispatch_get_main_queue())
        xmppRoster?.activate(xmppStream)
    }
    
    func loginToXMPPServer(jid : String, password : String) {
        self.userWithHost = jid
        self.password = password
        
        xmppStream?.myJID = XMPPJID.jidWithString(self.userWithHost)
        
        do {
           try xmppStream?.connectWithTimeout(10.0)
        } catch {
            print("Whoops! And Error occured! When attempting to connect")
        }
    }

}

extension XMPPManager : XMPPStreamDelegate {
    
    func xmppStreamWillConnect(sender: XMPPStream!) {
        print("Will Connect soon")
    }
    
    func xmppStreamDidStartNegotiation(sender: XMPPStream!) {
        print("Negotiating with server")
    }
    
    func xmppStreamDidConnect(sender: XMPPStream!) {
        print("Stream did connect!")
        do {
            try xmppStream?.authenticateWithPassword(self.password)
        } catch {
            print("An error occured!")
        }
    }
    
    func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        print("The XMPP Authenticated")
        let presence = XMPPPresence(type: "Available")
        xmppStream?.sendElement(presence)
        xmppRoster?.fetchRoster()
        xmppManagerStreamDelegate?.didConnectToServer(true, errorMessage: nil)
    }
    
    func xmppStream(sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!) {
        xmppManagerStreamDelegate?.didConnectToServer(false, errorMessage: "Could not authenticate the account")
    }
    
    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
        
        
        
        print("Recieved Message!")
        print(message)
    }
}

extension XMPPManager : XMPPRosterDelegate {
    func xmppRoster(sender: XMPPRoster!, didReceiveRosterItem item: DDXMLElement!) {
        print("Recieved Roster Item \(item)")
    }
    
    func xmppRoster(sender: XMPPRoster!, didReceivePresenceSubscriptionRequest presence: XMPPPresence!) {
        print("Recieved Subscription!")
    }
}
