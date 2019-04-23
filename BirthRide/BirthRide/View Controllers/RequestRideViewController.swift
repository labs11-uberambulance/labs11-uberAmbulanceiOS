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
            self.configureDriverMarkers()
            self.tableView.reloadData()
            }
        }
    }
    private let authenticationController = AuthenticationController.shared
    //MARK: Other Properties
    var pregnantMom: PregnantMom?

    //MARK: IBOutlets
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureMapView()
        
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
        destinationMarker.icon = GMSMarker.markerImage(with: .blue)
        destinationMarker.position = CLLocationCoordinate2D(latitude: destLatitude, longitude: destLongitude)
        destinationMarker.map = mapView
        
        
        let userMarker = GMSMarker()
        userMarker.icon = GMSMarker.markerImage(with: .red)
        userMarker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        userMarker.map = mapView
        
        
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2D(latitude: CLLocationDegrees(destLatitude), longitude: CLLocationDegrees(destLongitude)))
        path.add(CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude)))
        
        let line = GMSPolyline.init(path: path)
        line.strokeColor = .green
        line.map = mapView
        
        
    }
    
    //The profile pictures of the drivers need to be resized in order to be used as icons for the markers. Some of the images are enormous.
    private func configureDriverMarkers() {
        for driver in driversArray {
            guard let latLongString = driver.location?.latLong,
            let name = driver.requestedDriverName,
            let price = driver.price,
            let duration = driver.duration else{ return}
            
            let latLongArray = latLongString.components(separatedBy: ",")
            
            let latitude = UserController().stringToInt(intString: latLongArray[0], viewController: self)
            let longitude = UserController().stringToInt(intString: latLongArray[1], viewController: self)
            
            let driverMarker = GMSMarker()
            driverMarker.icon = GMSMarker.markerImage(with: .orange)
            driverMarker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            driverMarker.map = mapView
            driverMarker.title = name as String
            driverMarker.snippet = "Price: \(price.stringValue), Duration: \(duration)"
            
        }
    }
    
    private func fetchDrivers(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        guard let token = AuthenticationController.shared.userToken,
        let mother = AuthenticationController.shared.pregnantMom else {return}
        
        ABCNetworkingController().fetchNearbyDrivers(withToken: token, withMother: mother, withCompletion: { (error, fetchedDriversArray, didHaveSuccess)  in
            if let error = error {
                NSLog(error.localizedDescription)
                return
            }
            guard let driversArray = fetchedDriversArray else {
                if didHaveSuccess {
                    DispatchQueue.main.async {
                    self.showNoDriversInAreaAlert()
                    }
                }
                return
            }
            self.driversArray = driversArray
        })
    }
    private func logoutTransition() {
        let destinationVC = WelcomeViewController()
        present(destinationVC, animated: true, completion: nil)
    }
    
    private func editProfileTransition() {
        let destinationVC = MotherOrCaretakerRegistrationViewController()
        guard let mother = AuthenticationController.shared.pregnantMom else {return}
        destinationVC.mother = mother
        destinationVC.isUpdating = true
        
        present(destinationVC, animated: true, completion: nil)
    }
    
    private func showNoDriversInAreaAlert() {
        let alertController = UIAlertController()
        alertController.title = "No Available Drivers"
        alertController.message = "It appears that there are no available drivers in your area. Please try again in a few minutes or call <BACKUP_HOTLINE_NUMBER_HERE> for assistance. Thank you for your patience."
        alertController.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func showWeWillTextYouSoonAlert() {
        let alertController = UIAlertController()
        alertController.title = "Stay Tuned"
        alertController.message = "We have sent a ride request to the selected driver. If the driver does not respond we will send the ride request to another nearby driver who charges a similar price. We will send a text to the phone number that you provided with more information as soon as a driver is on the way. Thank you for choosing BirthRide."
        alertController.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func requestDriverButtonTapped(sender: UIButton) {
        guard let token = authenticationController.userToken,
        let mother = authenticationController.pregnantMom,
        let user = authenticationController.genericUser else {return}
        let driver = driversArray[sender.tag]
        ABCNetworkingController().requestDriver(withToken: token, with: driver, withMother: mother, with: user) { (error) in
            if let error = error {
                NSLog("Error in RequestRideViewController.requestDriverButtonTapped")
                NSLog(error.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                sender.isUserInteractionEnabled = false
                self.tableView.isUserInteractionEnabled = false
                self.showWeWillTextYouSoonAlert()
            }
        }
    }

    
    
    
    //MARK: TableView Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return driversArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ReuseIdentifier")
        
        guard let name = driversArray[indexPath.row].requestedDriverName,
        let price = driversArray[indexPath.row].price,
        let duration = driversArray[indexPath.row].duration,
            let distance = driversArray[indexPath.row].distance else {return cell}
            
        
        cell.imageView?.image = getImage(index: indexPath.row)
        
        cell.textLabel?.text = name as String
        
        cell.detailTextLabel?.text = "Driver Name: \(name), Price: \(price) Distance: \(distance), Duration: \(duration)"
        
        let requestRideButton = UIButton(type: .roundedRect)
        requestRideButton.setTitle("Request Ride", for: .normal)
        requestRideButton.setTitle("Ride Requested", for: .disabled)
        requestRideButton.setTitleColor(.orange, for: .normal)
        requestRideButton.setTitleColor(.orange, for: .disabled)
        requestRideButton.addTarget(self, action: #selector(requestDriverButtonTapped(sender:)), for: .touchUpInside)
        requestRideButton.tag = indexPath.row
        
        requestRideButton.frame = CGRect(x: Double(cell.frame.width) - 80, y: Double(cell.center.y) - 25, width: 150, height: 50)
        
        cell.translatesAutoresizingMaskIntoConstraints = false
        
        cell.addSubview(requestRideButton)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
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
