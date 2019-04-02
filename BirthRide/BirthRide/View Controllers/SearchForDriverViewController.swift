//
//  SearchForDriverViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/21/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit
import GoogleMaps

class SearchForDriverViewController: UIViewController, GMSMapViewDelegate {
    //MARK: Private Properties
    private var driverProfileCollectionViewController: DriverProfileCollectionViewController?
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
    
    ///This is not a true containerView. Here we are going to add the view of the collectionViewController as a subView
    @IBOutlet weak var driverProfileCollectionView: UICollectionView!
    @IBOutlet weak var mapView: GMSMapView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
        createMarkers()
        mapView.delegate = self
//        driverProfileCollectionViewController = DriverProfileCollectionViewController()
//        driverProfileCollectionView.dataSource = driverProfileCollectionViewController
//        driverProfileCollectionView.delegate = driverProfileCollectionViewController
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView.init(frame: driverProfileCollectionView.frame, collectionViewLayout: flowLayout)
        
        driverProfileCollectionViewController?.collectionView = collectionView
        driverProfileCollectionViewController?.collectionView.frame(forAlignmentRect: driverProfileCollectionView.frame)
            
        driverProfileCollectionView = driverProfileCollectionViewController?.collectionView
        driverProfileCollectionViewController?.viewDidLoad()
    }
    
    //MARK: Private Methods
    private func configureMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: 1.360511, longitude: 36.847888, zoom: 6.0)
        mapView.camera = camera
    }
    private func createMarkers() {
        for dictionary in dummyArrayOfDrivers {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: dictionary["latitude"] as! CLLocationDegrees, longitude: dictionary["longitude"] as! CLLocationDegrees)
            marker.title = dictionary["name"] as? String
            marker.snippet = dictionary["rateAndDistance"] as? String
            marker.map = mapView
        }
    }
    
    //MARK: GMSMapViewDelegate methods
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        transition(userType: nil, marker: marker)
        return true
    }
    //MARK: TransitionBetweenViewControllers methods
    func transition(userType: UserType?, marker: GMSMarker) {
        let destinationVC = ConfirmRideViewController()
        for dummyDriver in dummyArrayOfDrivers {
            if dummyDriver["latitude"] as! CLLocationDegrees == marker.position.latitude && dummyDriver["longitude"] as! CLLocationDegrees == marker.position.longitude {
                destinationVC.driver = dummyDriver
            }
        }
        
        self.present(destinationVC, animated: true) {
        }
    }

}
