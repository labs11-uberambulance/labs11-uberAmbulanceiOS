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

class Ride: NSObject {
    let driver: Driver
    let mother: PregnantMom
    let fixedPrice: Double
    var status: RideStatus
    let startAddress: Address
    let destinationAddress: Address
}

class Address {
    let description: String
    let village: String
    let plot: String?
}
