//
//  SignUpViewController.swift
//  Twinkle
//
//  Created by Lily Pham on 2/1/20.
//  Copyright © 2020 Twinkle. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces

class SignUpTableViewController: UITableViewController {
    
    var ref: DatabaseReference!

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    @IBOutlet weak var birthtimePicker: UIDatePicker!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var selectCityBTN: UIButton!
    
    var cityLat: Double = 0.0
    var cityLong: Double = 0.0
    var cityTmz: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
    }
    
    @IBAction func onCancelTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectCity(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
          UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
        
    }
    
    @IBAction func saveProfile(_ sender: Any) {
        if fieldsNotEmpty() {
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { authResult, error in
                if error != nil {
                    let alert = UIAlertController(title: "Profile not saved", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    // Get ID of currently logged in user
                    let userID = Auth.auth().currentUser?.uid
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM-dd-yyyy"
                    let timeFormatter = DateFormatter()
                    timeFormatter.dateFormat = "HH:mm"
                    let strDate = dateFormatter.string(from: self.birthdayPicker.date)
                    let strTime = timeFormatter.string(from: self.birthtimePicker.date)
                    
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.month, .day, .year], from: birthdayPicker.date)
                    let year = components.year
                    let month = components.month
                    let day = components.day
                    
                    let timeComponents = calendar.dateComponents([.hour, .minute], from: self.birthtimePicker.date)
                    let hour = timeComponents.hour
                    let minute = timeComponents.minute
                    
                    self.ref.child("users").child(userID!).setValue(
                        ["first name": self.firstName.text!,
                         "last name": self.lastName.text!,
                         "birthday": strDate,
                         "birthtime": strTime,
                         "latitude": self.cityLat,
                         "longitude": self.cityLong,
                         "timezone": self.cityTmz])
                    
                    sendPost(urlString: "https://json.astrologyapi.com/v1/planets", parameters: GENERAL_PLANET_PARAM(day: day!, month: month!, year: year!, hour: hour!, min: minute!, lat: self.cityLat, lon: self.cityLong, tzone: cityTmz), success: { data in
                        self.ref.child("users").child(userID!).child("chart").setValue(
                            ["sun": data[0]["sign"],
                             "moon": data[2]["sign"],
                             "rising": data[10]["sign"]])
                    }) { error in
                        let alert = UIAlertController(title: "Profile not saved", message: error?.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    DispatchQueue.main.async {
                        let vc: MatchViewViewController = self.storyboard?.instantiateViewController(identifier: "Match View") as! MatchViewViewController
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func fieldsNotEmpty() -> Bool {
        if firstName.text == "" || lastName.text == "" {
            let alert = UIAlertController(title: "Profile not saved", message: "Please fill in your first and last name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        if cityLabel.isHidden {
            let alert = UIAlertController(title: "Profile not saved", message: "Please select the city you were born in.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
}


extension SignUpTableViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    cityLabel.isHidden = false
    cityLabel.text = place.name
    selectCityBTN.setTitle("Change city", for: .normal)
    cityLat = place.coordinate.latitude
    cityLong = place.coordinate.longitude
    cityTmz = Double(place.utcOffsetMinutes/60.0)
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }
/*
  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }*/

}
