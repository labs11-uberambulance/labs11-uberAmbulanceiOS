//
//  ServiceRideViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 4/17/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit
import GoogleMaps

class ServiceRideViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var startAndDestinationNameLabel: UILabel!
    @IBOutlet weak var rideStatusButton: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    
    //MARK: Private Properties
    private var currentRide: Ride?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentRideInformation()
        

        // Do any additional setup after loading the view.
    }
    
    //MARK: IBActions
    @IBAction func rideStatusButtonTapped(_ sender: Any) {
        if rideStatusButton.titleLabel?.text == "Onsite" {
            rideStatusButton.setTitle("Pick Up", for: .normal)
            
        } else if rideStatusButton.titleLabel?.text == "Pick Up"{
            rideStatusButton.setTitle("Drop Off", for: .normal)
            configureMapView()
            
        } else if rideStatusButton.titleLabel?.text == "Drop Off" {
            
        }
    }
    

    //MARK: Private Methods
    private func fetchCurrentRideInformation() {
        
        guard let rideId = AuthenticationController.shared.requestedRide?.rideId,
            let token = AuthenticationController.shared.userToken else {return}
        
        ABCNetworkingController().fetchRide(withToken: token, withRideID: rideId) { (error, ridesArray) in
            if let error = error {
                NSLog("Error in ServiceRideViewController.fetchCurrentRideInformation")
                NSLog(error.localizedDescription)
                return
        }
            if ridesArray.count == 0 {
                NSLog("ridesArray is equal to nil in ServiceRideViewController.fetchCurrentRideInformation")
                return
            }
            let currentRide = ridesArray.filter{$0.rideId == rideId}
            self.currentRide = currentRide[0]
            DispatchQueue.main.async {
                self.configureMapView()
            }
        }
    }
    private func configureMapView() {
        mapView.clear()
        guard let currentRide = currentRide,
        let driverLatLong = AuthenticationController.shared.driver?.location?.latLong else {return}
        
        let driverLatLongArray = driverLatLong.components(separatedBy: ",")
        let startLatLongArray = currentRide.start.components(separatedBy: ",")
        let destLatLongArray = currentRide.destination.components(separatedBy: ",")
        
        let drivertLatitude = UserController().stringToInt(intString: driverLatLongArray[0], viewController: self)
        let driverLongitude = UserController().stringToInt(intString: driverLatLongArray[1], viewController: self)
        
        let startLatitude = UserController().stringToInt(intString: startLatLongArray[0], viewController: self)
        let startLongitude = UserController().stringToInt(intString: startLatLongArray[1], viewController: self)
        
        let destLatitude = UserController().stringToInt(intString: destLatLongArray[0], viewController: self)
        let destLongitude = UserController().stringToInt(intString: destLatLongArray[1], viewController: self)
        
        if rideStatusButton.titleLabel?.text == "Pick Up" {
            let driverMapMarker = GMSMarker()
            driverMapMarker.icon = GMSMarker.markerImage(with: .red)
            driverMapMarker.position = CLLocationCoordinate2D(latitude: drivertLatitude, longitude: driverLongitude)
            driverMapMarker.map = mapView
            
            let camera = GMSCameraPosition(latitude: driverMapMarker.position.latitude, longitude: driverMapMarker.position.longitude, zoom: 6.0)
            mapView.animate(to: camera)
            
            let startMapMarker = GMSMarker()
            startMapMarker.icon = GMSMarker.markerImage(with: .blue)
            startMapMarker.position = CLLocationCoordinate2D(latitude: startLatitude, longitude: startLongitude)
            startMapMarker.map = mapView
        } else if rideStatusButton.titleLabel?.text == "Onsite"{
            let driverMapMarker = GMSMarker()
            driverMapMarker.icon = GMSMarker.markerImage(with: .red)
            driverMapMarker.position = CLLocationCoordinate2D(latitude: startLatitude, longitude: startLongitude)
            driverMapMarker.map = mapView
            
            let camera = GMSCameraPosition(latitude: driverMapMarker.position.latitude, longitude: driverMapMarker.position.longitude, zoom: 6.0)
            mapView.animate(to: camera)
            
            let destMapMarker = GMSMarker()
            destMapMarker.icon = GMSMarker.markerImage(with: .blue)
            destMapMarker.position = CLLocationCoordinate2D(latitude: destLatitude, longitude: destLongitude)
            destMapMarker.map = mapView
        }
    }
    private func transitionToDriverWorkView() {
        let destinationVC = DriverWorkViewController()
        AuthenticationController.shared.requestedRide = nil
        present(destinationVC, animated: true, completion: nil)
    }
}
