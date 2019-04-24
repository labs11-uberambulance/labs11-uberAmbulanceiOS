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

class RequestRideViewController: UIViewController, GMSMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    //MARK: Private Properties
    private var driversArray: [Driver] = [] {
        didSet {
            DispatchQueue.main.async {
            self.configureDriverMarkers()
            self.tableView.reloadData()
            }
        }
    }
    private var driverMarkersArray: [GMSMarker]  = []
    private var buttonsArray: [UIButton] = []
    private let authenticationController = AuthenticationController.shared
    
    private var imageViewArray: [UIImageView] = []
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
        
        
        guard let latLongArray = pregnantMomStart?.latLong?.components(separatedBy: ",") as [NSString]?,
        pregnantMomStart?.latLong != "" else {return}
        
        
        
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
        let destLatLongString = authenticationController.pregnantMom?.destination?.latLong,
            latLongString != "",
        destLatLongString != "" else {return}
        
        
        let latLongArray = latLongString.components(separatedBy: ",")
        let destLatLongArray = destLatLongString.components(separatedBy: ",")
        
        let latitude = UserController().stringToInt(intString: latLongArray[0] as String, viewController: self)
        let destLatitude = UserController().stringToInt(intString: destLatLongArray[0] as String, viewController: self)
        
        let longitude = UserController().stringToInt(intString: latLongArray[1] as String, viewController: self)
        let destLongitude = UserController().stringToInt(intString: destLatLongArray[1] as String, viewController: self)
        
        
        
        let destinationMarker = GMSMarker()
        destinationMarker.icon = GMSMarker.markerImage(with: .blue)
        destinationMarker.position = CLLocationCoordinate2D(latitude: destLatitude, longitude: destLongitude)
        destinationMarker.map = mapView
        
        
        let userMarker = GMSMarker()
        userMarker.icon = GMSMarker.markerImage(with: .red)
        userMarker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        userMarker.map = mapView
        
         mapView.animate(to: GMSCameraPosition(latitude: userMarker.position.latitude + 0.04, longitude: userMarker.position.longitude - 0.025, zoom: 13.0))
        
        
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
            driverMarker.isFlat = true
            
            driverMarkersArray.append(driverMarker)
            
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
        
        if mother.didRequestRide == true {
            showWeWillTextYouSoonAlert()
            return
        }
        
        let driver = driversArray[sender.tag]
        tableView.isUserInteractionEnabled = false
        sender.isUserInteractionEnabled = false
        
        for button in buttonsArray {
            button.isEnabled = false
            if button.tag != sender.tag {
                button.isHidden = true
            }
        }
        
        ABCNetworkingController().requestDriver(withToken: token, with: driver, withMother: mother, with: user) { (error) in
            if let error = error {
                NSLog("Error in RequestRideViewController.requestDriverButtonTapped")
                NSLog(error.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.showWeWillTextYouSoonAlert()
            }
            mother.didRequestRide = true
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
        
        let cell = UITableViewCell()
        
        configureCell(cell: cell, index: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for marker in driverMarkersArray {
            marker.isFlat = true
        }
        mapView.selectedMarker = driverMarkersArray[indexPath.row]
        
        //Note the hacky latitude and longitude here. For some reason the map won't center where I want it to, so I had to add in some adjustments.
        mapView.animate(to: GMSCameraPosition(latitude: driverMarkersArray[indexPath.row].position.latitude + 0.04, longitude: driverMarkersArray[indexPath.row].position.longitude - 0.025, zoom: 13.0))
        driverMarkersArray[indexPath.row].isFlat = false
        
    }
    
    //MARK: MapView Delegate Methods
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let index = driverMarkersArray.firstIndex(of: marker) else {return false}
        tableView.selectRow(at: IndexPath(row: index, section: 1), animated: true, scrollPosition: .top)
        
        for marker in driverMarkersArray {
            marker.isFlat = true
        }
        mapView.animate(to: GMSCameraPosition(latitude: marker.position.latitude + 0.04, longitude: marker.position.longitude - 0.025, zoom: 13.0))
        marker.isFlat = false
        
        return true
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
    private func configureImageView(cell: UITableViewCell, index: Int) {
        let profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: cell.frame.height))
        profileImageView.image = getImage(index: index)
        
        if profileImageView.image == nil {
            profileImageView.image = UIImage(named: "placeholder_image")
        }
        profileImageView.contentMode = .scaleAspectFit
        
        cell.addSubview(profileImageView)
    }
    
    private func configureTextLabel(cell: UITableViewCell, index: Int) {
        guard let name = driversArray[index].requestedDriverName else {return}
        
        let nameTextLabel = UILabel(frame: CGRect(x: 58, y: (cell.center.y - 25), width: 150, height: 50))
        
        nameTextLabel.text = name as String
        cell.addSubview(nameTextLabel)
    }
    
    private func configureButton(cell: UITableViewCell, index: Int) {
        let requestRideButton = UIButton(type: .roundedRect)
        requestRideButton.setTitle("Request Ride", for: .normal)
        requestRideButton.setTitle("Ride Requested", for: .disabled)
        requestRideButton.setTitleColor(.orange, for: .normal)
        requestRideButton.setTitleColor(.orange, for: .disabled)
        requestRideButton.addTarget(self, action: #selector(requestDriverButtonTapped(sender:)), for: .touchUpInside)
        requestRideButton.tag = index
        
        requestRideButton.frame = CGRect(x: Double(cell.frame.width) - 150, y: Double(cell.center.y) - 25, width: 150, height: 50)
        
        cell.addSubview(requestRideButton)
        buttonsArray.append(requestRideButton)
    }
    
    private func configureCell(cell: UITableViewCell, index: Int) {
        configureImageView(cell: cell, index: index)
        configureTextLabel(cell: cell, index: index)
        configureButton(cell: cell, index: index)
    }
}
