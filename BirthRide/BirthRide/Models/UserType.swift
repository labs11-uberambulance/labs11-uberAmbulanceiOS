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
    ///This property will be set by the backend. I will get it back when I first create the user.
    var id: Int?
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
    var latitude: Double?
    ///This property should be populated immediately upon receiving the id from the backend.
    var longitude: Double?
    
    var email: String?

    init(id: Int?, name: String?, login: String?, firebaseId: String?, phone: String?, userType: String?, address: String?, village: String?, latitude: Double?, longitude: Double?, email: String?) {
        super.init()
        self.id = id
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
@objc
class PregnantMom: User {
    var caretakerName: String?
    ///This property must have the format: YYYY-MM-DD
    var dueDate: String?
    ///This property must match a location findable by google maps API
    var hospital: String?

    @objc
    init(dueDate: String?, hospital: String?, caretakerName: String?) {
        self.dueDate = dueDate
        self.hospital = hospital
        self.caretakerName = caretakerName
        super.init(id: nil, name: nil, login: nil, firebaseId: nil, phone: nil, userType: nil, address: nil, village: nil, latitude: nil, longitude: nil, email: nil)
    }
}
@objc
class Driver: User {
    ///The value of this property is the maximum price for the ride
    var price: Int
    var active: Bool
    ///The value of this property has a 500 char limit
    var bio: String?
    var photo: String?
    
    @objc
    init(price: Int, active: Bool = false, bio: String, photo: String?) {
        self.price = price
        self.active = active
        self.bio = bio
        self.photo = photo
        super.init(id: nil, name: nil, login: nil, firebaseId: nil, phone: nil, userType: nil, address: nil, village: nil, latitude: nil, longitude: nil, email: nil)
    }
}

