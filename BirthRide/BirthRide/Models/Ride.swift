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
    var rideId: NSNumber
    var motherId: NSNumber
    var driverId: NSNumber
    ///Number of minutes to wait for confirmation/rejection of ride request (defaults to 20 minutes)
    var waitMin: NSNumber
    ///Latitude/Longitude coordinates for the mother's start location
    var start: NSString
    var startName: NSString
    ///Latitude/Longitude coordinates for the mother's destination location
    var destination: NSString
    var destinationName: NSString
    
    required init(rideID: NSNumber, motherId: NSNumber, driverId: NSNumber, waitMin: NSNumber, startLatLong: NSString, startName: NSString, destination: NSString, destinationName: NSString) {
        self.rideId = rideID
        self.motherId = motherId
        self.driverId = driverId
        self.waitMin = waitMin
        self.start = startLatLong
        self.startName = startName
        self.destination = destination
        self.destinationName = destinationName
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
    let rideAlert: RideAlert
    
    required init(price: NSNumber, hospitalName: NSString, motherName: NSString, distance: NSString, phoneNumber: NSString, rideId: NSNumber, rideAlert: RideAlert) {
        self.price = price
        self.hospital = hospitalName
        self.name = motherName
        self.distance = distance
        self.phone = phoneNumber
        self.rideId = rideId
        self.rideAlert = rideAlert
        
    }
    
    class func createRideWithDictionary(dictionary: [String: AnyObject]) -> RequestedRide {
        guard dictionary.keys.contains("price"),
            dictionary.keys.contains("hospital"),
        dictionary.keys.contains("name"),
        dictionary.keys.contains("distance"),
        dictionary.keys.contains("phone"),
            dictionary.keys.contains("ride_id"),
            let alert = dictionary["aps"]?["alert"] as? [String: String] else {
                NSLog("dictionary received from push notification does not have the necessary keys, this method will return a dummy object.")
            return RequestedRide.init(price: 1, hospitalName: "", motherName: "", distance: "", phoneNumber: "", rideId: 1, rideAlert: RideAlert(title: "Dummy Message", body: "Did not work"))
        }
        let rideAlert = RideAlert(title: alert["title"] as! NSString, body: alert["body"] as! NSString)
        return RequestedRide.init(price: NSNumber(value: (dictionary["price"] as! NSString).doubleValue), hospitalName: dictionary["hospital"] as! NSString, motherName: dictionary["name"] as! NSString, distance: dictionary["distance"] as! NSString, phoneNumber: dictionary["phone"] as! NSString, rideId: NSNumber(value: (dictionary["ride_id"] as! NSString).integerValue), rideAlert: rideAlert)
        
    }
    
}

class RideAlert: NSObject {
    
    let title: NSString
    let body: NSString
    
    required init(title: NSString, body: NSString) {
        self.title = title
        self.body = body
    }
    
}
