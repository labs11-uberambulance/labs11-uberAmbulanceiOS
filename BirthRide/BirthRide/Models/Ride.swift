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
class RequestedRide: NSObject {
    let price: NSNumber
    let hospital: NSString
    let name: NSString
    let distance: NSString
    let phone: NSString
    let rideId: NSNumber
    
    required init(price: NSNumber, hospitalName: NSString, motherName: NSString, distance: NSString, phoneNumber: NSString, rideId: NSNumber) {
        self.price = price
        self.hospital = hospitalName
        self.name = motherName
        self.distance = distance
        self.phone = phoneNumber
        self.rideId = rideId
    }
    
    class func createRideWithDictionary(dictionary: [String: AnyObject]) -> RequestedRide {
        guard dictionary.keys.contains("price"),
            dictionary.keys.contains("hospital"),
        dictionary.keys.contains("name"),
        dictionary.keys.contains("distance"),
        dictionary.keys.contains("phone"),
            dictionary.keys.contains("ride_id") else {
                NSLog("dictionary received from push notification does not have the necessary keys, this method will return a dummy object.")
                return RequestedRide.init(price: 1, hospitalName: "", motherName: "", distance: "", phoneNumber: "", rideId: 1)
        }
        return RequestedRide.init(price: dictionary["price"] as! NSNumber, hospitalName: dictionary["hospital"] as! NSString, motherName: dictionary["name"] as! NSString, distance: dictionary["distance"] as! NSString, phoneNumber: dictionary["phone"] as! NSString, rideId: dictionary["ride_id"] as! NSNumber)
        
    }
    
}
