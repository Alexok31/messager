//
//  FirebaseHelper.swift
//  myMesseger
//
//  Created by Александр Харченко on 13.06.2018.
//  Copyright © 2018 Александр Харченко. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseHelper {
    
    let authorization = Auth.auth()
    let curentId = Auth.auth().currentUser?.uid
    let ref = Database.database().reference()
    let storeg = Storage.storage()
    
    func settings(nameTextFild: UITextField, avatarImeg: UIImageView) {
       
        if nameTextFild.text != "" {
            ref.child("users/\(String(describing: curentId!))/username").setValue(nameTextFild.text!)
        }
        let storegRef = storeg.reference().child("Profile_Imeg").child(curentId!)
        if avatarImeg.image != nil {
            let upLoadData = UIImagePNGRepresentation(avatarImeg.image!)
            storegRef.putData(upLoadData!, metadata: nil) { (metadata, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                storegRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    self.ref.child("users/\(String(describing: self.curentId!))/profileImage").setValue(url?.absoluteString)
                })
            }
        }
    }
    
    func uploadToFirebaseStorageUsingImag(_ selectedImage: UIImage, toId: String) {
        let imageId = NSUUID().uuidString
        let storegRef = storeg.reference().child("Message_Imeg").child(imageId)
        let upLoadData = UIImagePNGRepresentation(selectedImage)
        storegRef.putData(upLoadData!, metadata: nil) { (metadata, error) in
            
            if error != nil {
                print(error!)
                return
            }
            storegRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    print(error!)
                    return
                }
                MessagesHelper().handleSendMasseges(messege: nil, toId: toId, messageImage: url?.absoluteString, image: selectedImage)
            })
        }
    }
    func removeProfileImage() {
        let firebase = FirebaseHelper()
        firebase.ref.child("users").child(firebase.curentId!).child("profileImage").removeValue()
    }
}
