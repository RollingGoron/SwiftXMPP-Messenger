//
//  UIViewController+Alerts.swift
//  SwiftXMPPMessenger
//
//  Created by Peter Gosling on 5/24/16.
//  Copyright © 2016 SunfireSoft. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlertController(title: String?, message: String?, actionText: String, completion: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: actionText, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.presentViewController(alertController, animated: true, completion:completion)
    }
}