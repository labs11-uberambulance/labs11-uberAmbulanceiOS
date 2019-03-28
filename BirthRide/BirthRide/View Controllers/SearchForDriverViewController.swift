//
//  SearchForDriverViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/21/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit
import GoogleMaps

class SearchForDriverViewController: UIViewController {
    //MARK: Private Properties
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
    }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
