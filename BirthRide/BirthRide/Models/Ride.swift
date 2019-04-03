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
    var rideId: NSNumber?
    var waitMin: NSNumber?
    var startVillage: String?
    var startAddress: String?
    var destination: String?
    var destinationAddress: String?
    
    init(rideID: NSNumber, waitMin: NSNumber, startVillage: String, startAddress: String, destination: String, destinationAddress: String) {
        self.rideId = rideID
        self.waitMin = waitMin
        self.startVillage = startVillage
        self.startAddress = startAddress
        self.destination = destination
        self.destinationAddress = destinationAddress
    }
}
