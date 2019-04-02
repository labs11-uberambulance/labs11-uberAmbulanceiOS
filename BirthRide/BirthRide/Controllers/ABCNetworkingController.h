//
//  NetworkingController.h
//  BirthRide
//
//  Created by Austin Cole on 3/26/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PregnantMom;
@class Driver;
@class User;
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
 This method is a POST request to the server. It will onboard the user with the user-type and mother/driver information.
 
 @param token This is the firebase token that you receive during the authentication process.
 @param userID This is the userID that is passed back from the initial BE authentication GET request. It is used in the urlRequest.
 @param user This is the user, containing the information that is general to every user.
 @param driver This is left nil unless the user is a driver.
 @param mother This is left nil unless the user is a mother.
 @param completionHandler A completion handler to handle anything that needs to be done after the network request has finished.
 */
- (void)onboardUserWithToken:(NSString *)token withUserID:(NSNumber *)userID withUser: (User *)user withDriver:(Driver * _Nullable)driver withMother:(PregnantMom * _Nullable)mother withCompletion:(void (^)(NSError * _Nullable))completionHandler;

/**
 This method is a PUT request to the server. It will update the user and mother/driver-specific information.

 @param token This is the firebase token that you receive during the authentication process.
 @param userID This is the userID that is passed back from the initial BE authentication GET request. It is used in the urlRequest.
 @param user This is the user, containing the information that is general to every user.
 @param driver This is left nil unless the user is a driver.
 @param mother This is left nil unless the user is a mother.
 @param completionHandler A completion handler to handle anything that needs to be done after the network request has finished.
 */
- (void)updateUserWithToken:(NSString *)token withUserID:(NSNumber *)userID withUser: (User *)user withDriver:(Driver * _Nullable)driver withMother:(PregnantMom * _Nullable)mother withCompletion:(void (^)(NSError * _Nullable))completionHandler;

///This method will create a ride on the server.
/**
 This method will create a new ride and will associate the ride with the user associated with the passed-in authentication token.

 @param token The authentication token associated with the user. This parameter is used to associate the created ride with a specific user.
 @param completionHandler A completion handler to handle anything that needs to be done after the network request has finished.
 */
- (void)createRideWithToken:(NSString *)token withCompletion:(void(^)(NSError * _Nullable error))completionHandler ;


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
