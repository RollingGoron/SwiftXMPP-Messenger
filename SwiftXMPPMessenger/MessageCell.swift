//
//  MessageCell.swift
//  SwiftXMPPMessenger
//
//  Created by Peter Gosling on 5/22/16.
//  Copyright © 2016 SunfireSoft. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var from: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
