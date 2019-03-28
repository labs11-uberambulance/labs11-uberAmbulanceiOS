//
//  RequestOrSearchDriverViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/21/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

class RequestOrSearchDriverViewController: UIViewController {
    //MARK: Other Properties
    var pregnantMom: PregnantMom?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func requestADriverTapped(_ sender: Any) {
        let destinationVC = ConfirmRideViewController()
        destinationVC.pregnantMom = self.pregnantMom
        self.present(destinationVC, animated: true)
    }
    @IBAction func searchForDriverTapped(_ sender: Any) {
        let destinationVC = SearchForDriverViewController()
        destinationVC.pregnantMom = self.pregnantMom
        self.present(destinationVC, animated: true) {
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
