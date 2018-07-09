//
//  ChatCell.swift
//  myMesseger
//
//  Created by Александр Харченко on 31.05.2018.
//  Copyright © 2018 Александр Харченко. All rights reserved.
//

import UIKit

class ChatCell: UICollectionViewCell {
    
    
    @IBOutlet weak var textMessageLabel: UILabel!
    
    @IBOutlet weak var userIamge: UIImageView!
    
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var bubbleView: UIView!
    
    @IBOutlet weak var bubbleWidthAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var bubbleRightAnchor: NSLayoutConstraint!
    
    func setupCell(_ message: MessageStructure, user: UserStructure) {
        userIamge.layer.cornerRadius = userIamge.frame.height / 2
        messageImage.layer.cornerRadius = 8
        
        if message.fromId == FirebaseHelper().authorization.currentUser?.uid {
            bubbleView.backgroundColor = UIColor(displayP3Red: 30/255, green: 144/255, blue: 255/255, alpha: 1)
            textMessageLabel.textColor = .white
            bubbleRightAnchor.constant = 8
            if let message = message.textMessage {
                messageImage.isHidden = true
                bubbleWidthAnchor.constant = (UIScreen.main.bounds.size.width - self.estimateFrameFromText(message).width - 30)
            } else {
                 messageImage.isHidden = false
                bubbleView.backgroundColor = UIColor.clear
                bubbleWidthAnchor.constant = 150
                messageImage.downloadImeg(from: message.messageImage!)
            }
            userIamge.isHidden = true
        } else {
            bubbleView.backgroundColor = UIColor.white
            textMessageLabel.textColor = .black
            bubbleWidthAnchor.constant = 35
            if let message = message.textMessage {
                 messageImage.isHidden = true
                 bubbleRightAnchor.constant = (UIScreen.main.bounds.size.width - self.estimateFrameFromText(message).width - 60)
            } else {
                messageImage.isHidden = false
                bubbleView.backgroundColor = UIColor.clear
                messageImage.downloadImeg(from: message.messageImage!)
            }
            userIamge.isHidden = false
            if user.profileImage != nil {
                userIamge.downloadImeg(from: user.profileImage!)
            } else {
                userIamge.image = #imageLiteral(resourceName: "Portrait_Placeholder")
            }
            
        }
    }
    func estimateFrameFromText(_ text: String) -> CGRect {
        
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesLineFragmentOrigin.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }

    
    
    
}





