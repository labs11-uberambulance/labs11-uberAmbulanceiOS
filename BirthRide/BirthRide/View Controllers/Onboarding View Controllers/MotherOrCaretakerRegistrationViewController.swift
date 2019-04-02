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
    @IBOutlet weak var dueDateTextField: UITextField!
    @IBOutlet weak var hospitalTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var careTakerTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        careTakerTextField.isHidden = true
        // Do any additional setup after loading the view.
    }
    @IBAction func caretakerButtonTapped(_ sender: Any) {
        careTakerTextField.isHidden = false
    }
    @IBAction func continueButtonTapped(_ sender: Any) {
        guard nameTextField.text != "", villageTextField.text != "", phoneTextField.text != "" else {return}
        guard let user = AuthenticationController.shared.genericUser else {return}

        UserController().updateGenericUser(user: user, name: nameTextField.text, village: villageTextField.text, phone: phoneTextField.text, address: descriptionTextView.text, email: nil)

        AuthenticationController.shared.pregnantMom = UserController().configurePregnantMom(user: user, viewController: self, dueDate: dueDateTextField.text, hospital: hospitalTextField.text, caretakerName: careTakerTextField.text)

        transition(userType: nil)
    }
    

    //MARK: TransitionBetweenViewControllers Protocol Method
    func transition(userType: UserType?) {
        let destinationVC = RequestOrSearchDriverViewController()
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
