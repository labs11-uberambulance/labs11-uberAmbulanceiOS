//
//  UserController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/27/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

class UserController {
    //MARK: Private Properties
    private let numbersDictionary: Dictionary = ["0": 0, "1": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9]
    
    func configurePregnantMom(user: User, dueDate: String?, hospital: String?, caretakerName: String?) -> PregnantMom {
        let newMom = PregnantMom(dueDate: dueDate, hospital: hospital, caretakerName: caretakerName)
        newMom.name = user.name
        newMom.firebaseId = user.firebaseId
        newMom.address = user.address
        newMom.id = user.id
        newMom.login = user.login
        newMom.phone = user.phone
        newMom.userType = user.userType
        newMom.village = user.village
        newMom.latitude = user.latitude
        newMom.longitude = user.longitude
        newMom.email = user.email
        return newMom
    }
    func updatePregnantMom(pregnantMom: PregnantMom) {
        
    }
    
    func configureDriver(price: Int, bio: String) -> Driver {
        return Driver(price: price, bio: bio)
    }
    func updateDriver(driver: Driver, viewController: UIViewController, name: String, address: String, email: String, phoneNumber: String, priceString: String, bio: String?) {
        
        driver.name = name
        driver.address = address
        driver.email = email
        driver.phone = phoneNumber
        driver.price = stringToInt(intString: priceString, viewController: viewController)
        driver.bio = bio
    }
    
    func configureGenericUser() {
        
    }
    func updateGenericUser(user: User, name: String?, village: String?, phone: String?, address: String?, email: String?) {
        
    }
    //MARK: Private Methods
    private func stringToInt(intString: String, viewController: UIViewController) -> Int {
        let stringArray = intString.components(separatedBy: "")
        var intResult: Int = 0
        var intArray: [Int] = []
        var multiplier = 1
        for string in stringArray {
            guard let int = numbersDictionary[string] else {
                AuthenticationController.shared.displayErrorMessage(errorType: .invalidInformation, viewController: viewController)
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
