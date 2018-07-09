//
//  SettingsController.swift
//  myMesseger
//
//  Created by Александр Харченко on 24.05.2018.
//  Copyright © 2018 Александр Харченко. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {

    @IBOutlet weak var avatarImeg: UIImageView!
    
    @IBAction func editAvatarImeg(_ sender: Any) {
        FirebaseHelper().removeProfileImage()
        handleSelectProfileImeg()
    }
    @IBOutlet weak var nameTextFild: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBAction func saveData(_ sender: Any) {
        FirebaseHelper().settings(nameTextFild: nameTextFild, avatarImeg: avatarImeg)
        seveNameLabel.text = "Saved!"
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        MessagesTableViewController().updateData()
        logout()
    }
    @IBOutlet weak var seveNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
        avatarImeg.layer.cornerRadius = avatarImeg.frame.height / 2
    }
    
    func getUserInfo() {
        FirebaseService().getUserInfo { (users) in
            if users.username != nil {
                self.nameTextFild.text = users.username
            }
            if users.profileImage != nil {
                self.avatarImeg.downloadImeg(from: (users.profileImage!))
            } else {
                self.avatarImeg.image = #imageLiteral(resourceName: "Portrait_Placeholder")
            }
            self.emailLabel.text = users.email
        }
    }
    
    func logout() {
        do {
            try FirebaseHelper().authorization.signOut()
        } catch let loginError {
            print(loginError)
        }
        
        let authorizationVc = storyboard!.instantiateViewController(withIdentifier: "LoginView") as! AuthorizationViewController
        navigationController?.pushViewController(authorizationVc, animated: true)
    }
}
