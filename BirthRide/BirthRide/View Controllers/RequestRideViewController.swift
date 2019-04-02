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

class RequestRideViewController: UIViewController {
    //MARK: Other Properties
    var pregnantMom: PregnantMom?
    var driver: [String: Any]?
    //MARK: IBOutlets
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var estimatedPickupTimeLabel: UILabel!
    @IBOutlet weak var fareLabel: UILabel!
    @IBOutlet weak var estimatedFareLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ABCNetworkingController().fetchNearbyDrivers(withLatitude: 3, withLongitude: 3) { (error) in
            if let error = error {
                NSLog(error.localizedDescription)
                return
            }
            DispatchQueue.main.async {
            self.configureMapView()
            self.configureLabels()
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    //MARK: IBActions
    @IBAction func requestRideButtonTapped(_ sender: Any) {
        guard let userToken = AuthenticationController.shared.userToken else {return}
        ABCNetworkingController().createRide(withToken: userToken) { (error) in
        }
    }
    
    private func configureMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: 1.360511, longitude: 36.847888, zoom: 6.0)
        mapView.camera = camera
        
        let driverMarker = GMSMarker()
        driverMarker.position = CLLocationCoordinate2D(latitude: driver?["latitude"] as! CLLocationDegrees, longitude: driver?["longitude"] as! CLLocationDegrees)
        driverMarker.map = mapView
        
        let userMarker = GMSMarker()
        userMarker.icon = GMSMarker.markerImage(with: .blue)
        userMarker.position = CLLocationManager().location?.coordinate ?? CLLocationCoordinate2D(latitude: 1.5, longitude: 36.9)
        userMarker.map = mapView
    }
    private func configureLabels() {
        estimatedPickupTimeLabel.text = "5 minutes"
        estimatedFareLabel.text = driver?["rateAndDistance"] as? String
        fareLabel.text = driver?["name"] as? String
    }
}
