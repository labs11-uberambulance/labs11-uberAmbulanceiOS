//
//  UserController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/27/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

//TODO: Refactor all of the networking requests to include the actual user token.

class UserController {
    //MARK: Private Properties
    private let numbersDictionary: Dictionary = ["0": 0, "1": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9]
    private let networkingController = ABCNetworkingController()
    
    
    //MARK: Public Methods
    public func configurePregnantMom( viewController: UIViewController, startLatLong: NSString, destinationLatLong: NSString, startDescription: NSString?) -> PregnantMom {
        
        let testStart = Start(latLong: startLatLong, name: "", startDescription: "")
        let testDestination = Destination(latLong: "", name: "", destinationDescription: "")
        
        let newMom = PregnantMom(start: testStart, destination: testDestination, caretakerName: nil, motherId: nil)
        newMom.start?.latLong = startLatLong
        newMom.destination?.latLong = destinationLatLong
        
        guard let token = AuthenticationController.shared.userToken,
        let user = AuthenticationController.shared.genericUser,
        let userID = user.userID else {return newMom}
        
        let onboardAndUpdateUserOperationQueue = OperationQueue()
        let onboardOperation: BlockOperation = BlockOperation {
            self.networkingController.onboardUser(withToken: token, withUserID: userID, with: user, with: nil, withMother: newMom) { (error) in
                if let error = error {
                    NSLog(error.localizedDescription)
                    return
                }
            }
        }
        let updateOperation: BlockOperation = BlockOperation {
            self.networkingController.updateUser(withToken: token, withUserID: userID, with: user, with: nil, withMother: newMom) { (error) in
                if let error = error {
                    NSLog(error.localizedDescription)
                    return
                }
            }
        }
        updateOperation.addDependency(onboardOperation)
        onboardAndUpdateUserOperationQueue.addOperations([onboardOperation, updateOperation], waitUntilFinished: true)
        
        
        
        return newMom
    }
    public func updatePregnantMom(pregnantMom: PregnantMom) {
        
    }
    
    public func configureDriver(price: Int, bio: NSString) -> Driver {
        return Driver(price: price, bio: bio, photo: nil, driverId: nil, firebaseId: nil)
    }
    public func updateDriver(viewController: UIViewController, name: NSString?, address: NSString?, email: NSString?, phoneNumber: NSString?, priceString: NSString?, bio: NSString?, photo: NSString?) {
        guard name != "", address != "", email != "", phoneNumber != "", priceString != "" else {
            return
        }
        guard let driver = AuthenticationController.shared.driver,
        let user = AuthenticationController.shared.genericUser else {
            return
        }
        driver.price = stringToInt(intString: priceString! as String, viewController: viewController)
        driver.bio = bio
        driver.photo = photo
        user.name = name
        user.address = address
        user.email = email
        user.phone = phoneNumber
    }
    
    public func updateGenericUser(user: User, name: String?, village: String?, phone: String?, address: String?, email: String?) {
        guard let name = name,
        let village = village,
            let phone = phone else {
                return
        }
        user.name = name as NSString
        user.village = village as NSString
        user.phone = phone as NSString
        
    }
    //MARK: Private Methods
    private func stringToInt(intString: String, viewController: UIViewController) -> Int {
        let stringArray = intString.components(separatedBy: "")
        var intResult: Int = 0
        var intArray: [Int] = []
        var multiplier = 1
        for string in stringArray {
            guard let int = numbersDictionary[string] else {
                return 0
            }
            intArray.append(int)
        }
        while intArray.count > 0 {
            intResult += (intArray.last ?? 0) * multiplier
            multiplier *= 10
        }
        return intResult
    }
}
