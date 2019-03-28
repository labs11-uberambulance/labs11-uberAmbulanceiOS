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

class ConfirmRideViewController: UIViewController {
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
        configureMapView()
        configureLabels()
        
        // Do any additional setup after loading the view.
    }
    //MARK: IBActions
    @IBAction func requestRideButtonTapped(_ sender: Any) {
        let destinationVC = MotherRideStatusViewController()
        destinationVC.pregnantMom = self.pregnantMom
        self.present(destinationVC, animated: true) {
        }
    }
    
    private func configureMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: 1.360511, longitude: 36.847888, zoom: 6.0)
        mapView.camera = camera
        let driverMarker = GMSMarker()
        driverMarker.position = CLLocationCoordinate2D(latitude: driver?["latitude"] as! CLLocationDegrees, longitude: driver?["longitude"] as! CLLocationDegrees)
        driverMarker.map = mapView
    }
    private func configureLabels() {
        estimatedPickupTimeLabel.text = "5 minutes"
        estimatedFareLabel.text = driver?["rateAndDistance"] as? String
        fareLabel.text = driver?["name"] as? String
    }
}
