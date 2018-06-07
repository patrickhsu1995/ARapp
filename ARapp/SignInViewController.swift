//
//  SignInViewController.swift
//  ARapp
//
//  Created by Patrick Hsuan Hsu on 2018-06-05.
//  Copyright © 2018 Patrick Hsuan Hsu. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        signInBtn.isEnabled = false
        handleTextField()
    }
    
    func handleTextField(){
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        
    }
    
    @objc func textFieldDidChange(){
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signInBtn.setTitleColor(UIColor.lightText, for: UIControlState.normal)
            signInBtn.isEnabled = false
            return
        }
        signInBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        signInBtn.isEnabled = true
    }

    @IBAction func signInButton_TouchUpInside(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            print("signed in")
            self.performSegue(withIdentifier: "signInToMainView", sender: nil)
        })
    }
}
