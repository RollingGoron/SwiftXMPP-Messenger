//
//  UserListController.swift
//  SwiftXMPPMessenger
//
//  Created by Peter Gosling on 5/19/16.
//  Copyright © 2016 SunfireSoft. All rights reserved.
//

import UIKit

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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UserListController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let model = userList[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell") as! UserCell
        
        cell.nickName.text = model.nickName
        
        return cell
        
    }
}

extension UserListController : UITableViewDelegate {
    
}

extension UserListController : XMPPManagerRosterDelegate {
    func didRecieveBuddy(user : UserModel) {
        
    }
    
    func addedBuddyToList(buddyList :[UserModel]) {
        self.userList = buddyList
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
}
