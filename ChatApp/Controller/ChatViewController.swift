//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Ammar Elshamy on 3/5/19.
//  Copyright © 2019 Ammar Elshamy. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    var messageArray = [Message]()

    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the class as the delegate and datasource of the table view
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        
        //set the class as the delegate of the text field
        messageTextField.delegate = self
        
        
        //Table View tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        //Register MessageCell.xib file:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "messageCell")
        
        
        messageTableView.separatorStyle = .none
        
        configureTableView()
        retrieveMessages()

    }
    
    
    
    //MARK: - TableView Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell" , for: indexPath) as! MessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.senderUsername.text == FIRAuth.auth()?.currentUser?.email{
            cell.messageBackground.backgroundColor = UIColor.flatMint()
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
        }else{
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
            cell.avatarImageView.backgroundColor = UIColor.flatSkyBlue()
        }
        
        return cell
    }
    
    
    //Declare number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    
    //Configure messageTableView
    func configureTableView(){
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    @objc func tableViewTapped(){
        messageTextField.endEditing(true)
    }
    
    
    //MARK: - TextField Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 318
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 60
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    //MARK: -
    
    func retrieveMessages(){
        
        let messageDB = FIRDatabase.database().reference().child("Messages")
        messageDB.observe(.childAdded, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            

            let message = Message(from: sender, says: text)
            self.messageArray.append(message)
            
            self.messageTableView.reloadData()
            
        })
        
    }
    
    
    @IBAction func sendPressed(_ sender: Any) {
        //Hide the keyboard
        messageTextField.endEditing(true)
        
        //Disable messageTextField and sendButton
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        
        //Send the message to Firebase
        let messagesDB = FIRDatabase.database().reference().child("Messages")
        let messageDictionary = ["Sender": FIRAuth.auth()?.currentUser?.email,
                                 "MessageBody": messageTextField.text!]
        
        messagesDB.childByAutoId().setValue(messageDictionary){
            (error, ref) in
            if error != nil{
                print(error!)
            }else{
                print("Message saved successfully")
                
                //Clear messageTextField
                self.messageTextField.text = ""
            }
        }
        
        //Enable messageTextField and sendButton
        messageTextField.isEnabled = true
        sendButton.isEnabled = true
        view.layoutIfNeeded()
        
    }
    
   
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        
        do{
            try FIRAuth.auth()?.signOut()
        }catch{
            print("error while signing out")
        }
    
        guard (navigationController?.popToRootViewController(animated: true)) != nil
            else{
                print("no view controllers to pop")
                return
        }
        
    }
    
    
    
}
