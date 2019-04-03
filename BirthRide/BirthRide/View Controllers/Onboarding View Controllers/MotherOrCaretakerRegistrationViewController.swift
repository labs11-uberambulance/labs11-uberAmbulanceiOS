//
//  MotherOrCaretakerViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/21/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

class MotherOrCaretakerRegistrationViewController: UIViewController, TransitionBetweenViewControllers {
    
    //MARK: Private Properties
    private var networkingController = ABCNetworkingController()
    
    //MARK: Other Properties
    
    //MARK: IBOutlets

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var villageTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var caretakerTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        caretakerTextField.isHidden = true
        // Do any additional setup after loading the view.
    }
    @IBAction func caretakerButtonTapped(_ sender: Any) {
        //FIXME: Currently, all of the text fields are hidden until this button is hit.
        caretakerTextField.isHidden = false
    }
    @IBAction func continueButtonTapped(_ sender: Any) {
        guard nameTextField.text != "", villageTextField.text != "", phoneTextField.text != "" else {return}
        guard let user = AuthenticationController.shared.genericUser else {return}

        UserController().updateGenericUser(user: user, name: nameTextField.text, village: villageTextField.text, phone: phoneTextField.text, address: nil, email: nil)

        AuthenticationController.shared.pregnantMom = UserController().configurePregnantMom(viewController: self, dueDate: nil, hospital: nil, caretakerName: caretakerTextField.text)

        transition(userType: nil)
    }
    

    //MARK: TransitionBetweenViewControllers Protocol Method
    func transition(userType: UserType?) {
        let destinationVC = RequestRideViewController()
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
