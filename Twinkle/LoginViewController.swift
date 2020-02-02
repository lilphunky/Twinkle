//
//  LoginViewController.swift
//  Twinkle
//
//  Created by Lily Pham on 2/1/20.
//  Copyright © 2020 Twinkle. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func login(_ sender: Any) {
        if !fieldsEmpty() {
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (authResult, error) in
                if let error = error {
                    let alert = UIAlertController(title: "Login failed", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    DispatchQueue.main.async {
                        let vc: MatchViewViewController = self.storyboard?.instantiateViewController(identifier: "Match View") as! MatchViewViewController
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
        
    }
    
    func fieldsEmpty() -> Bool {
        if emailField.text == "" || passwordField.text == "" {
            return true
        }
        return false
    }
    
}
