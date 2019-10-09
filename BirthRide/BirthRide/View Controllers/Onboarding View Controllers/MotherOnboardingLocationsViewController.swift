//
//  MotherOnboardingLocationsViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 10/7/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit
import MapKit

class MotherOnboardingLocationsViewController: UIViewController, UISearchBarDelegate {

    //MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

        // Do any additional setup after loading the view.
    }

    //MARK: IBActions
    @IBAction func searchButtonTapped(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        self.present(searchController, animated: true, completion: nil)
    }
    
    //MARK: UISearchControllerDelegate Methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Disable user interaction
        UIApplication.shared.beginIgnoringInteractionEvents()
        // Display loading indicator
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        // Resign the keyboard and dismiss the searchbarcontroller
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        // Create the search request
        let searchRequest = MKLocalSearch.Request
        
    }

}
