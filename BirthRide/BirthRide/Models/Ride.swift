//
//  Ride.swift
//  BirthRide
//
//  Created by Austin Cole on 3/26/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

enum RideStatus: String {
    case pending
    case accepted
    case enrouteToPickup
    case onsite
    case enrouteToDestination
    case complete
}

@objcMembers
class Ride: NSObject {
    var rideId: NSNumber?
    var motherId: NSNumber?
    var waitMin: NSNumber?
    var startVillage: String?
    var startAddress: String?
    var destination: String?
    var destinationAddress: String?
    
    init(rideID: NSNumber, waitMin: NSNumber, startVillage: String, startAddress: String, destination: String, destinationAddress: String) {
        super.init()
        self.rideId = rideID
        self.waitMin = waitMin
        self.startVillage = startVillage
        self.startAddress = startAddress
        self.destination = destination
        self.destinationAddress = destinationAddress
    }
}

@objcMembers
class requestedRide: NSObject {
    let price: NSNumber
    let hospitalName: NSString
    let motherName: NSString
    let distance: NSString
    let phoneNumber: NSString
    
    required init(price: NSNumber, hospitalName: NSString, motherName: NSString, distance: NSString, phoneNumber: NSString) {
        self.price = price
        self.hospitalName = hospitalName
        self.motherName = motherName
        self.distance = distance
        self.phoneNumber = phoneNumber
    }
    
    
}
