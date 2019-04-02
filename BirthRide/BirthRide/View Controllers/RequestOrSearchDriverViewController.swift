//
//  RequestOrSearchDriverViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/21/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

class RequestOrSearchDriverViewController: UIViewController {
    //MARK: Private Properties
    private let dummyArrayOfDrivers = [["latitude": 0.327825,
                                        "longitude": 39.022479,
                                        "name": "Frederick",
                                        "rateAndDistance": "$10, 2km"
        ], ["latitude": 1.488886,
            "longitude": 37.036951,
            "name": "Connor",
            "rateAndDistance": "$8.50, 1.5km"
        ], ["latitude": 0.471944,
            "longitude": 36.453422,
            "name": "Samuel",
            "rateAndDistance": "$11, 0.75km"
        ]]
    //MARK: Other Properties
    var pregnantMom: PregnantMom?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func requestADriverTapped(_ sender: Any) {
        let destinationVC = ConfirmRideViewController()
        destinationVC.pregnantMom = self.pregnantMom
        destinationVC.driver = findNearestDriver()
        self.present(destinationVC, animated: true)
    }
    @IBAction func searchForDriverTapped(_ sender: Any) {
        let destinationVC = SearchForDriverViewController()
        destinationVC.pregnantMom = self.pregnantMom
        self.present(destinationVC, animated: true) {
        }
    }
    
    private func findNearestDriver() -> [String: Any] {
        return dummyArrayOfDrivers.randomElement()!
    }
}
