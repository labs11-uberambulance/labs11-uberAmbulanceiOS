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

@objc
class Ride: NSObject {
    let driver: Driver
    let mother: PregnantMom
    let fixedPrice: Double
    var status: RideStatus
    let startAddress: Address
    let destinationAddress: Address
    
    init(driver: Driver, mother: PregnantMom, fixedPrice: Double, status: RideStatus, startAddress: Address, destinationAddress: Address) {
        self.driver = driver
        self.mother = mother
        self.fixedPrice = fixedPrice
        self.status = status
        self.startAddress = startAddress
        self.destinationAddress = destinationAddress
    }
}

@objc
class Address: NSObject {
    let locationDescription: String
    let village: String
    let plot: String?
    
    init(description: String, village: String, plot: String?) {
        self.locationDescription = description
        self.village = village
        self.plot = plot
    }
}
