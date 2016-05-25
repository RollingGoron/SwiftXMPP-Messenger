//
//  ChatController.swift
//  SwiftXMPPMessenger
//
//  Created by Peter Gosling on 5/19/16.
//  Copyright © 2016 SunfireSoft. All rights reserved.
//

import UIKit
import XMPPFramework

class ChatController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatTextField: UITextField!
    
    var userModel : UserModel? {
        didSet {
            print("Did Set!")
            if userModel?.chatHistory.count == 0 {
                return
            } else {
                self.tableView.reloadData()
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.registerNib(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        XMPPManager.sharedInstance.xmppManagerStreamDelegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendMessageAction(sender: AnyObject) {
        
        print("Sending Chat!")
        
        let messageString = chatTextField.text
        
        if messageString?.characters.count > 0
        {
            let body = DDXMLElement(name: "body", stringValue: messageString)
            
            let message = DDXMLElement(name: "message")
            message.addAttributeWithName("type", stringValue: "chat")
            message.addAttributeWithName("to", stringValue: userModel?.jid)
            message.addChild(body)
            XMPPManager.sharedInstance.xmppStream?.sendElement(message)
        }
    }
}

extension ChatController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userModel?.chatHistory.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let messageModel = userModel?.chatHistory[indexPath.row]
        
        let messageCell = tableView.dequeueReusableCellWithIdentifier("MessageCell") as! MessageCell
        
        messageCell.from.text = messageModel?.messageSender
        messageCell.message.text = messageModel?.messageBody
        
        return messageCell
    }
}

extension ChatController : XMPPManagerStreamDelegate {

    func didRecieveMessage(message : MessageModel) {
        userModel?.chatHistory.append(message)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    func didRecievePresenceFor(user : UserModel) {
        
    }
    
}