//
//  ConfirmRideViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/21/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces

class RequestRideViewController: UIViewController, CLLocationManagerDelegate {
    //MARK: Private Properties
    private var driversArray: [Driver] = [] {
        didSet {
            DispatchQueue.main.async {
            self.configureMapView()
            self.configureLabels()
            }
        }
    }
    private var count = 0
    private let authenticationController = AuthenticationController.shared
    //MARK: Other Properties
    var pregnantMom: PregnantMom?
    let locationManager = CLLocationManager()
    //MARK: IBOutlets
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var estimatedPickupTimeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var estimatedFareLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let pregnantMomStart = authenticationController.pregnantMom?.start
        
        
        guard let latLongArray = pregnantMomStart?.latLong?.components(separatedBy: ",") as [NSString]? else {return}
        
        
        
        fetchDrivers(latitude: (latLongArray[0].doubleValue), longitude: (latLongArray[1].doubleValue))
        
    }
    //MARK: IBActions
    @IBAction func logoutButtonTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            NSLog("Sign out successful")
        } catch let signOutError as NSError {
            NSLog("Error signing out: %@", signOutError)
        }
        
        AuthenticationController.shared.deauthenticateUser()
        logoutTransition()
    }
    @IBAction func editProfileButtonTapped(_ sender: Any) {
        editProfileTransition()
    }
    
    
    @IBAction func requestRideButtonTapped(_ sender: Any) {
        guard let userToken = AuthenticationController.shared.userToken,
            let mother = AuthenticationController.shared.pregnantMom,
            let user = AuthenticationController.shared.genericUser else {return}
        ABCNetworkingController().requestDriver(withToken: userToken, with: driversArray[count], withMother: mother, with: user) { (error) in
            if let error = error {
                NSLog("error in RequestRideViewController.requestRideButtonTapped")
                NSLog(error.localizedDescription)
                return
            }
        }
    }
    @IBAction func nextDriverButtonTapped(_ sender: Any) {
        guard driversArray.count > 0 else {return}
        if count == driversArray.count - 1 {
            count = 0
        } else {
            count += 1
        }
        configureLabels()
        //Call configureMapView again to update the map with a marker where the driver is located
        configureMapView()
    }
    @IBAction func lastDriverButtonTapped(_ sender: Any) {
        guard driversArray.count > 0 else {return}
        if count == 0 {
            count = driversArray.count - 1
        } else {
            count -= 1
        }
        configureLabels()
        configureMapView()
    }
    
    
    
    
    
    
    //MARK: Private Methods
    private func configureMapView() {
        
        guard let latLongString = authenticationController.pregnantMom?.start?.latLong,
        let destLatLongString = authenticationController.pregnantMom?.destination?.latLong else {return}
        
        let camera = GMSCameraPosition.camera(withLatitude: 1.360511, longitude: 36.847888, zoom: 6.0)
        mapView.animate(to: camera)
        
        let latLongArray = latLongString.components(separatedBy: ",")
        let destLatLongArray = latLongString.components(separatedBy: ",")
        
        let latitude = UserController().stringToInt(intString: latLongArray[0] as String, viewController: self)
        let destLatitude = UserController().stringToInt(intString: destLatLongArray[0] as String, viewController: self)
        
        let longitude = UserController().stringToInt(intString: latLongArray[1] as String, viewController: self)
        let destLongitude = UserController().stringToInt(intString: destLatLongArray[1] as String, viewController: self)
        
        let destinationMarker = GMSMarker()
        destinationMarker.icon = GMSMarker.markerImage(with: .red)
        destinationMarker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(destLatitude), longitude: CLLocationDegrees(destLongitude))
        destinationMarker.map = mapView
        
        
        let userMarker = GMSMarker()
        userMarker.icon = GMSMarker.markerImage(with: .blue)
        userMarker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        userMarker.map = mapView
        
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2D(latitude: CLLocationDegrees(destLatitude), longitude: CLLocationDegrees(destLongitude)))
        path.add(CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude)))
        
        let line = GMSPolyline.init(path: path)
        line.map = mapView
        
        
    }
    
    private func configureLabels() {
        guard let price = driversArray[count].price,
            let duration = driversArray[count].duration,
            let name = driversArray[count].requestedDriverName else {return}
        estimatedPickupTimeLabel.text = "Estimated Pickup Time: \(duration)"
        estimatedFareLabel.text = "Estimated Fare: \(price)"
        nameLabel.text = name as String
    }
    
    
    private func fetchDrivers(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        guard let token = AuthenticationController.shared.userToken,
        let mother = AuthenticationController.shared.pregnantMom else {return}
        
        ABCNetworkingController().fetchNearbyDrivers(withToken: token, withMother: mother, withCompletion: { (error, fetchedDriversArray)  in
            if let error = error {
                NSLog(error.localizedDescription)
                return
            }
            guard let driversArray = fetchedDriversArray else {
                return
            }
            self.driversArray = driversArray
        })
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
    
    private func editProfileTransition() {
        let destinationVC = MotherOrCaretakerRegistrationViewController()
        guard let mother = AuthenticationController.shared.pregnantMom else {return}
        destinationVC.mother = mother
        destinationVC.isUpdating = true
        
        present(destinationVC, animated: true, completion: nil)
        
        
        
    }
    
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.last else {return}
        let camera = GMSCameraPosition.camera(withLatitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude), zoom: 17.0)
        
        self.mapView?.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Error udpating location in RequestRideViewController.locationManager:didFailWithError:")
        NSLog(error.localizedDescription)
        return
    }
}
