//
//  ChatViewController.swift
//  myMesseger
//
//  Created by Александр Харченко on 24.05.2018.
//  Copyright © 2018 Александр Харченко. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var viewBottm: NSLayoutConstraint!
    @IBOutlet weak var messageSendTextFieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var chatCollectionView: UICollectionView!
    @IBOutlet weak var messageTextFild: UITextField!
    
    @IBAction func sendMessage(_ sender: Any) {
        if messageTextFild.text != "" {
            MessagesHelper().handleSendMasseges(messege: messageTextFild.text!, toId: (users?.id!)!, messageImage: nil, image: nil)
            messageTextFild.text = ""
        }
    }
    
    @IBAction func sendImage(_ sender: Any) {
        selectImag()
    }
    var messageArrey = [MessageStructure]()
    private var height: CGFloat = 80
    var timer: Timer?
   
    
    var users : UserStructure? {
        didSet {
            observeMessages()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeybordNotification()
        if users?.username != nil {
            navigationItem.title = users?.username
        } else {
            navigationItem.title = users?.email
        }
        
    }
    
    func observeMessages()  {
        MessagesHelper().observeMassages { (message) in
            if FirebaseService().chatPartnerId(for: message) == self.users?.id {
                self.messageArrey.append(message)
            }
            DispatchQueue.main.async {
                self.chatCollectionView.reloadData()
                self.lowering()
//                if self.messageSendTextFieldBottomConstraint.constant != 0 {
//                    self.lowering()
//                }
            }
        }
    }
    
    @IBAction func tapGesters(_ sender: Any) {
        messageTextFild.resignFirstResponder()
    }
    deinit {
        removeForKeybordNotification()
    }
    ///
    func registerForKeybordNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeForKeybordNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kfFrameSize = (userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        messageSendTextFieldBottomConstraint.constant = kfFrameSize.height
        
        UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (comlated) in
        
            DispatchQueue.main.async {
                self.lowering()
            }
        }
    }
    
    @objc func kbWillHide() {
        messageSendTextFieldBottomConstraint.constant = 0
        UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (comlated) in
        }
    }
    
    func lowering() {
        if messageArrey.isEmpty == false {
            let sectionNumber = 0
            self.chatCollectionView?.scrollToItem(at: NSIndexPath.init(row:(self.chatCollectionView.numberOfItems(inSection: sectionNumber))-1, section: sectionNumber) as IndexPath, at: UICollectionViewScrollPosition.bottom, animated: true)
        }
    }
}

extension ChatViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageArrey.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chatCell", for: indexPath) as! ChatCell
        
        let message = messageArrey[indexPath.row]
        cell.bubbleView.layer.cornerRadius = 17
        cell.textMessageLabel.text = message.textMessage
        cell.setupCell(message, user: users!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        let message = messageArrey[indexPath.row]
        if let text = message.textMessage {
            height = ChatCell().estimateFrameFromText(text).height + 20
        } else if let imageWidth = message.imageWidth, let imageHeight = message.imageHeigth {
            height = CGFloat(imageHeight / imageWidth * 200 )
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        chatCollectionView.collectionViewLayout.invalidateLayout()
    }
}

