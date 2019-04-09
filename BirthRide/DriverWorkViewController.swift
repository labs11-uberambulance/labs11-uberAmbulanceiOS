//
//  DriverWorkViewController.swift
//  
//
//  Created by Austin Cole on 4/3/19.
//

import UIKit
import GoogleMaps

class DriverWorkViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var isWorkingSwitch: UISwitch!
    @IBOutlet weak var requestTimeLabel: UILabel!
    @IBOutlet weak var startVillageLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var acceptRideButton: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var rideInformationView: UIView!
    @IBOutlet weak var searchingForRidesLabel: UILabel!
    
    //MARK: Private Properties
    private var ride: RequestedRide? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: Other Properties
    var isSubviewOfSuperview = false
    var loadingView: IndeterminateLoadingView?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isWorkingSwitch.isOn = false
        requestTimeLabel.isHidden = true
        startVillageLabel.isHidden = true
        destinationLabel.isHidden = true
        acceptRideButton.isHidden = true
        searchingForRidesLabel.isHidden = true
        mapView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    //MARK: IBActions
    @IBAction func acceptRideButtonTapped(_ sender: Any) {
        guard let userToken = AuthenticationController.shared.userToken,
            let rideId = self.ride?.rideId else {return}
        ABCNetworkingController().driverAcceptsOrRejectsRide(withToken: userToken, withRideId: rideId, withDidAccept: true) { (error) in
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
        ABCNetworkingController().driverAcceptsOrRejectsRide(withToken: userToken, withRideId: rideId, withDidAccept: false) { (error) in
            if let error = error {
                NSLog("Error in DriverWorkVC.acceptRideButtonTapped")
                NSLog(error.localizedDescription)
                return
            }
        }
    }
    
    @IBAction func isWorkingSwitchToggled(_ sender: Any) {
        switch isWorkingSwitch.isOn {
        case true:
            if ride == nil {
                animateLoadingView()
                searchingForRidesLabel.isHidden = false
                AuthenticationController.shared.driver?.isActive = true
                UserController().updateDriver(viewController: self, name: nil, address: nil, email: nil, phoneNumber: nil, priceString: nil, bio: nil, photo: nil)
            }
        case false:
            if mapView.isHidden == true {
                stopAnimatingLoadingView()
                searchingForRidesLabel.isHidden = true
                AuthenticationController.shared.driver?.isActive = false
                
                UserController().updateDriver(viewController: self, name: nil, address: nil, email: nil, phoneNumber: nil, priceString: nil, bio: nil, photo: nil)
            }
        }
    }
    
    //MARK: Private Methods
    private func updateViews() {
        configureLabels()
        configureMapView()
    }
    private func configureMapView() {
        guard let ride = ride else {return}
        if mapView.isHidden == true {
        mapView.isHidden = false
        }
        else {
            mapView.isHidden = true
        }
        let camera = GMSCameraPosition.camera(withLatitude: 1.360511, longitude: 36.847888, zoom: 6.0)
        mapView.animate(to: camera)
        
        let userMarker = GMSMarker()
        userMarker.icon = GMSMarker.markerImage(with: .blue)
        userMarker.position = CLLocationManager().location?.coordinate ?? CLLocationCoordinate2D(latitude: 1.5, longitude: 36.9)
        userMarker.map = mapView
        
    }
    private func configureLabels() {
        guard let ride = ride else {return}
        if requestTimeLabel.isHidden == true {
            requestTimeLabel.isHidden = false
            requestTimeLabel.text = ride.price.stringValue
            startVillageLabel.isHidden = false
            startVillageLabel.text = ride.hospital as String
            destinationLabel.isHidden = false
            destinationLabel.text = ride.distance as String
            acceptRideButton.isHidden = false
            searchingForRidesLabel.isHidden = false
        }
    }
    
    
}
