//
//  NetworkingController.h
//  BirthRide
//
//  Created by Austin Cole on 3/26/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BirthRide-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkingController : NSObject

- (void)fetchNearbyDriversWithLatitude:(double)latitude withLongitude:(double)longitude withCompletion:(void(^)(NSError *error))completionHandler;

- (void)fetchMotherWithToken:(NSString *)token withCompletion:(PregnantMom *(^)(NSError *error))completionHandler;

- (void)fetchMotherWithToken:(NSString *)token withCompletion:(Ride *(^)(NSError *error))completionHandler;

- (void)updateUserWithToken:(NSString *)token userType:(NSString *)userType withCompletion:(void(^)(NSError *error))completionHandler;

- (void)createRideWithToken:(NSString *)token withCompletion:(void(^)(NSError *error))completionHandler;

- (void)updateRideWithToken:(NSString *)token withCompletion:(void(^)(NSError *error))completionHandler;

- (void)authenticateUserWithToken:(NSString *)token withCompletion:(void(^)(NSError *error))completionHandler;

@end

NS_ASSUME_NONNULL_END
