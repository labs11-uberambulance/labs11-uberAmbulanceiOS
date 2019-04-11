//
//  GeneralUserRegistrationViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/21/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

///This ViewController will be called when the continue button is hit on either the MotherOrCaretakerViewController or the DriverRegistrationViewController. This ViewController contains the rest of the registration fields.
class DriverPhotoRegistrationViewController: UIViewController, TransitionBetweenViewControllers, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: Private Properties
    var image: UIImage? {
        didSet {
            updateImageView()
        }
    }

    //MARK: IBOutlets
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: IBActions
    @IBAction func addPhotoButton(_ sender: Any) {
        choosePhoto()
    }
    @IBAction func doneButton(_ sender: Any) {
            transition(userType: UserType.drivers)
    }
    
    //MARK: Private Methods
    private func choosePhoto() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary)  else{
            print("photo library is unavailable")
            return
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    private func updateImageView() {
        photoImageView.image = image
    }
    
    //MARK: UIImagePickerControllerDelegateMethods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        image = info[.originalImage] as? UIImage
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: TransitionBetweenViewControllers methods
    func transition(userType: UserType?) {
        present(DriverWorkViewController(), animated: true, completion: nil)
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
