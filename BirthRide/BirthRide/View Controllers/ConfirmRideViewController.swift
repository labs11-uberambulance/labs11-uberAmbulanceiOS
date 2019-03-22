//
//  ConfirmRideViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/21/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit
import MapKit

class ConfirmRideViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var estimatedPickupTimeLabel: UILabel!
    @IBOutlet weak var fareLabel: UILabel!
    @IBOutlet weak var estimatedFareLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //MARK: IBActions
    @IBAction func requestRideButtonTapped(_ sender: Any) {
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
