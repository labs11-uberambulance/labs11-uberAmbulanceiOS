//
//  ConfirmRideViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/21/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class RequestRideViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Private Properties
    private var driversArray: [Driver] = [] {
        didSet {
            DispatchQueue.main.async {
            self.tableView.reloadData()
            }
        }
    }
    private var buttonsArray: [UIButton] = []
    private let authenticationController = AuthenticationController.shared
    
    private var imageViewArray: [UIImageView] = []
    private var profileImageView = UIImageView()
    
    private let photoFetchQueue = OperationQueue()
    private let cache = Cache<NSNumber, UIImage>()
    private var operations = [NSNumber : Operation]()
    
    //MARK: Other Properties
    var pregnantMom: PregnantMom?

    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
            mapView.isUserInteractionEnabled = false
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
        
        configureCell(cell: cell, imageView: profileImageView, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        
    }
    
    //MARK: TableView Delegate Private Helper Methods
    private func configureImageView(cell: UITableViewCell, index: Int) {
        let profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: cell.frame.height))
        
        if profileImageView.image == nil {
            profileImageView.image = UIImage(named: "placeholder_image")
        }
        profileImageView.contentMode = .scaleAspectFit
        
        cell.addSubview(profileImageView)
        self.profileImageView = profileImageView
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
    
    private func configureCell(cell: UITableViewCell, imageView: UIImageView, indexPath: IndexPath) {
        configureImageView(cell: cell, index: indexPath.row)
        loadImage(forCell: cell, forImageView: imageView, forCellAt: indexPath)
        configureTextLabel(cell: cell, index: indexPath.row)
        configureButton(cell: cell, index: indexPath.row)
    }
    
    private func loadImage(forCell cell: UITableViewCell, forImageView imageView: UIImageView, forCellAt indexPath: IndexPath) {
        let driver = driversArray[indexPath.row]
        guard let driverId = driver.driverId else {return}
        // Check for image in cache
        if let cachedImage = cache.value(for: driverId) {
            imageView.image = cachedImage
            return
        }
        
        // Start an operation to fetch image data
        let fetchOp = FetchPhotoOperation(driver: driver)
        let cacheOp = BlockOperation {
            if let image = fetchOp.image {
                self.cache.cache(value: image, for: driverId)
            }
        }
        let completionOp = BlockOperation {
            defer { self.operations.removeValue(forKey: driverId) }
            
            if let currentIndexPath = self.tableView?.indexPath(for: cell),
                currentIndexPath != indexPath {
                return // Cell has been reused
            }
            
            if let image = fetchOp.image {
                imageView.image = image
            }
        }
        
        cacheOp.addDependency(fetchOp)
        completionOp.addDependency(fetchOp)
        
        photoFetchQueue.addOperation(fetchOp)
        photoFetchQueue.addOperation(cacheOp)
        OperationQueue.main.addOperation(completionOp)
        
        operations[driverId] = fetchOp
    }
}
