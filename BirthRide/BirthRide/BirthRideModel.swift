//
//  BirthRideModel.swift
//  BirthRide
//
//  Created by Sean Hendrix on 3/20/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import Foundation

enum UserType {
    
    case driver
    case mother
    case caretaker
    
}

class BirthRideModel {
    
    let name: String
    var address: String = ""
    var nearCity: String = ""
    let photo: String?
    let email: String
    var stripeID: String = ""
    var googleID: String = ""
    var caretaker: String = ""
    //    let password
    let dueDate: Date
    
    
    init(name: String, address: String, nearCity: String, photo: String?, email: String, stripeID: String?, googleID: String?, caretaker: String, dueDate: Date = Date()) {
        (self.name, self.address, self.nearCity, self.photo, self.email, self.stripeID, self.googleID, self.caretaker, self.dueDate) = (name, address, nearCity, photo, email, stripeID!, googleID!, caretaker, dueDate)
        
    }
    
}
