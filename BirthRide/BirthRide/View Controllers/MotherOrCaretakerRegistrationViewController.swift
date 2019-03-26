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
    private var pregnantMom: PregnantMom?
    
    //MARK: IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var villageTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var dueDateTextField: UITextField!
    @IBOutlet weak var hospitalTextField: UITextField!
    @IBOutlet weak var caretakerTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        caretakerTextField.isHidden = true
        // Do any additional setup after loading the view.
    }
    @IBAction func caretakerButtonTapped(_ sender: Any) {
        caretakerTextField.isHidden = false
    }
    @IBAction func continueButtonTapped(_ sender: Any) {
        guard nameTextField != nil, villageTextField != nil, phoneNumberTextField != nil else {return}
        pregnantMom = PregnantMom(name: nameTextField.text!, description: <#T##String#>, village: villageTextField.text!, phoneNumber: phoneNumberTextField.text!, dueDate: <#T##String#>, hospital: <#T##String#>, caretakerName: <#T##String#>, profilePicture: <#T##UIImage#>, userID: <#T##Int?#>, googleID: <#T##String?#>, userType: <#T##UserType#>)
        transition(userType: nil)
    }
    

    //MARK: TransitionBetweenViewControllers Protocol Method
    func transition(userType: UserType?) {
        let generalUserRegistrationViewController = GeneralUserRegistrationViewController()
        generalUserRegistrationViewController.pregnantMom = pregnantMom
        self.present(generalUserRegistrationViewController, animated: true) {
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
