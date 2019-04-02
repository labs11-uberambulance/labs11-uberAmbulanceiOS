//
//  NetworkingController.h
//  BirthRide
//
//  Created by Austin Cole on 3/26/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

#import <Foundation/Foundation.h>



@class Ride;
NS_ASSUME_NONNULL_BEGIN


@interface ABCNetworkingController : NSObject

/**
 This method will fetch a list of drivers nearby the coordinate location of the mother.

 @param latitude The latitude of the mother's coordinates.
 @param longitude The longitude of the mother's coordinates.
 @param completionHandler A completion handler to handle anything that needs to be done after the network request has finished.
 */
- (void)fetchNearbyDriversWithLatitude:(double)latitude withLongitude:(double)longitude withCompletion:(void(^)( NSError * _Nullable error))completionHandler;


/**
 This method will fetch a specific ride using the token of the logged-in user.

 @param token The authentication token associated with the user. This parameter is used to find the ride associated with the user.
 @param completionHandler A completion handler to handle anything that needs to be done after the network request has finished. The return value of this completion handler is the fetched Ride object.
 */
- (void)fetchRideWithToken:(NSString *)token withCompletion:(void(^)(NSError * _Nullable error, Ride *ride))completionHandler;

/**
 This method is a POST request to the server. It will update the user with driver-specific information.

 @param token This is the firebase token that you receive during the authentication process.
 @param userID This is the userID that is passed back from the initial BE authentication GET request.
 @param price This is the maximum price that the driver will charge.
 @param isActive This is a boolean determining whether or not the driver is currently active.
 @param bio This is an optional biography of the driver.
 @param photoURL This is the url, in the form of a string, of the driver's profile photo.
 */
- (void)onboardDriverUserWithToken:(NSString *)token withUserID:(NSNumber *)userID withPrice:(NSNumber *)price withActive:(NSNumber *)isActive withBio:(NSString *)bio withPhoto:(NSString *)photoURL;


/**
 This method is a POST request to the server. It will update the user with mother-specific information.

 @param token This is the firebase token that you receive during the authentication process.
 @param userID This is the userID that is passed back from the initial BE authentication GET request.
 @param caretakerName This is the name from the optional caretaker field.
 @param dueDate This is the mother's due date.
 @param hospital This is the mother's preferred hospital.
 */
- (void)onboardMotherUserWithToken:(NSString *)token withUserID:(NSNumber *)userID withCaretaker:(NSString *)caretakerName withDueDate:(NSString *)dueDate withHospital:(NSString *)hospital;


/**
 This method is a PUT request to the server. It will update the general user information and the user-specific information(driver/mother).

 @param token This is the firebase token that you receive during the authentication process.
 @param userID This is the userID that is passed back from the initial BE authentication GET request.
 @param name The name of the user.
 @param phone The phone number of the user.
 @param userType The user type.
 @param address The address of the user, or a description of the user's location.
 @param village The village of the user.
 @param email The email address of the user.
 @param latitude The latitude of the user's address last-known location.
 @param longitude The longitude of the user's address or last-known location.
 @param completionHandler Use this completion handler to handle anything you want done after the networking request has completed.
 */
- (void)updateDriverUserWithToken:(NSString *)token withUserID:(NSNumber *)userID withName:(NSString *)name withPhone:(NSString *)phone withUserType:(NSString *)userType withAddress:(NSString *)address withVillage:(NSString *)village withEmail:(NSString *)email withLatitude:(NSNumber *)latitude withLongitude:(NSNumber *)longitude withCompletion:(void(^)(NSError * _Nullable error))completionHandler;

///This method will create a ride on the server.
/**
 This method will create a new ride and will associate the ride with the user associated with the passed-in authentication token.

 @param token The authentication token associated with the user. This parameter is used to associate the created ride with a specific user.
 @param completionHandler A completion handler to handle anything that needs to be done after the network request has finished.
 */
- (void)createRideWithToken:(NSString *)token withCompletion:(void(^)(NSError * _Nullable error))completionHandler;


/**
 This method will update an existing ride that is associated with the passed-in authentication token.

 @param token The authentication token associated with the user. This parameter is used to find and update the correct ride on the server that is associated with this authentication token's user.
 @param completionHandler A completion handler to handle anything that needs to be done after the network request has finished.
 */
- (void)updateRideWithToken:(NSString *)token withCompletion:(void(^)(NSError * _Nullable error))completionHandler;


/**
 This method will create a new user using the authentication token. If the authentication token already exists in the database, a new user is not created and we will receive the existing user information. This method definition is a work-in-progress.

 @param token The authentication token associated with the user. This parameter is used to find the existing user associated with it or, if not associated user is found, to create in the database a new user associated with it.
 @param completionHandler A completion handler to handle anything that needs to be done after the network request has finished.
 */
- (void)authenticateUserWithToken:(NSString *)token withCompletion:(void(^)(NSError * _Nullable error, NSArray *_Nullable userArray, NSString * _Nullable userType))completionHandler;

@end

NS_ASSUME_NONNULL_END
