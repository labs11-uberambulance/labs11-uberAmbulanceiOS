//
//  MotherOrCaretakerViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/21/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MotherOrCaretakerRegistrationViewController: UIViewController, TransitionBetweenViewControllers, GMSMapViewDelegate, GMSAutocompleteResultsViewControllerDelegate {
    //MARK: Private Properties
    private var networkingController = ABCNetworkingController()
    private let locationManager = CLLocationManager()
    private var userMarkerArray: [GMSMarker] = []
    private var destinationMarkerArray: [GMSMarker] = []
    private let autocompleteResultsVC = GMSAutocompleteResultsViewController()
    private var searchController: UISearchController?
    //MARK: Other Properties
    
    //MARK: IBOutlets
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var villageTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var caretakerTextField: UITextField!
    @IBOutlet weak var destinationSearchBar: UISearchBar!
    
    @IBOutlet weak var mapContainerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        caretakerTextField.isHidden = true
        setupKeyboardDismissRecognizer()
        mapView.delegate = self
        configureMapView()
        
        let filter = GMSAutocompleteFilter()
        filter.country = "UG"
        filter.type = .establishment
        
        
        autocompleteResultsVC.autocompleteFilter = filter
        searchController = UISearchController(searchResultsController: autocompleteResultsVC)
        searchController?.searchResultsUpdater = autocompleteResultsVC
        searchController?.searchBar.sizeToFit()
        mapContainerView.addSubview((searchController?.searchBar)!)
        autocompleteResultsVC.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func caretakerButtonTapped(_ sender: Any) {
        //FIXME: Currently, all of the text fields are hidden until this button is hit.
        caretakerTextField.isHidden = false
    }
    @IBAction func continueButtonTapped(_ sender: Any) {
        guard nameTextField.text != "", villageTextField.text != "", phoneTextField.text != "",
            userMarkerArray.count > 0,
        let user = AuthenticationController.shared.genericUser else {return}
    
        let motherLatitude = userMarkerArray[0].position.latitude
        let motherLongitude = userMarkerArray[0].position.longitude
        let latLongString = "\(motherLatitude), \(motherLongitude)"
        AuthenticationController.shared.pregnantMom?.start?.latLong = latLongString
        AuthenticationController.shared.genericUser?.name = nameTextField.text
        AuthenticationController.shared.genericUser?.phone = phoneTextField.text

        UserController().updateGenericUser(user: user, name: nameTextField.text, village: villageTextField.text, phone: phoneTextField.text, address: nil, email: nil)

        AuthenticationController.shared.pregnantMom = UserController().configurePregnantMom(viewController: self, startLatLong: "", destinationLatLong: "", startDescription: "")

        transition(userType: nil)
    }
    

    //MARK: TransitionBetweenViewControllers Protocol Method
    func transition(userType: UserType?) {
        let destinationVC = RequestRideViewController()
        self.present(destinationVC, animated: true) {
        }
    }
    
    //MARK: GMSAutocompleteResultsViewControllerDelegate methods
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        let lat = "\(place.coordinate.latitude)"
        let long = "\(place.coordinate.longitude)"
        AuthenticationController.shared.pregnantMom?.destination?.latLong = "\(lat), \(long)"
        AuthenticationController.shared.pregnantMom?.destination?.name = place.name
        createDestinationMapMarker(coordinate: place.coordinate)
        resultsController.dismiss(animated: true, completion: nil)
    }
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        NSLog("Error in MotherOrCaretakerController.resultsController:didFailautocompleteWithError.")
        NSLog(error.localizedDescription)
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
    }
    
    //MARK: Private Methods
    private func createDestinationMapMarker(coordinate: CLLocationCoordinate2D){
        if destinationMarkerArray.count > 0 {
            destinationMarkerArray.removeAll()
        }
        let destinationMarker = GMSMarker()
        destinationMarker.position = coordinate
        destinationMarker.appearAnimation = .pop
        destinationMarker.isDraggable = false
        destinationMarker.map = mapView
        mapView.settings.myLocationButton = true
        destinationMarkerArray.append(destinationMarker)
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 6.0)
        mapView.animate(to: camera)
    }
    
    ///This method will set up a tap gesture recognizer to dismiss the keyboard whenever the user touches a view outside of it.
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
    
    ///This method will configure the mapView. If the app is able to get the user coordinates, then it will also create a marker to put on the map. If not it will return. The map marker will **not** be created if one already exists.
    private func configureMapView() {
        let userMarker = GMSMarker()
        guard let userLocation = locationManager.location?.coordinate else {return}
        userMarker.position = userLocation
        userMarker.appearAnimation = .pop
        userMarker.isDraggable = true
        userMarker.map = mapView
        userMarkerArray.append(userMarker)
        
    }
    
    
}
