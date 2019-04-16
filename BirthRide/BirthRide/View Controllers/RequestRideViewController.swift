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

class RequestRideViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    //MARK: Private Properties
    private var driversArray: [Driver] = [] {
        didSet {
            DispatchQueue.main.async {
            self.configureMapView()
            self.configureDriverMarkers()
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
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        tableView.delegate = self
        tableView.dataSource = self
        
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
    //MARK: Private Methods
    private func configureMapView() {
        
        guard let latLongString = authenticationController.pregnantMom?.start?.latLong,
        let destLatLongString = authenticationController.pregnantMom?.destination?.latLong else {return}
        
        
        let latLongArray = latLongString.components(separatedBy: ",")
        let destLatLongArray = destLatLongString.components(separatedBy: ",")
        
        let latitude = UserController().stringToInt(intString: latLongArray[0] as String, viewController: self)
        let destLatitude = UserController().stringToInt(intString: destLatLongArray[0] as String, viewController: self)
        
        let longitude = UserController().stringToInt(intString: latLongArray[1] as String, viewController: self)
        let destLongitude = UserController().stringToInt(intString: destLatLongArray[1] as String, viewController: self)
        
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 6.0)
        mapView.animate(to: camera)
        
        
        let destinationMarker = GMSMarker()
        destinationMarker.icon = GMSMarker.markerImage(with: .red)
        destinationMarker.position = CLLocationCoordinate2D(latitude: destLatitude, longitude: destLongitude)
        destinationMarker.map = mapView
        
        
        let userMarker = GMSMarker()
        userMarker.icon = GMSMarker.markerImage(with: .blue)
        userMarker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        userMarker.map = mapView
        
        
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2D(latitude: CLLocationDegrees(destLatitude), longitude: CLLocationDegrees(destLongitude)))
        path.add(CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude)))
        
        let line = GMSPolyline.init(path: path)
        line.strokeColor = .green
        line.map = mapView
        
        
    }
    
    private func configureDriverMarkers() {
        for driver in driversArray {
            guard let latLongString = driver.location?.latLong,
            let name = driver.requestedDriverName,
            let price = driver.price,
                let profileImage = getImage(index: driversArray.firstIndex(of: driver)!) else{ return}
            
            let latLongArray = latLongString.components(separatedBy: ",")
            
            let latitude = UserController().stringToInt(intString: latLongArray[0], viewController: self)
            let longitude = UserController().stringToInt(intString: latLongArray[1], viewController: self)
            
            let driverMarker = GMSMarker()
            driverMarker.icon = profileImage
            driverMarker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            driverMarker.map = mapView
            driverMarker.title = name as String
            driverMarker.snippet = price.stringValue
            
        }
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
    
    
    
    
    //MARK: TableView Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return driversArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseIdentifier"),
        let name = driversArray[indexPath.row].requestedDriverName,
        let price = driversArray[indexPath.row].price,
        let duration = driversArray[indexPath.row].duration,
        let distance = driversArray[indexPath.row].distance else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: "ReuseIdentifier")
        }
        
        cell.imageView?.image = getImage(index: indexPath.row)
        
        cell.textLabel?.text = name as String
        
        cell.detailTextLabel?.text = "Driver Name: \(name), Price: \(price) Distance: \(distance), Duration: \(duration)"
        
        return cell
    }
    
    //MARK: TableView Delegate Private Helper Methods
    private func getImage(index: Int) -> UIImage? {
        guard let urlString = driversArray[index].photoUrl else {return nil}
        guard let url = URL(string: urlString as String) else {return nil}
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            NSLog("Error getting driver profile image in RequestRideViewController.getImage")
            NSLog(error.localizedDescription)
            return nil
        }
        return UIImage(data: data)
        
    }
}
