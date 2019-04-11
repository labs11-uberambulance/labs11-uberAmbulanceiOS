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
    case drivers
}

@objcMembers
class User: NSObject {
    ///This property will be set by the backend. I will get it back when I first create the user.
    var userID: NSNumber?
    var name: NSString?
    ///This property will contain the email or phone number of the user, depending on login type. This property is unneeded on the FE.
//    var login: String?
    var firebaseId: NSString?
    var phone: NSString?
    var userType: NSString?
    ///This property stores either the street address or the description of the user's location. 500 char limit.
    var address: NSString?
    ///The value of the property must match location findable by google maps API
    var village: NSString?
    ///This property should be populated immediately upon receiving the id from the backend.
    var latitude: NSNumber?
    ///This property should be populated immediately upon receiving the id from the backend.
    var longitude: NSNumber?
    
    var email: NSString?

    init(userID: NSNumber?, name: NSString?, login: NSString?, firebaseId: NSString?, phone: NSString?, userType: NSString?, address: NSString?, village: NSString?, latitude: NSNumber?, longitude: NSNumber?, email: NSString?) {
        super.init()
        self.userID = userID
        self.name = name
//        self.login = login
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
class PregnantMom: NSObject {
    var motherId: NSNumber?
    var caretakerName: NSString?
//    ///This property must have the format: YYYY-MM-DD
//    var dueDate: String?
    var start: Start?
    var destination: Destination?
    

    required init(start: Start?, destination: Destination?, caretakerName: NSString?, motherId: NSNumber?) {
        self.start = start
        self.destination = destination
        self.caretakerName = caretakerName
        self.motherId = motherId
    }
}
@objcMembers
class Start: NSObject {
    var latLong: NSString?
    var name: NSString?
    var startDescription: NSString?
    
    init(latLong: NSString, name: NSString, startDescription: NSString?) {
        super.init()
        self.latLong = latLong
        self.name = name
        self.startDescription = startDescription
    }
}

@objcMembers
class Destination: NSObject {
    var latLong: NSString?
    var name: NSString?
    var destinationDescription: NSString?
    
    init(latLong: NSString, name: NSString, destinationDescription: NSString?) {
        super.init()
        self.latLong = latLong
        self.name = name
        self.destinationDescription = destinationDescription
    }
}

@objcMembers
class Driver: NSObject {
    var driverId: NSNumber?
    var requestedDriverName: NSString?
    ///The value of this property is the maximum price for the ride
    var firebaseId: NSString?
    var price: NSNumber?
    var isActive: ObjCBool
    ///The value of this property has a 500 char limit
    var bio: NSString?
    var photoUrl: NSString?
    var location: Start?
    var distance: NSString?
    var duration: NSString?
    
    
    @objc
    required init(price: NSNumber, requestedDriverName: NSString?, isActive: ObjCBool, bio: NSString, photo: NSString?, driverId: NSNumber?, firebaseId: NSString?) {
        self.requestedDriverName = requestedDriverName
        self.price = price
        self.isActive = isActive
        self.bio = bio
        self.photoUrl = photo
        self.driverId = driverId
        self.firebaseId = firebaseId
    }

    
    
}

