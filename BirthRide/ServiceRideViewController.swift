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
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
