//
//  SignUpViewController.swift
//  Twinkle
//
//  Created by Lily Pham on 2/1/20.
//  Copyright © 2020 Twinkle. All rights reserved.
//

import UIKit
import Firebase

class SignUpTableViewController: UITableViewController {
    
    var ref: DatabaseReference!

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    @IBOutlet weak var birthtimePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
    }
    
    @IBAction func selectCity(_ sender: Any) {
    }
    
    @IBAction func saveProfile(_ sender: Any) {
        
        if fieldsNotEmpty() {
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { authResult, error in
                if error != nil {
                    let alert = UIAlertController(title: "Profile not saved", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    print(error?.localizedDescription)
                } else {
                    // Get ID of currently logged in user
                    let userID = Auth.auth().currentUser?.uid
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM-dd-yyyy"
                    let timeFormatter = DateFormatter()
                    timeFormatter.dateFormat = "HH:mm"
                    let strDate = dateFormatter.string(from: self.birthdayPicker.date)
                    let strTime = timeFormatter.string(from: self.birthtimePicker.date)
                    
                    self.ref.child("users").child(userID!).setValue(
                        ["first name": self.firstName.text!,
                         "last name": self.lastName.text!,
                         "birthday": strDate,
                         "birthtime": strTime])
                }
            }
        }
        
    }
    
    func fieldsNotEmpty() -> Bool {
        if firstName.text == "" || lastName.text == "" {
            let alert = UIAlertController(title: "Profile not saved", message: "Please fill in your first and last name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
}
