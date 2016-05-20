//
//  XMPPManager.swift
//  SwiftXMPPMessenger
//
//  Created by Peter Gosling on 5/18/16.
//  Copyright © 2016 SunfireSoft. All rights reserved.
//

import UIKit
import XMPPFramework

class XMPPManager: NSObject {
    
    static let sharedInstance = XMPPManager()

    var xmppStream : XMPPStream?
    
    var userWithHost : String = ""
    var password : String = ""
    
    func setXMPPDelegates() {
        xmppStream = XMPPStream()
        xmppStream?.addDelegate(self, delegateQueue: dispatch_get_main_queue())
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
    }
    
    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
        print("Recieved Message!")
        print(message)
    }

}
