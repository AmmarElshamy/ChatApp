//
//  Message.swift
//  ChatApp
//
//  Created by Ammar Elshamy on 3/9/19.
//  Copyright © 2019 Ammar Elshamy. All rights reserved.
//

import Foundation

class Message{
    var sender, messageBody : String
    
    init(from sender: String, says messageBody : String) {
        self.sender = sender
        self.messageBody = messageBody
    }
}
