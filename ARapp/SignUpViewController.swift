//
//  SignUpViewController.swift
//  ARapp
//
//  Created by Patrick Hsuan Hsu on 2018-06-05.
//  Copyright © 2018 Patrick Hsuan Hsu. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    var ref: DatabaseReference!
    
    
    @IBAction func dismissSignUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        signUpBtn.setTitleColor(UIColor.lightText, for: UIControlState.normal)
        signUpBtn.isEnabled = false
        handleTextField()
    }
    
    func handleTextField(){
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        
    }
    
    @objc func textFieldDidChange(){
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signUpBtn.setTitleColor(UIColor.lightText, for: UIControlState.normal)
            signUpBtn.isEnabled = false
            return
        }
        signUpBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        signUpBtn.isEnabled = true
    }
    @IBAction func signUpBtn_TouchUpInside(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!){ (authResult, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            self.ref = Database.database().reference()
            let userReference = self.ref.child("users")
            let uid = authResult?.user.uid
            
            let newUserReference = userReference.child(uid!)
            newUserReference.setValue(["email": self.emailTextField.text])
            self.performSegue(withIdentifier: "signUpToMainView", sender: nil)
        }
        
    }
}
