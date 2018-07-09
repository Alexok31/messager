//
//  MessagesCell.swift
//  myMesseger
//
//  Created by Александр Харченко on 05.07.2018.
//  Copyright © 2018 Александр Харченко. All rights reserved.
//

import UIKit

class UsersCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    func setupUsersCell(_ users: UserStructure, indexPath: IndexPath) {
        userImage.layer.cornerRadius = userImage.frame.height / 2
        if users.username != nil {
            userName.text = users.username
        } else {
            userName?.text = users.email
        }
        
        if users.profileImage != nil {
            userImage.downloadImeg(from: (users.profileImage)!)
        } else {
            userImage.image = #imageLiteral(resourceName: "Portrait_Placeholder")
        }
    }
}
