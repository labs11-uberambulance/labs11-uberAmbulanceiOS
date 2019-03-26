//
//  UserType.swift
//  BirthRide
//
//  Created by Austin Cole on 3/22/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

///The type of user
enum UserType: String {
    case pregnantMom
    case driver
}

@objc
class User: NSObject {
    let userID: Int?
    let name: String
    let googleID: String?
    var phoneNumber: String
    var profilePicture: UIImage?
    let userType: String

    init(userID: Int?, name: String, googleID: String?, phoneNumber: String, userType: String, profilePicture: UIImage?) {
        self.userID = userID
        self.name = name
        self.googleID = googleID
        self.phoneNumber = phoneNumber
        self.userType = userType
        self.profilePicture = profilePicture
    }
}
@objc
class PregnantMom: User {
    var locationDescription: String?
    var village: String
    var dueDate: String?
    var hospital: String?
    var caretakerName: String?

    init(name: String, description: String?, village: String, phoneNumber: String, dueDate: String?, hospital: String?, caretakerName: String?, profilePicture: UIImage?, userID: Int?, googleID: String?, userType: String) {
        self.locationDescription = description
        self.village = village
        self.dueDate = dueDate
        self.hospital = hospital
        self.caretakerName = caretakerName
        super.init(userID: userID ?? nil, name: name, googleID: googleID ?? nil, phoneNumber: phoneNumber, userType: userType, profilePicture: profilePicture)
    }
}
@objc
class Driver: User {
    var address: String
    var pricePerKm: Int
    var isActive: Bool
    var bio: String
    
    init(address: String, pricePerKm: Int, isActive: Bool, bio: String, userID: Int?, name: String, googlID: String?, phoneNumber: String, userType: String, profilePicture: UIImage?) {
        self.address = address
        self.pricePerKm = pricePerKm
        self.isActive = isActive
        self.bio = bio
        super.init(userID: userID, name: name, googleID: googlID, phoneNumber: phoneNumber, userType: userType, profilePicture: profilePicture)
    }
}

