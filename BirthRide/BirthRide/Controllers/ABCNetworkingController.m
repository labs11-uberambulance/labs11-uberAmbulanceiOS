//
//  NetworkingController.m
//  BirthRide
//
//  Created by Austin Cole on 3/26/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

#import "ABCNetworkingController.h"
#import "BirthRide-Swift.h"
#import "NSString+ConvertFromSnakeCaseToCamelCase.h"

@implementation ABCNetworkingController

- (void)fetchMotherWithToken:(NSString *)token withCompletion:(void (^)(NSError * _Nonnull))completionHandler {
    
}

- (void)fetchNearbyDriversWithLatitude:(double)latitude withLongitude:(double)longitude withCompletion:(void (^)(NSError * _Nullable error))completionHandler {
    
}

- (void)fetchRideWithToken:(NSString *)token withCompletion:(void(^)(NSError * _Nullable error, Ride *ride))completionHandler {
    
}

- (void)updateUserWithToken:(NSString *)token userType:(NSString *)userType withCompletion:(void(^)(NSError * _Nullable error))completionHandler {
    
}

- (void)createRideWithToken:(NSString *)token withCompletion:(void(^)(NSError * _Nullable error))completionHandler {
    
}

- (void)updateRideWithToken:(NSString *)token withCompletion:(void(^)(NSError * _Nullable error))completionHandler {
    
}

//I was getting errors when I was trying to pass the error into my completionHandler. It was an ARC error. The problem was that I was adding in an extra "asterisk", or saying that there was an extra pointer. The completionHandler couldn't take the error in that way. This is what it looked like when I was getting the error: NSError * _Nullable *error. That second asterisk was tripping me up.

- (void)authenticateUserWithToken:(NSString *)token withCompletion:(void(^)(NSError * _Nullable error, NSArray *_Nullable userArray, NSString * _Nullable userType))completionHandler {
    
    NSURL *baseURL = [NSURL URLWithString:@"https://birthrider-backend.herokuapp.com/api/users"];
    NSMutableURLRequest *requestURL = [NSMutableURLRequest requestWithURL:baseURL];
    [requestURL setHTTPMethod:@"GET"];
    [requestURL setValue:token forHTTPHeaderField:@"Authorization"];
    
    [[NSURLSession.sharedSession dataTaskWithRequest:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error performing dataTask in ABCNetworkingController.m");
            NSLog(@"%@", [error localizedDescription]);
            completionHandler(error, nil, nil);
            return;
        }
        NSString *userType = [[NSString alloc] init];
        NSString *userTypeKey = [[NSString alloc] init];
        NSMutableArray *userArray = [[NSMutableArray alloc] init];
        if (data != nil) {
            NSDictionary *parsedData = [[NSDictionary alloc] init];
            parsedData = [NSJSONSerialization JSONObjectWithData:data options:0 error: nil];
            if ([parsedData[@"user"][@"user_type"]  isEqual: @"mothers"]) {
                userType = @"mothers";
                userTypeKey = @"motherData";
            } else if ([parsedData[@"user"][@"user_type"]  isEqual: @"drivers"]) {
                userType = @"drivers";
                userTypeKey = @"driverData";
            }
            User *user = [User alloc];
            PregnantMom *pregnantMom = [PregnantMom alloc];
            Driver *driver = [Driver alloc];
            
            //This `enumerateKeysAndObj...` will iterate over all the keys of the dictionary for me
            [parsedData[@"user"] enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop){
                if ([key containsString:@"_"]) {
                    key = [key convertFromSnakeCaseToCamelCase];
                }
                if ([key isEqualToString:@"id"]) {
                    user.userID = parsedData[@"user"][key];
                };
                //What is a selector? A selector is a METHOD. A message is a METHOD + ARGUMENTS. Line 59 is, at RUNTIME, CREATING a NEW METHOD using the KEY.
                SEL selector = NSSelectorFromString(key);
                //On line 83 we are sending a MESSAGE to the OBJECT using the SELECTOR to ASK the OBJECT if it contains a property with the NAME of the SELECTOR
                if ([user respondsToSelector: selector]) {
                    //On line 85 we are LOOKING FOR a method called `setProperty` to SET the PROPERTY with the VALUE. IF THIS METHOD IS NOT FOUND the selector GENERATES a METHOD called `setProperty` to SET the value of the PARAMETER matching the KEY
                    [user setValue:value forKey:key];
                }
            }];
            [userArray insertObject:user atIndex:0];
            if (user.userType != nil) {
                if ([user.userType isEqualToString:@"mothers"]) {
                    [parsedData[userTypeKey] enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop){
                        if ([key containsString:@"_"]) {
                            key = [key convertFromSnakeCaseToCamelCase];
                        }
                        if ([key isEqualToString:@"id"]) {
                            [pregnantMom setValue:parsedData[@"motherData"][key] forKey:@"motherID"];
                        };
                        SEL selector = NSSelectorFromString(key);
                        if ([pregnantMom respondsToSelector:selector]) {
                            [pregnantMom setValue:value forKey:key];
                        }
                    }];
                    [userArray addObject:pregnantMom];
                };
                if ([user.userType isEqualToString:@"drivers"]) {
                    [parsedData[userTypeKey] enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop){
                        if ([key containsString:@"_"]) {
                            key = [key convertFromSnakeCaseToCamelCase];
                        }
                        if ([key isEqualToString:@"id"]) {
                            driver.driverID = parsedData[@"user"][key];
                        };
                        SEL selector = NSSelectorFromString(key);
                        if ([driver respondsToSelector:selector]) {
                            [driver setValue:value forKey:key];
                        }
                    }];
                    [userArray addObject:driver];
                }
            
            };
            completionHandler(nil, userArray, userType);
        };
        
        
    }] resume];
    
}

@end
