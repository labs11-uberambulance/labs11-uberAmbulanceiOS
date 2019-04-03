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
    //MARK: Other Properties
    var pregnantMom: PregnantMom?
    var driver: [String: Any]?
    let locationManager = CLLocationManager()
    //MARK: IBOutlets
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var estimatedPickupTimeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var estimatedFareLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ABCNetworkingController().fetchNearbyDrivers(withLatitude: 3, withLongitude: 3) { (error, driversArray)  in
            if let error = error {
                NSLog(error.localizedDescription)
                return
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
        mapView.animate(to: camera)

        let userMarker = GMSMarker()
        userMarker.icon = GMSMarker.markerImage(with: .blue)
        userMarker.position = CLLocationManager().location?.coordinate ?? CLLocationCoordinate2D(latitude: 1.5, longitude: 36.9)
        userMarker.map = mapView
    }
    
    private func configureLabels() {
        estimatedPickupTimeLabel.text = "Estimated Pickup Time: 5 minutes"
        estimatedFareLabel.text = "Estimated Fare: 10"
        nameLabel.text = "Frederick"
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        
        self.mapView?.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Error udpating location in RequestRideViewController.locationManager:didFailWithError:")
        NSLog(error.localizedDescription)
        return
    }
}
