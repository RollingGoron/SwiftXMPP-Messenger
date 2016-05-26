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
    
    override func viewWillAppear(animated: Bool) {
        self.toolBarInitialValue = toolbarBottomConstraint.constant
        self.registerForKeyboardNotifications()
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
            userModel?.chatHistory.append(message)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: ((self.userModel?.chatHistory.count)! - 1), inSection: 0), atScrollPosition: .Bottom, animated: true)
            })
            
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

    func didReceiveMessage(message : MessageModel) {
        userModel?.chatHistory.append(message)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: ((self.userModel?.chatHistory.count)! - 1), inSection: 0), atScrollPosition: .Bottom, animated: true)
        })
    }
    
    func didReceivePresence(presence : UserState, from : UserModel) {
        
    }
    
}