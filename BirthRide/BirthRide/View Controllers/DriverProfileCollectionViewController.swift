//
//  DriverProfileCollectionViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/20/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

private let reuseIdentifier = "DriverProfileCell"

class DriverProfileCollectionViewController: UICollectionViewController {
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "DriverProfileCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "DriverProfileCell")
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.reloadData()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dummyArrayOfDrivers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DriverProfileCollectionViewCell
    
        cell.driverNameLabel.text = dummyArrayOfDrivers[indexPath.row]["name"] as? String
        cell.driverRatingAndEstimatedDistanceLabel.text = dummyArrayOfDrivers[indexPath.row]["rateAndDistance"] as? String
        cell.driverProfilePictureImageView.image = UIImage(named: "placeholder_image")
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
