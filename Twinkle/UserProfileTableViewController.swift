//
//  UserProfileTableViewController.swift
//  Twinkle
//
//  Created by Lynette Nguyen on 2/2/20.
//  Copyright © 2020 Twinkle. All rights reserved.
//

import UIKit
import Firebase

class UserProfileTableViewController: UITableViewController {

    var ref: DatabaseReference!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userSun: UILabel!
    @IBOutlet weak var userMoon: UILabel!
    @IBOutlet weak var userRising: UILabel!
    @IBOutlet weak var userDaily: UILabel!
    @IBOutlet weak var userCompatiable: UILabel!
    @IBOutlet weak var userSunInfo: UILabel!
    @IBOutlet weak var userMoonInfo: UILabel!
    @IBOutlet weak var userRisingInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()


        fillInfo()
        }

    func fillInfo() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.nameLabel.text = value?["first name"] as? String ?? ""

            // ...
          }) { (error) in
            print(error.localizedDescription)
        }
    }
}
