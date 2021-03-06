//
//  MotherOrCaretakerViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/21/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit
import MapKit

class MotherOrCaretakerRegistrationViewController: UIViewController, TransitionBetweenViewControllers {
    //MARK: Private Properties
    private var networkingController = ABCNetworkingController()
    private let locationManager = CLLocationManager()
    private var searchController: UISearchController?
    private var startName: String?
    //MARK: Other Properties
    var mother: PregnantMom?
    var isUpdating: Bool = false
    //MARK: IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var villageTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var caretakerTextField: UITextField!
    @IBOutlet weak var destinationSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        caretakerTextField.isHidden = true
        setupKeyboardDismissRecognizer()
        
        
        populateTextFieldsAndConfigureViewForEditing()
        
        if isUpdating {
            guard let mom = AuthenticationController.shared.pregnantMom else {return}

            
        }
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.frame = CGRect(x: 153.33333333333337, y: 0.0, width: 181.66666666666666, height: 30.0)
        villageTextField.frame = CGRect(x: 153.33333333333337, y: 0.0, width: 181.66666666666666, height: 30.0)
        phoneTextField.frame = CGRect(x: 153.33333333333337, y: 0.0, width: 181.66666666666666, height: 30.0)
        caretakerTextField.frame = CGRect(x: 153.33333333333337, y: 0.0, width: 181.66666666666666, height: 30.0)
    }
    
    //MARK: IBActions
    @IBAction func caretakerButtonTapped(_ sender: Any) {
        caretakerTextField.isHidden = false
    }
    
    @IBAction func helpButtonTapped(_ sender: Any) {
        showInformationAlert()
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        guard nameTextField.text != "", villageTextField.text != "", phoneTextField.text != "",
            let name = nameTextField.text, let village = villageTextField.text, let phone = phoneTextField.text else {return}
       
        var caretakerName = caretakerTextField.text

        AuthenticationController.shared.genericUser?.name = nameTextField.text! as NSString
        AuthenticationController.shared.genericUser?.phone = phoneTextField.text! as NSString
        

        if caretakerName == nil {
            caretakerName = ""
        }
        UserController().configurePregnantMom(isUpdating: isUpdating, name: name as NSString, village: village as NSString, phone: phone as NSString, caretakerName: caretakerName as NSString?, startLatLong: "0, 0", destinationLatLong: "0, 0" as NSString, startDescription: "")

        transition(userType: nil)
    }
    

    //MARK: TransitionBetweenViewControllers Protocol Method
    func transition(userType: UserType?) {
        let destinationVC = MotherOnboardingLocationsViewController()
        self.present(destinationVC, animated: true) {
        }
    }
    
    ///MARK
    
    //MARK: Private Methods
    
    
    ///This method will set up a tap gesture recognizer to dismiss the keyboard whenever the user touches a view outside of it.
    private func setupKeyboardDismissRecognizer(){
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))
        
        self.view.addGestureRecognizer(tapRecognizer)
    }
    @objc
    private func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    private func populateTextFieldsAndConfigureViewForEditing() {
        nameTextField.isHidden = false
        phoneTextField.isHidden = false
        villageTextField.isHidden = false
        if let mother = mother,
            let user = AuthenticationController.shared.genericUser {
            nameTextField.text = user.name as String?
            phoneTextField.text = user.phone as String?
            villageTextField.text = mother.start?.name as String?
            caretakerTextField.text = mother.caretakerName as String?
            caretakerTextField.isHidden = false
        }
    }
    
    //This method was getting called in viewDidLoad, but nothing was happening. That is because you cannot successfully call `present` on a view controller until that view controller's view has fully transitioned onto the screen. That is why it is necessary to call `present(...)` in viewDidAppear, because viewDidAppear is called after that transition has been completed.
    private func showInformationAlert() {
        let informationAlert = UIAlertController(title: "Important Information", message: "Please fill out all available fields and select a pickup location and a destination location using the map. You may select the buttons below for more information on how to access the caretaker field and on how to use the map. None of this information is permanent and you may change it at any time.", preferredStyle: .alert)
        informationAlert.addAction(UIAlertAction(title: "Select Pickup Location", style: .default, handler: { (alertAction) in
            informationAlert.title = "Select Pickup Location"
            informationAlert.message = "Tap and hold with one finger on the map to create a marker at your desired pickup location. You may tap, hold and drag with your finger to move this marker around the map once the marker has been created."
            self.present(informationAlert, animated: true, completion: nil)
        }))
        informationAlert.addAction(UIAlertAction(title: "Search For Hospital", style: .default, handler: { (alertAction) in
            informationAlert.title = "Search For Hospital"
            informationAlert.message = "Use the search bar above the map to search for your preferred Hospital or Health Center where you would like to give birth. Once you have found your preferred Hospital or Health Center, select it and a destination marker will be placed on the map at your desired destination location."
            self.present(informationAlert, animated: true, completion: nil)
        }))
        informationAlert.addAction(UIAlertAction(title: "Caretaker?", style: .default, handler: { (alertAction) in
            informationAlert.title = "Caretaker?"
            informationAlert.message = "The caretaker field is optional, please tap the \"Caretaker?\" button below the map to enable the Caretaker field and input a caretaker's name."
            self.present(informationAlert, animated: true, completion: nil)
        }))
        informationAlert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { (alertAction) in
            informationAlert.dismiss(animated: true, completion: nil)
        }))
        
        
        present(informationAlert, animated: true, completion: nil)
    }
    private func showMissingInformationAlert() {
        let missingInfoAlert = UIAlertController(title: "Please Complete Your Profile", message: "You have not filled out all required fields. The caretaker field is optional, but all others must be filled out. Please tap to the 'Help' button in the bottom left corner of this window for help filling out all required fields. Thank you.", preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Continue", style: .default, handler: nil)
        let helpAction = UIAlertAction(title: "Help", style: .default) { (alertAction) in
            self.showInformationAlert()
        }
        missingInfoAlert.addAction(continueAction)
        missingInfoAlert.addAction(helpAction)
        present(missingInfoAlert, animated: true, completion: nil)
    }
    private func showMissingCoordinatesAlert() {
        let missingCoordAlert = UIAlertController(title: "Please Select a Destination and a Pickup Location", message: "You have not selected both a destination and a pickup location. Please refer to the 'Help' button in the bottom left corner of this window for help selecting a destination and a pickup location.", preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Continue", style: .default, handler: nil)
        let helpAction = UIAlertAction(title: "Help", style: .default) { (alertAction) in
            self.showInformationAlert()
        }
        missingCoordAlert.addAction(continueAction)
        missingCoordAlert.addAction(helpAction)
        present(missingCoordAlert, animated: true, completion: nil)
    }
    
}
