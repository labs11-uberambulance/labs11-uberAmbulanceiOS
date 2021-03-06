//
//  DriverRegistrationViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/21/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit
import MapKit
import UserNotifications

class DriverRegistrationViewController: UIViewController, TransitionBetweenViewControllers {
    
    //MARK: Private Properties
    private var userLocation: NSString?
    private var destinationVC: UIViewController?
    
    //MARK: Other Properties
    var driver: Driver?
    var isUpdating: Bool = false
    
    //MARK: IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardDismissRecognizer()
        populateLabelsAndTextFields()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(showRideRequestAlert), name: .didReceiveRideRequest, object: nil)
        
        
    }
    
    
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        
        guard let name = nameTextField?.text,
            let phoneNumber = phoneNumberTextField.text,
            let price = priceTextField.text,
            let bio = bioTextView.text,
            let userLocation = userLocation,
            userLocation != "" else {return}
        
        let otherName = name as NSString
        let otherPhone = phoneNumber as NSString
        let otherPrice = price as NSString
        let otherBio = bio as NSString

        
        UserController().configureDriver(isUpdating: isUpdating, name: otherName, address: nil, email: nil, phoneNumber: otherPhone, price: otherPrice, bio: otherBio, photo: nil, userLocation: userLocation)
        transition(userType: nil)
    }
    @IBAction func helpButtonTapped(_ sender: Any) {
        showInformationAlert()
    }
    
    func transition(userType: UserType?) {
        guard let destinationVC = destinationVC else {
        let driverPhotoRegistrationViewController = DriverPhotoRegistrationViewController()
        self.present(driverPhotoRegistrationViewController, animated: true) {
        }
            return
        }
        present(destinationVC, animated: true, completion: nil)
    }
    
    
    
    
    //MARK: Private Methods
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
    
    private func populateLabelsAndTextFields() {
        if let driver = driver,
            let user = AuthenticationController.shared.genericUser {
            priceTextField.text = driver.price?.stringValue
            bioTextView.text = driver.bio as String?
            phoneNumberTextField.text = user.phone as String?
            nameTextField.text = user.name as String?
        }
    }
    
    
    private func showInformationAlert() {
        let informationAlert = UIAlertController(title: "Important Information", message: "Please fill out all available fields and select a \"home\" location using the map. You may select the buttons below for more information about different fields and on how to use the map. None of this information is permanent and you may change it at any time.", preferredStyle: .alert)
        informationAlert.addAction(UIAlertAction(title: "Maximum Price", style: .default, handler: { (alertAction) in
            informationAlert.title = "Maximum Price"
            informationAlert.message = "In this field you are expected to input the maximum price you will charge for your services. This is not permanent and you may change it at any time. If you have an active ride and decide to change your maximum price, the price will not change for that active ride."
            self.present(informationAlert, animated: true, completion: nil)
        }))
        informationAlert.addAction(UIAlertAction(title: "Biography", style: .default, handler: { (alertAction) in
            informationAlert.title = "Biography"
            informationAlert.message = "Many of the people you will transport are people you have never met before. In this field, please give a brief description of who you are and the service you provide. This will help the pregnant mothers you transport to have peace of mind, because they will know a little about you before you transport them to their location."
            self.present(informationAlert, animated: true, completion: nil)
        }))
        informationAlert.addAction(UIAlertAction(title: "Select a Home Location", style: .default, handler: { (alertAction) in
            informationAlert.title = "Select A Home Location"
            informationAlert.message = "You  will appear at this location on the pregnant mother's map when she searches for a nearby driver to transport her to the hospital. To set your \"home\" location, please tap and hold with one finger on the map to create a marker at the desired location. You may tap, hold and drag with your finger to move this marker around the map once the marker has been created. "
            self.present(informationAlert, animated: true, completion: nil)
        }))
        informationAlert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { (alertAction) in
            informationAlert.dismiss(animated: true, completion: nil)
        }))
        
        
        present(informationAlert, animated: true, completion: nil)
    }
    @objc private func showRideRequestAlert() {
        guard let name = AuthenticationController.shared.requestedRide?.name,
            let distance = AuthenticationController.shared.requestedRide?.distance,
            let hospital = AuthenticationController.shared.requestedRide?.hospital else {return}
        let rideRequestAlert = UIAlertController(title: "Ride Request", message: "\(name as String) is \(distance as String) miles away and wants to be taken to \(hospital as String)", preferredStyle: .alert)
        
        rideRequestAlert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (alertAction) in
            self.destinationVC = ServiceRideViewController()
        }))
        rideRequestAlert.addAction(UIAlertAction(title: "Reject", style: .default, handler: { (alertAction) in
            AuthenticationController.shared.requestedRide = nil
        }))
     present(rideRequestAlert, animated: true, completion: nil)
    }

}
