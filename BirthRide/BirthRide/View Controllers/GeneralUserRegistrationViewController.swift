//
//  GeneralUserRegistrationViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/21/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

///This ViewController will be called when the continue button is hit on either the MotherOrCaretakerViewController or the DriverRegistrationViewController. This ViewController contains the rest of the registration fields.
class GeneralUserRegistrationViewController: UIViewController, TransitionBetweenViewControllers {


    //MARK: Other Properties
    var pregnantMom: PregnantMom?
    var driver: Driver?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func addPhotoButton(_ sender: Any) {
    }
    @IBAction func doneButton(_ sender: Any) {
        if pregnantMom == nil {
        transition(userType: UserType.pregnantMom)
        } else {
            transition(userType: UserType.driver)
        }
    }
    
    func transition(userType: UserType?) {
        guard let userType = userType else {return}
        switch userType {
        case .driver:
            break
        case .pregnantMom:
            let destinationVC = RequestOrSearchDriverViewController()
            destinationVC.pregnantMom = self.pregnantMom
            self.present(destinationVC, animated: true) {
            }
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
