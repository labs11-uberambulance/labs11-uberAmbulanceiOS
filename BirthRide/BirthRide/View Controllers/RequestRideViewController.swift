//
//  ConfirmRideViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/21/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit
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
        
        if AuthenticationController.shared.pregnantMom?.start?.latLong != nil {
            let latLongArray = AuthenticationController.shared.pregnantMom?.start?.latLong?.components(separatedBy: ",") as? [NSString]
            
            
            
            fetchDrivers(latitude: (latLongArray?[0].doubleValue)!, longitude: (latLongArray?[1].doubleValue)!)
        }
        
        
        
        
        // Do any additional setup after loading the view.
    }
    //MARK: IBActions
    @IBAction func requestRideButtonTapped(_ sender: Any) {
        guard let userToken = AuthenticationController.shared.userToken,
            let mother = AuthenticationController.shared.pregnantMom,
            let user = AuthenticationController.shared.genericUser else {return}
//        ABCNetworkingController().requestDriver(withToken: userToken, with: driversArray[count], withMother: mother, with: user) { (error) in
//            if let error = error {
//                NSLog("error in RequestRideViewController.requestRideButtonTapped")
//                NSLog(error.localizedDescription)
//                return
//            }
//        }
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
    
    
    
    
    
    
    
    private func configureMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: 1.360511, longitude: 36.847888, zoom: 6.0)
        mapView.animate(to: camera)
        
        let userMarker = GMSMarker()
        userMarker.icon = GMSMarker.markerImage(with: .blue)
        userMarker.position = CLLocationManager().location?.coordinate ?? CLLocationCoordinate2D(latitude: 1.5, longitude: 36.9)
        userMarker.map = mapView
    }
    
    private func configureLabels() {
        guard let price = driversArray[count].price else {return}
        estimatedPickupTimeLabel.text = "Estimated Pickup Time: 5 minutes"
        estimatedFareLabel.text = "Estimated Fare: \(price)"
        nameLabel.text = "Frederick"
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
