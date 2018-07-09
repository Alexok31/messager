//
//  chatTableViewCell.swift
//  myMesseger
//
//  Created by Александр Харченко on 24.05.2018.
//  Copyright © 2018 Александр Харченко. All rights reserved.
//

import UIKit

class MessagesCell: UITableViewCell {

    @IBOutlet weak var avatarImagView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    func messageSetupCell(_ message: MessageStructure, indexPath: IndexPath) {
        avatarImagView.layer.cornerRadius = avatarImagView.frame.height / 2
        if let text = message.textMessage {
            messageLabel.text = text
        } else {
            messageLabel.text = "Photo"
        }
        let partherId = FirebaseService().chatPartnerId(for: message)
        if partherId != nil {
            FirebaseService().receivingUsersFromFireDat(message: message) { (user) in
                if user.username != nil {
                    self.usernameLabel.text = user.username
                } else {
                    self.usernameLabel.text = user.email
                }
                if user.profileImage != nil {
                    self.avatarImagView.downloadImeg(from: (user.profileImage)!)
                } else {
                    self.avatarImagView.image = #imageLiteral(resourceName: "Portrait_Placeholder")
                }
            }
        }
        if let second = message.timeSendMessage {
            let timestampData = NSDate(timeIntervalSince1970: TimeInterval(truncating: NSNumber(value: second)))
            let dateFormat = DateFormatter()
            dateFormat.timeStyle = .short
            dateFormat.dateStyle = .none
            dateFormat.locale = Locale(identifier: "ru_UA")
            timeLabel.text = dateFormat.string(from: timestampData as Date)
            timeLabel.clipsToBounds = true
            timeLabel.layer.cornerRadius = 8
        }
    }

}
