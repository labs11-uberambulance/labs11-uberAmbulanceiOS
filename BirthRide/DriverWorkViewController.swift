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
    @IBOutlet weak var rideInformationView: UIView!
    @IBOutlet weak var searchingForRidesLabel: UILabel!
    @IBOutlet weak var pastRidesTableView: UITableView!
    @IBOutlet weak var rejectRideButton: UIButton!
    //MARK: Private Properties
    
    
    //MARK: Other Properties
    var isSubviewOfSuperview = false
    var loadingView: IndeterminateLoadingView?
    var ride: RequestedRide? {
        didSet {
            updateViews()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isWorkingSwitch.isOn = false
        requestTimeLabel.isHidden = true
        startVillageLabel.isHidden = true
        destinationLabel.isHidden = true
        acceptRideButton.isHidden = true
        rejectRideButton.isHidden = true
        searchingForRidesLabel.isHidden = true
        pastRidesTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if isWorkingSwitch.isOn && ride == nil {
            animateLoadingView()
            searchingForRidesLabel.isHidden = false
            requestTimeLabel.isHidden = true
            startVillageLabel.isHidden = true
            destinationLabel.isHidden = true
            acceptRideButton.isHidden = true
            rejectRideButton.isHidden = true
        } else if ride != nil {
            searchingForRidesLabel.isHidden = true
            requestTimeLabel.isHidden = false
            startVillageLabel.isHidden = false
            destinationLabel.isHidden = false
            acceptRideButton.isHidden = false
            rejectRideButton.isHidden = false
        } else if !isWorkingSwitch.isOn {
            searchingForRidesLabel.isHidden = true
            requestTimeLabel.isHidden = true
            startVillageLabel.isHidden = true
            destinationLabel.isHidden = true
            acceptRideButton.isHidden = true
            rejectRideButton.isHidden = true
        }
    }
    
    //MARK: IBActions
    @IBAction func acceptRideButtonTapped(_ sender: Any) {
        guard let userToken = AuthenticationController.shared.userToken,
            let rideId = self.ride?.rideId else {return}
        ABCNetworkingController().driverAcceptsOrRejectsRide(withToken: userToken, withRideId: rideId, withDidAccept: true, withRideData: nil) { (error) in
            if let error = error {
                NSLog("Error in DriverWorkVC.acceptRideButtonTapped")
                NSLog(error.localizedDescription)
                return
            }
        }
        updateViews()
    }
    @IBAction func rejectRideButtonTapped(_ sender: Any) {
        guard let userToken = AuthenticationController.shared.userToken,
            let rideId = self.ride?.rideId else {return}
        ABCNetworkingController().driverAcceptsOrRejectsRide(withToken: userToken, withRideId: rideId, withDidAccept: false, withRideData: ride) { (error) in
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
            let userLocation = AuthenticationController.shared.driver?.location?.latLong else {return}
        
        switch isWorkingSwitch.isOn {
        case true:
            if ride == nil {
                animateLoadingView()
                searchingForRidesLabel.isHidden = false
                AuthenticationController.shared.driver?.isActive = true
                
                UserController().configureDriver(isUpdating: true, name: name, address: nil, email: nil, phoneNumber: phone, price: price.stringValue as NSString, bio: bio, photo: photo, userLocation: userLocation)
            }
        case false:
                stopAnimatingLoadingView()
                searchingForRidesLabel.isHidden = true
                AuthenticationController.shared.driver?.isActive = false
                
                UserController().configureDriver(isUpdating: true, name: name, address: nil, email: nil, phoneNumber: phone, price: price.stringValue as NSString, bio: bio, photo: photo, userLocation: userLocation)
            }
        }
    
    //MARK: Private Methods
    private func updateViews() {
        guard let ride = ride else {return}
        if requestTimeLabel.isHidden == true {
            requestTimeLabel.isHidden = false
            requestTimeLabel.text = ride.price.stringValue
            startVillageLabel.isHidden = false
            startVillageLabel.text = ride.hospital as String
            destinationLabel.isHidden = false
            destinationLabel.text = ride.distance as String
            acceptRideButton.isHidden = false
            rejectRideButton.isHidden = false
            searchingForRidesLabel.isHidden = false
        }
        if requestTimeLabel.isHidden == false {
            requestTimeLabel.isHidden = true
            startVillageLabel.isHidden = true
            destinationLabel.isHidden = true
            acceptRideButton.isHidden = true
            rejectRideButton.isHidden = true
            searchingForRidesLabel.isHidden = true
            animateLoadingView()
        }
    }
    
    private func logoutTransition() {
        let tabBarController = UITabBarController()
        
        let signUpViewController = SignUpViewController()
        
        let signInViewController = SignInViewController()
        
        tabBarController.addChild(signInViewController)
        tabBarController.addChild(signUpViewController)
        
        let signUpItem = UITabBarItem()
        signUpItem.title = "Sign Up"
        let signInItem = UITabBarItem()
        signInItem.title = "Sign In"
        
        signUpViewController.tabBarItem = signUpItem
        signInViewController.tabBarItem = signInItem
        
        present(tabBarController, animated: true, completion: nil)
        
        
    }
    
    //I ran into an error here when I was trying to set the text values for all of the textfields in the destinationVC. I was getting a fatal error telling me that nil was unexpectedly found when a property was unwrapped. This is because the UIElements don't exist right now.
    private func editProfileTransition() {
        let destinationVC = DriverRegistrationViewController()
        guard let driver = AuthenticationController.shared.driver else {return}
        destinationVC.driver = driver
        destinationVC.isUpdating = true
        
        present(destinationVC, animated: true, completion: nil)
        
        
        
    }
}
    
    

