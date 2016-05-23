//
//  ViewController.swift
//  SwiftXMPPMessenger
//
//  Created by Peter Gosling on 5/18/16.
//  Copyright © 2016 SunfireSoft. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        XMPPManager.sharedInstance.setXMPPDelegates()
        XMPPManager.sharedInstance.xmppManagerLoginDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginToXMPP(sender: AnyObject) {
         XMPPManager.sharedInstance.loginToXMPPServer(usernameField.text!, password: passwordField.text!)
    }

}

extension LoginController : XMPPManagerLoginDelegate {
    
    func failedToAuthenticate(error: String) {
        
    }
    
    func didConnectToServer(bool: Bool, errorMessage: String?) {
        if bool {
            let userListController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListController") as! UserListController
            self.navigationController?.pushViewController(userListController, animated: true)
        }
    }
}

extension UIViewController {
    func presentAlertController(title: String?, message: String?, actionText: String, completion: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: actionText, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.presentViewController(alertController, animated: true, completion:completion)
    }
}