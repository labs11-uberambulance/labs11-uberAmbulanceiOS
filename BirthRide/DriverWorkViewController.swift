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
    private var ride: Ride?
    
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
    }
    
    @IBAction func isWorkingSwitchToggled(_ sender: Any) {
        switch isWorkingSwitch.isOn {
        case true:
            if ride == nil {
                animateLoadingView()
                searchingForRidesLabel.isHidden = false
            }
        case false:
            if rideInformationView.isHidden == true {
                stopAnimatingLoadingView()
            }
        }
    }
    
    //MARK: Private Methods
    private func updateViews() {
        
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
        
    }
    
    
}
