//
//  UserListController.swift
//  SwiftXMPPMessenger
//
//  Created by Peter Gosling on 5/19/16.
//  Copyright © 2016 SunfireSoft. All rights reserved.
//

import UIKit
import XMPPFramework

class UserListController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var userList = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        XMPPManager.sharedInstance.xmppManagerRosterDelegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        XMPPManager.sharedInstance.xmppRoster?.fetchRoster()
        let presence = XMPPPresence(type: "Available")
        XMPPManager.sharedInstance.xmppStream?.sendElement(presence)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension UserListController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let model = userList[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell") as! UserCell
        
        cell.nickName.text = model.nickName
        
        if model.userState == .Available {
            cell.presence.text = "Available"
        } else if model.userState == .Unavailable {
            cell.presence.text = "Unavailable"
        }
        
        return cell
        
    }
}

extension UserListController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = self.userList[indexPath.row]
        
        let chatController = self.storyboard?.instantiateViewControllerWithIdentifier("ChatController") as! ChatController
        chatController.userModel = model
        
        self.navigationController?.pushViewController(chatController, animated: true)
        
    }
}

extension UserListController : XMPPManagerRosterDelegate {
    
    func didReceivePresence(presence : UserState, from : String) {
        for x in 0..<self.userList.count {
            var model = self.userList[x]
            print("Found JID in Userlist")
            if model.jid == from {
                model.userState = presence
                self.userList[x] = model
            }
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    func addedBuddyToList(buddyList :[UserModel]) {
        self.userList = buddyList
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
}

