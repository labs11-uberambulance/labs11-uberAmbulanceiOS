//
//  DriverWorkViewController.swift
//  
//
//  Created by Austin Cole on 4/3/19.
//

import UIKit
import FirebaseAuth

class DriverWorkViewController: UIViewController, UITableViewDelegate {
    //MARK: IBOutlets
    @IBOutlet weak var isWorkingSwitch: UISwitch!
    @IBOutlet weak var requestTimeLabel: UILabel!
    @IBOutlet weak var startVillageLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var acceptRideButton: UIButton!
    @IBOutlet weak var rejectRideButton: UIButton!
    //MARK: Private Properties
    
    
    //MARK: Other Properties
    var isSubviewOfSuperview = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isWorkingSwitch.isOn = false
        requestTimeLabel.isHidden = true
        startVillageLabel.isHidden = true
        destinationLabel.isHidden = true
        acceptRideButton.isHidden = true
        rejectRideButton.isHidden = true
        guard let fcmTokenDictionary = UserDefaults.standard.dictionary(forKey: "FCMToken"),
            let firToken = AuthenticationController.shared.userToken else {return}
        ABCNetworkingController().refreshToken(withFIRToken: firToken, withFCMToken: fcmTokenDictionary) { (error) in
            if let error = error {
                NSLog("Error in DriverWorkViewController.viewDidLoad")
                NSLog(error.localizedDescription)
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .didReceiveRideRequest, object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AuthenticationController.shared.driver == nil {
            present(PhoneAuthorizationViewController(), animated: true, completion: nil)
            return
        }
        if AuthenticationController.shared.requestedRide != nil {
            updateViews()
        }
        else {
            
            guard let isActive = AuthenticationController.shared.driver?.isActive else {return}
            if isActive.boolValue {
                isWorkingSwitch.isOn = true
            }
            if isWorkingSwitch.isOn && AuthenticationController.shared.requestedRide == nil {
                requestTimeLabel.isHidden = true
                startVillageLabel.isHidden = true
                destinationLabel.isHidden = true
                acceptRideButton.isHidden = true
                rejectRideButton.isHidden = true
            } else if AuthenticationController.shared.requestedRide != nil {
                requestTimeLabel.isHidden = false
                startVillageLabel.isHidden = false
                destinationLabel.isHidden = false
                acceptRideButton.isHidden = false
                rejectRideButton.isHidden = false
            } else if !isWorkingSwitch.isOn {
                requestTimeLabel.isHidden = true
                startVillageLabel.isHidden = true
                destinationLabel.isHidden = true
                acceptRideButton.isHidden = true
                rejectRideButton.isHidden = true
            }
        }
    }
    
    //MARK: IBActions
    @IBAction func acceptRideButtonTapped(_ sender: Any) {
        guard let userToken = AuthenticationController.shared.userToken,
            let rideId = AuthenticationController.shared.requestedRide?.rideId else {return}
        ABCNetworkingController().driverAcceptsOrRejectsRide(withToken: userToken, withRideId: rideId, withDidAccept: true, withRide: nil) { (error) in
            if let error = error {
                NSLog("Error in DriverWorkVC.acceptRideButtonTapped")
                NSLog(error.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.serviceRideTransition()
            }
        }
        
        
    }
    @IBAction func rejectRideButtonTapped(_ sender: Any) {
        guard let userToken = AuthenticationController.shared.userToken,
            let rideId = AuthenticationController.shared.requestedRide?.rideId,
            let requestedRideDictionary = UserDefaults.standard.dictionary(forKey: "UserInfoKey") else {return}
        ABCNetworkingController().driverAcceptsOrRejectsRide(withToken: userToken, withRideId: rideId, withDidAccept: false, withRide: requestedRideDictionary) { (error) in
            if let error = error {
                NSLog("Error in DriverWorkVC.acceptRideButtonTapped")
                NSLog(error.localizedDescription)
                return
            }
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            NSLog("Could not sign out user in DriverWorkViewController.logoutButtonTapped")
            NSLog(error.localizedDescription)
        }
        AuthenticationController.shared.deauthenticateUser()
        logoutTransition()
    }
    @IBAction func editProfileButtonTapped(_ sender: Any) {
        editProfileTransition()
    }
    
    
    @IBAction func isWorkingSwitchToggled(_ sender: Any) {
        guard let name = AuthenticationController.shared.genericUser?.name,
            let phone = AuthenticationController.shared.genericUser?.phone,
            let price = AuthenticationController.shared.driver?.price,
            let bio = AuthenticationController.shared.driver?.bio,
            let photo = AuthenticationController.shared.driver?.photoUrl,
            let userLocation = AuthenticationController.shared.genericUser?.location?.latLong else {return}
        
        switch isWorkingSwitch.isOn {
        case true:
            if AuthenticationController.shared.requestedRide == nil {
                AuthenticationController.shared.driver?.isActive = true
                
                UserController().configureDriver(isUpdating: true, name: name, address: nil, email: nil, phoneNumber: phone, price: price.stringValue as NSString, bio: bio, photo: photo, userLocation: userLocation)
            }
        case false:
            AuthenticationController.shared.driver?.isActive = false
            
            UserController().configureDriver(isUpdating: true, name: name, address: nil, email: nil, phoneNumber: phone, price: price.stringValue as NSString, bio: bio, photo: photo, userLocation: userLocation)
        }
    }
    
    //MARK: Private Methods
    @objc
    private func updateViews() {
        guard let ride = AuthenticationController.shared.requestedRide else {return}
        if requestTimeLabel.isHidden == true {
            requestTimeLabel.isHidden = false
            requestTimeLabel.text = ride.name as String
            startVillageLabel.isHidden = false
            //            startVillageLabel.text = ride.
            destinationLabel.isHidden = false
            destinationLabel.text = ride.distance as String
            acceptRideButton.isHidden = false
            rejectRideButton.isHidden = false
        }
    }
    
    private func logoutTransition() {
        let destinationVC = WelcomeViewController()
        present(destinationVC, animated: true, completion: nil)
        
        
    }
    
    //I ran into an error here when I was trying to set the text values for all of the textfields in the destinationVC. I was getting a fatal error telling me that nil was unexpectedly found when a property was unwrapped. This is because the UIElements don't exist right now.
    private func editProfileTransition() {
        let destinationVC = DriverRegistrationViewController()
        guard let driver = AuthenticationController.shared.driver else {return}
        destinationVC.driver = driver
        destinationVC.isUpdating = true
        
        present(destinationVC, animated: true, completion: nil)
    }
    
    private func serviceRideTransition() {
        let destinationVC = ServiceRideViewController()
        guard AuthenticationController.shared.driver != nil,
            AuthenticationController.shared.requestedRide != nil else {return}
        
        present(destinationVC, animated: true, completion: nil)
    }
    
}



