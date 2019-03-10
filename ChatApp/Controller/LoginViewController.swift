//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Ammar Elshamy on 3/5/19.
//  Copyright © 2019 Ammar Elshamy. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        SVProgressHUD.show() //Loading indicator
        
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            if error != nil{
                print(error!)
            }else{
                print("Login successful")
                
                SVProgressHUD.dismiss()
                
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        })
        
    }
    

    

}
