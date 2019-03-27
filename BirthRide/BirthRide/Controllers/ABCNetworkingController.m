//
//  NetworkingController.m
//  BirthRide
//
//  Created by Austin Cole on 3/26/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

#import "ABCNetworkingController.h"
#import "BirthRide-Swift.h"

@implementation ABCNetworkingController

- (void)fetchMotherWithToken:(NSString *)token withCompletion:(void (^)(NSError * _Nonnull))completionHandler {
    
}

- (void)fetchNearbyDriversWithLatitude:(double)latitude withLongitude:(double)longitude withCompletion:(void (^)(NSError * _Nonnull))completionHandler {
    
}

- (void)fetchRideWithToken:(NSString *)token withCompletion:(Ride *(^)(NSError * _Nullable *error))completionHandler {
    
}

- (void)updateUserWithToken:(NSString *)token userType:(NSString *)userType withCompletion:(void(^)(NSError * _Nullable *error))completionHandler {
    
}

- (void)createRideWithToken:(NSString *)token withCompletion:(void(^)(NSError * _Nullable *error))completionHandler {
    
}

- (void)updateRideWithToken:(NSString *)token withCompletion:(void(^)(NSError * _Nullable *error))completionHandler {
    
}

- (void)authenticateUserWithToken:(NSString *)token withCompletion:(void(^)(NSError * _Nullable *error))completionHandler {
    
}

@end
