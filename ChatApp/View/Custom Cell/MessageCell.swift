//
//  MessageCell.swift
//  ChatApp
//
//  //  Created by Ammar Elshamy on 3/6/2019.

//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {


    @IBOutlet var messageBackground: UIView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var messageBody: UILabel!
    @IBOutlet var senderUsername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
        
        
        
    }


}
