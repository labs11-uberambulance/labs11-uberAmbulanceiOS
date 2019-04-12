//
//  DriverRegistrationViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/21/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit
import GoogleMaps

class DriverRegistrationViewController: UIViewController, TransitionBetweenViewControllers, GMSMapViewDelegate {
    
    //MARK: Private Properties
    private var userMarkerArray: [GMSMarker] = []
    private var userLocation: NSString?
    
    //MARK: Other Properties
    var driver: Driver?
    var isUpdating: Bool = false
    
    //MARK: IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupKeyboardDismissRecognizer()
        populateLabelsAndTextFields()
        configureMapView()
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        
        guard let name = nameTextField?.text,
            let phoneNumber = phoneNumberTextField.text,
            let price = priceTextField.text,
            let bio = bioTextView.text,
            let user = AuthenticationController.shared.genericUser,
            let userLocation = userLocation else {return}
        
        let otherName = name as NSString
        let otherPhone = phoneNumber as NSString
        let otherPrice = price as NSString
        let otherBio = bio as NSString

        
        UserController().configureDriver(isUpdating: isUpdating, name: otherName, address: nil, email: nil, phoneNumber: otherPhone, price: otherPrice, bio: otherBio, photo: nil, userLocation: userLocation)
        transition(userType: nil)
    }
    
    func transition(userType: UserType?) {
        let driverPhotoRegistrationViewController = DriverPhotoRegistrationViewController()
        self.present(driverPhotoRegistrationViewController, animated: true) {
        }
    }
    
    
    ///This method will create a map marker when the user touches and holds on a position on the mapView. The map marker will **not** be created if one already exists.
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        guard userMarkerArray.count == 0 else {return}
        let userMarker = GMSMarker()
        userMarker.position = coordinate
        userMarker.appearAnimation = .pop
        userMarker.isDraggable = true
        userMarker.map = mapView
        userMarkerArray.append(userMarker)
        userLocation = "\(coordinate.latitude),\(coordinate.longitude)" as NSString
    }
    
    
    //MARK: Private Methods
    private func setupKeyboardDismissRecognizer(){
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))
        
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc
    private func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    private func populateLabelsAndTextFields() {
        if let driver = driver,
            let user = AuthenticationController.shared.genericUser {
            priceTextField.text = driver.price?.stringValue
            bioTextView.text = driver.bio as String?
            phoneNumberTextField.text = user.phone as String?
            nameTextField.text = user.name as String?
        }
    }
    
    ///This method will configure the mapView. If the app is able to get the user coordinates, then it will also create a marker to put on the map. If not it will return. The map marker will **not** be created if one already exists.
    private func configureMapView() {
        let userMarker = GMSMarker()
        guard let userLocation = AuthenticationController.shared.genericUser?.location?.latLong else {return}
        self.userLocation = userLocation
        let latLongArray = userLocation.components(separatedBy: ",")
        let latitude = UserController().stringToInt(intString: latLongArray[0], viewController: self)
        let longitude = UserController().stringToInt(intString: latLongArray[1], viewController: self)
        userMarker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        userMarker.appearAnimation = .pop
        userMarker.isDraggable = true
        userMarker.map = mapView
        
        mapView.camera = GMSCameraPosition(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude), zoom: 6.0)
        userMarkerArray.append(userMarker)
        
    }
}
