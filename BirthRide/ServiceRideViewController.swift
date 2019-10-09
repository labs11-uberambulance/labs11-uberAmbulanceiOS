//
//  ServiceRideViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 4/17/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit
import MapKit

class ServiceRideViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var startAndDestinationNameLabel: UILabel!
    @IBOutlet weak var rideStatusButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: Private Properties
    private var currentRide: Ride?
    private let networkingController = ABCNetworkingController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentRideInformation()
        

        // Do any additional setup after loading the view.
    }
    
    //MARK: IBActions
    @IBAction func rideStatusButtonTapped(_ sender: Any) {
        guard let token = AuthenticationController.shared.userToken,
        let rideId = currentRide?.rideId else {return}
        
        if rideStatusButton.titleLabel?.text == "Onsite" {
            self.rideStatusButton.isUserInteractionEnabled = false
            networkingController.updateRide(withToken: token, withRideStatus: "arrives", withRideId: rideId) { (error) in
                if let error = error {
                    NSLog("Error in ServiceRideViewController.rideStatusButtonTapped")
                    NSLog(error.localizedDescription)
                    return;
                }
                DispatchQueue.main.async {
                    self.rideStatusButton.setTitle("Drop Off", for: .normal)
                    self.rideStatusButton.isUserInteractionEnabled = true
                }
                
            }
            
        } else if rideStatusButton.titleLabel?.text == "Drop Off" {
            self.rideStatusButton.isUserInteractionEnabled = false
            networkingController.updateRide(withToken: token, withRideStatus: "delivers", withRideId: rideId) { (error) in
                if let error = error {
                    NSLog("Error in ServiceRideViewController.rideStatusButtonTapped")
                    NSLog(error.localizedDescription)
                    return;
                }
                DispatchQueue.main.async {
                    self.rideStatusButton.setTitle("Ride Completed!", for: .normal)
                    self.rideStatusButton.isUserInteractionEnabled = true
                    self.transitionToDriverWorkView()
                }
                
            }
            
        }
    }
    

    //MARK: Private Methods
    private func fetchCurrentRideInformation() {
        
        guard let rideId = AuthenticationController.shared.requestedRide?.rideId,
            let token = AuthenticationController.shared.userToken else {return}
        
        networkingController.fetchRide(withToken: token, withRideID: rideId) { (error, ridesArray) in
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
                self.configureLabels()
            }
        }
    }
    private func configureLabels() {
        guard let rideRequestInfo = AuthenticationController.shared.requestedRide,
        let currentRide = currentRide else {return}
        nameLabel.text = rideRequestInfo.name as String
        phoneLabel.text = rideRequestInfo.phone as String
        if rideStatusButton.titleLabel?.text == "Onsite" {
            startAndDestinationNameLabel.text = currentRide.startName as String
        } else {
            startAndDestinationNameLabel.text = currentRide.destinationName as String
        }
    }
    private func transitionToDriverWorkView() {
        let destinationVC = DriverWorkViewController()
        AuthenticationController.shared.requestedRide = nil
        present(destinationVC, animated: true, completion: nil)
    }
    }
