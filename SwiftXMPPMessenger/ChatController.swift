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
    
    var toolBarInitialValue : CGFloat?
    var messages = [MessageModel]()
    
    var userModel : UserModel? {
        didSet {
            if userModel?.chatHistory.count == 0 {
                return
            } else {
                if let unwrappedMessages = userModel?.chatHistory {
                    messages = unwrappedMessages
                }
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.automaticallyAdjustsScrollViewInsets = true;

        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.registerNib(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        self.tableView.registerNib(UINib(nibName: "ReceivedCell", bundle: nil), forCellReuseIdentifier: "ReceivedCell")
        XMPPManager.sharedInstance.xmppManagerStreamDelegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.toolBarInitialValue = toolbarBottomConstraint.constant
        self.registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        userModel?.chatHistory = messages
    }
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification : NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame : CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animateWithDuration(duration) {
            self.toolbarBottomConstraint.constant = keyboardFrame.size.height
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification : NSNotification) {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animateWithDuration(duration) {
            self.toolbarBottomConstraint.constant = self.toolBarInitialValue!
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func sendMessageAction(sender: AnyObject) {
        
        let messageString = chatTextField.text
        
        if messageString?.characters.count > 0
        {
            let body = DDXMLElement(name: "body", stringValue: messageString)
            
            let messageElement = DDXMLElement(name: "message")
            messageElement.addAttributeWithName("type", stringValue: "chat")
            messageElement.addAttributeWithName("to", stringValue: userModel?.jid)
            messageElement.addChild(body)
            XMPPManager.sharedInstance.xmppStream?.sendElement(messageElement)
            chatTextField.text = ""
            
            let message = MessageModel(body: messageString, sender: "Me", timestamp: "\(NSDate().timeIntervalSince1970)")
            messages.append(message)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: (self.messages.count - 1), inSection: 0), atScrollPosition: .Bottom, animated: true)
            })
            
        }
    }
}

extension ChatController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let messageModel = messages[indexPath.row]
        
        if messageModel.messageSender != "Me" {
            let messageCell = tableView.dequeueReusableCellWithIdentifier("MessageCell") as! MessageCell
            messageCell.from.text = messageModel.messageSender
            messageCell.message.text = messageModel.messageBody
            return messageCell
        } else {
            let receivedCell = tableView.dequeueReusableCellWithIdentifier("ReceivedCell") as! ReceivedCell
            receivedCell.userName.text = messageModel.messageSender
            receivedCell.message.text = messageModel.messageBody
            return receivedCell
        }
    }
}

extension ChatController : XMPPManagerStreamDelegate {
    
    func didReceiveMessage(message : MessageModel) {
        messages.append(message)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: (self.messages.count - 1), inSection: 0), atScrollPosition: .Bottom, animated: true)
        })
    }
    
    func didReceivePresence(presence : UserState, from : UserModel) {
        
    }
    
}