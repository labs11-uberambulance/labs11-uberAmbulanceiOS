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

@objcMembers
class User: NSObject {
    ///This property will be set by the backend. I will get it back when I first create the user.
    var userID: NSNumber?
    var name: String?
    ///This property will contain the email or phone number of the user, depending on login type
    var login: String?
    var firebaseId: String?
    var phone: String?
    var userType: String?
    ///This property stores either the street address or the description of the user's location. 500 char limit.
    var address: String?
    ///The value of the property must match location findable by google maps API
    var village: String?
    ///This property should be populated immediately upon receiving the id from the backend.
    var latitude: NSNumber?
    ///This property should be populated immediately upon receiving the id from the backend.
    var longitude: NSNumber?
    
    var email: String?

    init(userID: NSNumber?, name: String?, login: String?, firebaseId: String?, phone: String?, userType: String?, address: String?, village: String?, latitude: NSNumber?, longitude: NSNumber?, email: String?) {
        super.init()
        self.userID = userID
        self.name = name
        self.login = login
        self.phone = phone
        self.userType = userType
        self.address = address
        self.village = village
        self.latitude = latitude
        self.longitude = longitude
        self.email = email
    }

}
@objcMembers
class PregnantMom: User {
    var caretakerName: String?
    ///This property must have the format: YYYY-MM-DD
    var dueDate: String?
    ///This property must match a location findable by google maps API
    var hospital: String?
    
    var motherID: NSNumber?

    required init(dueDate: String?, hospital: String?, caretakerName: String?, motherID: NSNumber?) {
        self.dueDate = dueDate
        self.hospital = hospital
        self.caretakerName = caretakerName
        self.motherID = motherID
        super.init(userID: nil, name: nil, login: nil, firebaseId: nil, phone: nil, userType: nil, address: nil, village: nil, latitude: nil, longitude: nil, email: nil)
    }
}
@objcMembers
class Driver: User {
    ///The value of this property is the maximum price for the ride
    var price: Int?
    var active: Bool?
    ///The value of this property has a 500 char limit
    var bio: String?
    var photo: String?
    
    var driverID: NSNumber?
    
    @objc
    required init(price: Int, active: Bool = false, bio: String, photo: String?, driverID: NSNumber?) {
        self.price = price
        self.active = active
        self.bio = bio
        self.photo = photo
        self.driverID = driverID
        super.init(userID: nil, name: nil, login: nil, firebaseId: nil, phone: nil, userType: nil, address: nil, village: nil, latitude: nil, longitude: nil, email: nil)
    }

    
    
}

