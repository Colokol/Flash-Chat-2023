//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by user on 23.03.23.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet var messageBooble: UIView!
    @IBOutlet var meAvatar: UIImageView!
    @IBOutlet var label: UILabel!
    
    @IBOutlet var leftAvatar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBooble.layer.cornerRadius = messageBooble.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
