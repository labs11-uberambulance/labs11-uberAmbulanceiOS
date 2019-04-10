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
    private var path = GMSMutablePath()
    //MARK: Other Properties
    var mother: PregnantMom?
    var isUpdating: Bool = false
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
        populateTextFieldsAndConfigureViewForEditing()
        
        if isUpdating {
            guard let mom = AuthenticationController.shared.pregnantMom else {return}
        createDestinationMapMarker(coordinate: CLLocationCoordinate2D(latitude: 22, longitude: 22))
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func caretakerButtonTapped(_ sender: Any) {
        caretakerTextField.isHidden = false
    }
    @IBAction func continueButtonTapped(_ sender: Any) {
        guard nameTextField.text != "", villageTextField.text != "", phoneTextField.text != "",
            userMarkerArray.count > 0,
            destinationMarkerArray.count > 0,
        let name = nameTextField.text,
        let phone = phoneTextField.text,
        let village = villageTextField.text else {return}
       
        var caretakerName = caretakerTextField.text
    
        let motherLatitude = userMarkerArray[0].position.latitude
        let motherLongitude = userMarkerArray[0].position.longitude
        let latLongString = "\(motherLatitude),\(motherLongitude)"
        let destinationLatitude = destinationMarkerArray[0].position.latitude
        let destinationLongitude = destinationMarkerArray[0].position.longitude
        let destLatLongString = "\(destinationLatitude), \(destinationLongitude)"

        AuthenticationController.shared.genericUser?.name = nameTextField.text! as NSString
        AuthenticationController.shared.genericUser?.phone = phoneTextField.text! as NSString
        

        if caretakerName == nil {
            caretakerName = ""
        }
        UserController().configurePregnantMom(isUpdating: isUpdating, name: name as NSString, village: village as NSString, phone: phone as NSString, caretakerName: caretakerName as NSString?, startLatLong: latLongString as NSString, destinationLatLong: destLatLongString as NSString, startDescription: "")

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
        AuthenticationController.shared.pregnantMom?.destination?.latLong = "\(lat),\(long)" as NSString
        if let name = place.name {
            AuthenticationController.shared.pregnantMom?.destination?.name = name as NSString
        }
        createDestinationMapMarker(coordinate: place.coordinate)
        createRoute()
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
        createRoute()
    }
    
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        createRoute()
    }
    
    //MARK: Private Methods
    private func createDestinationMapMarker(coordinate: CLLocationCoordinate2D){
        
        if destinationMarkerArray.count > 0 {
            destinationMarkerArray.removeAll()
        }
        let destinationMarker = GMSMarker()
        
        if let latLong = mother?.destination?.latLong {
            
            let latLongArray = latLong.components(separatedBy: ",")
            let latitude = UserController().stringToInt(intString: latLongArray[0], viewController: self)
            let longitude = UserController().stringToInt(intString: latLongArray[1], viewController: self)
            destinationMarker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
            destinationMarker.appearAnimation = .pop
            destinationMarker.isDraggable = true
            destinationMarker.map = mapView
            destinationMarker.icon = GMSMarker.markerImage(with: .red)
            destinationMarkerArray.append(destinationMarker)
            return
            
        }
        destinationMarker.position = coordinate
        destinationMarker.appearAnimation = .pop
        destinationMarker.isDraggable = false
        destinationMarker.icon = GMSMarker.markerImage(with: .orange)
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
        let camera = GMSCameraPosition.camera(withLatitude: 1.360511, longitude: 36.847888, zoom: 6.0)
        mapView.animate(to: camera)
        if isUpdating {
        configureUserMarker()
        }
        
    }
    
    private func populateTextFieldsAndConfigureViewForEditing() {
        if let mother = mother,
            let user = AuthenticationController.shared.genericUser {
            nameTextField.text = user.name as String?
            phoneTextField.text = user.phone as String?
            villageTextField.text = mother.start?.name as String?
            caretakerTextField.text = mother.caretakerName as String?
            caretakerTextField.isHidden = false
        }
    }
    
    private func configureUserMarker() {
        let userMarker = GMSMarker()
        if let mother = mother,
            let userLocation = mother.start?.latLong {
            let latLongArray = userLocation.components(separatedBy: ",")
            let latitude = UserController().stringToInt(intString: latLongArray[0], viewController: self)
            let longitude = UserController().stringToInt(intString: latLongArray[1], viewController: self)
            userMarker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
            userMarker.appearAnimation = .pop
            userMarker.isDraggable = true
            userMarker.map = mapView
            userMarker.icon = GMSMarker.markerImage(with: .blue)
            userMarkerArray.append(userMarker)
            return
        }
        guard let userLocation = locationManager.location?.coordinate else {return}
        userMarker.position = userLocation
        userMarker.appearAnimation = .pop
        userMarker.isDraggable = true
        userMarker.map = mapView
        userMarker.icon = GMSMarker.markerImage(with: .blue)
        userMarker.icon = GMSMarker.markerImage(with: .blue)
        userMarkerArray.append(userMarker)
    }
    
    
    //FIXME: The existing paths are not removed when the new path is created.
    private func createRoute() {
        
        guard userMarkerArray.count > 0,
            destinationMarkerArray.count > 0 else {return}
        
        path.removeAllCoordinates()
        path.add(CLLocationCoordinate2D(latitude: CLLocationDegrees(destinationMarkerArray[0].position.latitude), longitude: CLLocationDegrees(destinationMarkerArray[0].position.longitude)))
        path.add(CLLocationCoordinate2D(latitude: userMarkerArray[0].position.latitude, longitude: userMarkerArray[0].position.longitude))
        
        let line = GMSPolyline.init(path: path)
        line.strokeColor = .green
        line.map = mapView
    }
    
}
