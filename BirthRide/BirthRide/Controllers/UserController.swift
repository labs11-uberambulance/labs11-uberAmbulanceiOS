//
//  UserController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/27/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

//TODO: Refactor all of the networking requests to include the actual user token.

class UserController {
    //MARK: Private Properties
    private let numbersDictionary: Dictionary = ["0": 0, "1": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9]
    private let networkingController = ABCNetworkingController()
    
    
    //MARK: Public Methods
    public func configurePregnantMom( isUpdating: Bool, name: NSString, village: NSString, phone: NSString, caretakerName: NSString?, startLatLong: NSString, destinationLatLong: NSString, startDescription: NSString?){
        
        let mom: PregnantMom
        
        guard let user = AuthenticationController.shared.genericUser else {return}
        
        if !isUpdating {
            mom = PregnantMom(start: Start(latLong: startLatLong, name: village, startDescription: ""), destination: Destination(latLong: destinationLatLong, name: "", destinationDescription: ""), caretakerName: caretakerName, motherId: nil)
            AuthenticationController.shared.pregnantMom = mom
        }
        else {
            guard AuthenticationController.shared.pregnantMom != nil else {return}
            mom = AuthenticationController.shared.pregnantMom!
            mom.caretakerName = caretakerName
            mom.start?.latLong = startLatLong
            mom.destination?.latLong = destinationLatLong
            mom.start?.name = village
        }
        user.name = name
        user.phone = phone
        user.village = village
        
        
        guard let token = AuthenticationController.shared.userToken,
            let userID = user.userID else {return}
        
        let onboardAndUpdateUserOperationQueue = OperationQueue()
        let onboardOperation: BlockOperation = BlockOperation {
            self.networkingController.onboardUser(withToken: token, withUserID: userID, with: user, with: nil, withMother: mom) { (error) in
                if let error = error {
                    NSLog(error.localizedDescription)
                    return
                }
            }
        }
        let updateOperation: BlockOperation = BlockOperation {
            self.networkingController.updateUser(withToken: token, withUserID: userID, with: user, with: nil, withMother: mom) { (error) in
                if let error = error {
                    NSLog(error.localizedDescription)
                    return
                }
            }
        }
        if !isUpdating {
            updateOperation.addDependency(onboardOperation)
            onboardAndUpdateUserOperationQueue.addOperations([onboardOperation, updateOperation], waitUntilFinished: true)
        }
        else {
            onboardAndUpdateUserOperationQueue.addOperation(updateOperation)
        }
    }
    
    public func configureDriver(isUpdating: Bool, name: NSString, address: NSString?, email: NSString?, phoneNumber: NSString, price: NSString, bio: NSString, photo: NSString?) {
        guard let user = AuthenticationController.shared.genericUser,
            let token = AuthenticationController.shared.userToken,
            let userID = AuthenticationController.shared.genericUser?.userID,
            let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") else {return}
        
        let driver: Driver
        
        user.name = name
        user.phone = phoneNumber
        
        let f = NumberFormatter()
        f.numberStyle = .decimal
        guard let newPrice = f.number(from: price as String) else {return}
        
        if !isUpdating {
            driver = Driver(price: newPrice, requestedDriverName: "", isActive: false, bio: bio, photo: "", driverId: nil, firebaseId: nil)
        } else {
            driver = AuthenticationController.shared.driver!
            driver.price = newPrice
            driver.bio = bio
            driver.photoUrl = photo
        }
        
        let onboardAndUpdateUserOperationQueue = OperationQueue()
        let onboardOperation: BlockOperation = BlockOperation {
            self.networkingController.onboardUser(withToken: token, withUserID: userID, with: user, with: driver, withMother: nil) { (error) in
                if let error = error {
                    NSLog(error.localizedDescription)
                    return
                }
            }
        }
        let updateOperation: BlockOperation = BlockOperation {
            self.networkingController.updateUser(withToken: token, withUserID: userID, with: user, with: driver, withMother: nil) { (error) in
                if let error = error {
                    NSLog(error.localizedDescription)
                    return
                }
            }
        }
        
        let sendTokenToServerOperation: BlockOperation = BlockOperation {
            self.networkingController.refreshToken(withFIRToken: token, withDeviceToken: deviceToken, withCompletion: { (error) in
                if let error = error {
                    NSLog("Error in UserController.configureDriver")
                    NSLog(error.localizedDescription)
                    return
                }
            })
        }
        
        if !isUpdating {
            updateOperation.addDependency(onboardOperation)
            sendTokenToServerOperation.addDependency(updateOperation)
            onboardAndUpdateUserOperationQueue.addOperations([onboardOperation, updateOperation, sendTokenToServerOperation], waitUntilFinished: true)
        }
        else {
            onboardAndUpdateUserOperationQueue.addOperation(updateOperation)
        }
    }
    
    
    //Thanks to Felix on SO: https://stackoverflow.com/questions/12920345/convert-string-to-double-with-currency#12920544
    public func stringToInt(intString: String, viewController: UIViewController) -> Int {
        
        var f: NumberFormatter = NumberFormatter.init()
        f.numberStyle = .decimal
        let number = f.number(from: intString)
        guard let finishedNumber = number?.intValue else {return}
        return finishedNumber
    }
}
