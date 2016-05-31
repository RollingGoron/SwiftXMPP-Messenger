//
//  ReceivedCell.swift
//  SwiftXMPPMessenger
//
//  Created by Peter Gosling on 5/31/16.
//  Copyright © 2016 SunfireSoft. All rights reserved.
//

import UIKit

class ReceivedCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
