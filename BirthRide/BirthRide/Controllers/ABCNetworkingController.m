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
- (void)fetchNearbyDriversWithToken:(NSString *)token withMother:(PregnantMom *)mother withCompletion:(void (^)(NSError * _Nullable, NSArray<Driver *> * _Nullable))completionHandler {
   
   NSURL *baseURL = [NSURL URLWithString:@"https://birthrider-backend.herokuapp.com/api/rides/drivers"];
   NSMutableURLRequest *requestURL = [NSMutableURLRequest requestWithURL:baseURL];
   [requestURL setHTTPMethod:@"POST"];
   [requestURL setValue:token forHTTPHeaderField:@"Authorization"];
   
   //I was getting an error with my networking because I was not sending valid JSON. When I would po my coordinateString in the console, the colon would be replaced by an equal sign. I had to add the below header, at the suggestion of Matt, to let the back-end know that I am indeed sending JSON.
   [requestURL setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
   
   NSDictionary *coordinateString = @{@"location": mother.start.latLong};
   
   NSData *coordinateData = [NSJSONSerialization dataWithJSONObject:coordinateString options:NSJSONWritingPrettyPrinted error: NULL];
   [requestURL setHTTPBody:coordinateData];
   
   [[NSURLSession.sharedSession dataTaskWithRequest:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      if (error != nil) {
         NSLog(@"Error in ABCNetworkingController.m.fetchNearbyDriversWithLatitude:");
         completionHandler(error, nil);
         return;
      }
      if (data == nil) {
         NSLog(@"Data is nil in ABCNetworkingController.m.fetchNearbyDriversWithLatitude:");
         completionHandler(nil, nil);
         return;
      }
      
      NSArray *driversDictionaryArray = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingAllowFragments error: NULL];
      
      NSMutableArray<Driver *> *driversArray = [[NSMutableArray alloc] init];
      
      for (int i = 0; i < driversDictionaryArray.count; i++) {
         Driver *newDriver = [[Driver alloc] initWithPrice:@(99) requestedDriverName:nil isActive:false bio:@"" photo:nil driverId:nil firebaseId:nil];
         NSDictionary *driverDictionary = driversDictionaryArray[i];
         [driverDictionary[@"driver"] enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop){
            if ([key containsString:@"_"]) {
               key = [key convertFromSnakeCaseToCamelCase];
            }
            if ([key isEqualToString:@"location"]) {
               newDriver.location.latLong = driverDictionary[key][@"latlng"];
            }
            SEL selector = NSSelectorFromString(key);
            if ([newDriver respondsToSelector: selector] && value != NSNull.null) {
               [newDriver setValue:value forKey:key];
            }
         }];
         [driverDictionary[@"distance"] enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop){
            if ([key isEqualToString:@"text"]) {
               newDriver.distance = driverDictionary[@"distance"][key];
            }
            SEL selector = NSSelectorFromString(key);
            if ([newDriver respondsToSelector: selector] && value != NSNull.null) {
               [newDriver setValue:value forKey:key];
            }
         }];
         [driverDictionary[@"duration"] enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop){
            if ([key isEqualToString:@"text"]) {
               newDriver.duration = driverDictionary[@"duration"][key];
            }
            SEL selector = NSSelectorFromString(key);
            if ([newDriver respondsToSelector: selector] && value != NSNull.null) {
               [newDriver setValue:value forKey:key];
            }
         }];
         [driversArray addObject: newDriver];
         
      }
      completionHandler(nil, driversArray);
      
   }] resume];
}



- (void)onboardUserWithToken:(NSString *)token withUserID:(NSNumber *)userID withUser:(User *)user withDriver:(Driver *)driver withMother:(PregnantMom *)mother withCompletion:(void (^)(NSError * _Nullable))completionHandler {
   
   NSURL *baseURL = [NSURL URLWithString:@"https://birthrider-backend.herokuapp.com/api/users/onboard"];
   NSURL *appendedURL = [baseURL URLByAppendingPathComponent: userID.stringValue];
   NSMutableURLRequest *requestURL = [NSMutableURLRequest requestWithURL:appendedURL];
   [requestURL setHTTPMethod:@"POST"];
   [requestURL setValue:token forHTTPHeaderField:@"Authorization"];
   [requestURL setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
   
   if (mother == nil && driver == nil) {
      completionHandler(nil);
      return;
   }
   if (driver != nil) {
      NSData *driverData = [[NSData alloc] init];
      driverData = [NSJSONSerialization dataWithJSONObject: driver options:NSJSONWritingPrettyPrinted error: NULL];
      NSDictionary *userDictionary = @{
                                       @"user_type": @"drivers",
                                       @"driverData": driverData
                                       };
      NSData *dictionaryData = [[NSData alloc] init];
      dictionaryData = [NSJSONSerialization dataWithJSONObject:userDictionary options:NSJSONWritingPrettyPrinted error: NULL];
      [requestURL setHTTPBody:dictionaryData];
   }
   else {
      
      NSNull *noData = [[NSNull alloc] init];
      
      NSDictionary *dataDictionary = @{
                                       @"user_type": @"mother",
                                       @"motherData": @{
                                             //                                                 @"mother_id":noData,
                                             @"caretaker_name": @"test",
                                             @"start": @{
                                                   @"latlng": mother.start.latLong,
                                                   @"name": @"test",
                                                   //                                                         @"descr": noData
                                                   },
                                             @"destination": @{
                                                   @"latlng": mother.destination.latLong,
                                                   @"name": mother.destination.name,
                                                   //                                                         @"descr": noData
                                                   }
                                             }
                                       };
      
      
      
      
      NSData *dictionaryData = [[NSData alloc] init];
      dictionaryData = [NSJSONSerialization dataWithJSONObject:dataDictionary options:NSJSONWritingPrettyPrinted error: NULL];
      [requestURL setHTTPBody:dictionaryData];
   }
   
   [[NSURLSession.sharedSession dataTaskWithRequest:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      if (error != nil) {
         NSLog(@"%@", error.localizedDescription);
         completionHandler(error);
         return;
      }
      if (data == nil) {
         completionHandler(nil);
         return;
      }
      NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
      [jsonResponse allKeys];
      completionHandler(nil);
   }] resume];
   
}

- (void)updateUserWithToken:(NSString *)token withUserID:(NSNumber *)userID withUser: (User *)user withDriver:(Driver * _Nullable)driver withMother:(PregnantMom * _Nullable)mother withCompletion:(void (^)(NSError * _Nullable))completionHandler {
   
   NSURL *baseURL = [NSURL URLWithString:@"https://birthrider-backend.herokuapp.com/api/users/update"];
   NSURL *appendedURL = [baseURL URLByAppendingPathComponent: userID.stringValue];
   NSMutableURLRequest *requestURL = [NSMutableURLRequest requestWithURL:appendedURL];
   [requestURL setHTTPMethod:@"PUT"];
   [requestURL setValue:token forHTTPHeaderField:@"Authorization"];
   [requestURL setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
   
   if (mother == nil && driver == nil) {
      return;
   }
   
   NSNull *noData = [[NSNull alloc] init];
   
   NSDictionary *userDictionary = [[NSDictionary alloc] init];
   
   
   NSDictionary *jsonDictionary;
   
   if (driver != nil) {
      
      userDictionary = @{
                         @"name": user.name,
                         @"phone": user.phone,
                         };
      //I was struggling for a minute with an error here. I was trying to pass the BOOL into the dictionary, but dictionaries only take objects and BOOLs are primitives.
      NSDictionary *driverDataDictionary = @{
                                             @"id": driver.driverId,
                                             @"firebase_id": driver.firebaseId,
                                             @"price": driver.price,
                                             
                                             @"active":
                                             [NSNumber numberWithBool:driver.isActive],
                                             @"bio": driver.bio,
                                             @"photo_url":
                                                driver.photoUrl
                                             
                                             };
      
      jsonDictionary = @{
                         @"user": userDictionary,
                         @"driver": driverDataDictionary
                         };
      
      NSData *dictionaryData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:NSJSONWritingPrettyPrinted error: NULL];
      [requestURL setHTTPBody:dictionaryData];
   }
   else {
      userDictionary = @{
                         @"name": user.name,
                         @"phone": user.phone,
                         @"location": @{
                               @"latlng": mother.start.latLong,
                               @"name": noData,
                               @"descr": noData
                               },
                         };
      NSDictionary *motherDictionary = @{
                                         @"start": @{
                                               @"latlng": mother.start.latLong,
                                               @"name": user.village,
                                               @"descr": noData,
                                               }
                                         };
      jsonDictionary = @{
                         @"user": userDictionary,
                         @"mother": motherDictionary
                         };
      NSData *dictionaryData = [[NSData alloc] init];
      dictionaryData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:NSJSONWritingPrettyPrinted error: NULL];
      [requestURL setHTTPBody:dictionaryData];
   }
   
   [[NSURLSession.sharedSession dataTaskWithRequest:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      if (error != nil) {
         NSLog(@"%@", error.localizedDescription);
         return;
      }
      if (data != nil) {
         NSDictionary *this = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
         NSLog(@"hope this works");
      }
      
   }] resume];
}



- (void)requestDriverWithToken:(NSString *)token withDriver:(Driver *)driver withMother:(PregnantMom *)mother withUser:(User *)user withCompletion:(void (^)(NSError * _Nullable))completionHandler {
   
   NSURL *baseURL = [[NSURL alloc] initWithString:@"https://birthrider-backend.herokuapp.com/request/driver"];
   NSURL *completeBaseURL = [baseURL URLByAppendingPathComponent: driver.firebaseId];
   NSMutableURLRequest *requestURL = [[NSMutableURLRequest alloc] initWithURL:completeBaseURL];
   [requestURL setHTTPMethod:@"POST"];
   [requestURL setValue:token forHTTPHeaderField:@"Authorization"];
   [requestURL setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
   
   NSDictionary *newRideDictionary = @{
                                       @"end": mother.destination.latLong,
                                       @"start": mother.start.latLong,
                                       @"hospital": mother.destination.name,
                                       @"name": user.name,
                                       @"phone": user.phone,
                                       };
   
   NSData *newRideData = [[NSData alloc] init];
   newRideData = [NSJSONSerialization dataWithJSONObject:newRideDictionary options:NSJSONWritingPrettyPrinted error:nil];
   
   [requestURL setHTTPBody:newRideData];
   
   [[NSURLSession.sharedSession dataTaskWithRequest:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      if (error != nil) {
         NSLog(@"Error in ABCNetworkingController.requestDriverWithToken");
         NSLog(@"%@", error.localizedDescription);
         completionHandler(error);
         return;
      }
      if (data != nil) {
         NSLog(@"%@", data);
         return;
      }
   }] resume];
}

- (void)fetchRideWithToken:(NSString *)token withCompletion:(void(^)(NSError * _Nullable error, Ride *ride))completionHandler {
   
}

- (void)updateRideWithToken:(NSString *)token withCompletion:(void(^)(NSError * _Nullable))completionHandler {
   
}

- (void)driverAcceptsOrRejectsRideWithToken:(NSString *)token withRideId:(NSNumber *)rideId withDidAccept:(BOOL)didAccept withRideData:(RequestedRide * _Nullable)requestedRide withCompletion:(void (^)(NSError * _Nullable))completionHandler {
   NSURL *baseURL = [[NSURL alloc] initWithString: @"https://birthrider-backend.herokuapp.com/api/rides/driver"];
   NSURL *baseURLWithMethod;
   if (didAccept) {
      baseURLWithMethod = [baseURL URLByAppendingPathComponent: @"accepts"];
   }
   else  {
      baseURLWithMethod = [baseURL URLByAppendingPathComponent: @"rejects"];
   }
   NSURL *completeURL = [baseURLWithMethod URLByAppendingPathComponent: [rideId stringValue]];
   NSMutableURLRequest *requestURL = [[NSMutableURLRequest alloc] initWithURL:completeURL];
   if (didAccept) {
      [requestURL setHTTPMethod:@"POST"];
      NSDictionary *requestedRideDictionary = @{
                                                @"data": requestedRide
                                                };
      NSData *requestedRideData = [NSJSONSerialization dataWithJSONObject:requestedRideDictionary options:NSJSONWritingPrettyPrinted error:NULL];
      [requestURL setHTTPBody:requestedRideData];
   }
   else {
      [requestURL setHTTPMethod:@"GET"];
   }
   
   [[NSURLSession.sharedSession dataTaskWithRequest:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      if (error != nil) {
         NSLog(@"Error in ABCNetworkingController.driverAcceptsOrRejectsRide:...");
         NSLog(@"%@", error.localizedDescription);
         return;
      }
   }] resume];
}




//I was getting errors when I was trying to pass the error into my completionHandler. It was an ARC error. The problem was that I was adding in an extra "asterisk", or saying that there was an extra pointer. The completionHandler couldn't take the error in that way. This is what it looked like when I was getting the error: NSError * _Nullable *error. That second asterisk was tripping me up.

- (void)authenticateUserWithToken:(NSString *)token withCompletion:(void(^)(NSError * _Nullable, NSArray *_Nullable, NSString * _Nullable))completionHandler {
   
   NSURL *baseURL = [NSURL URLWithString:@"https://birthrider-backend.herokuapp.com/api/users"];
   NSMutableURLRequest *requestURL = [NSMutableURLRequest requestWithURL:baseURL];
   [requestURL setHTTPMethod:@"GET"];
   [requestURL setValue:token forHTTPHeaderField:@"Authorization"];
   [requestURL setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
   
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
            if ([user respondsToSelector: selector] && value != NSNull.null) {
               //On line 85 we are LOOKING FOR a method called `setProperty` to SET the PROPERTY with the VALUE. IF THIS METHOD IS NOT FOUND the selector GENERATES a METHOD called `setProperty` to SET the value of the PARAMETER matching the KEY
               [user setValue:value forKey:key];
            }
         }];
         [userArray insertObject:user atIndex:0];
         pregnantMom.start = [[Start alloc] initWithLatLong:@"555" name:@"test" startDescription:NULL];
         
         pregnantMom.destination = [[Destination alloc] initWithLatLong:@"555" name:@"test" destinationDescription:NULL];
         if (user.userType != nil) {
            if ([user.userType isEqualToString:@"mothers"]) {
               [parsedData[userTypeKey] enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop){
                  
                  if ([key containsString:@"_"]) {
                     key = [key convertFromSnakeCaseToCamelCase];
                  }
                  if ([key isEqualToString:@"id"]) {
                     pregnantMom.motherId = parsedData[@"motherData"][key];
                  }
                  if ([key isEqualToString:@"start"]) {
                     [parsedData[userTypeKey][@"start"] enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  value, BOOL* stop) {
                        if ([key isEqualToString:@"latlng"]) {
                           [pregnantMom.start setValue:value forKey:@"latLong"];
                        }
                        SEL selector = NSSelectorFromString(key);
                        if ([pregnantMom.start respondsToSelector:selector] && value != NSNull.null) {
                           [pregnantMom.start setValue:value forKey:key];
                        }
                     }];
                     
                  }
                  
                  if ([key isEqualToString:@"destination"]) {
                     [parsedData[userTypeKey][@"destination"] enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  value, BOOL* stop) {
                        if ([key isEqualToString:@"latlng"]) {
                           [pregnantMom.destination setValue:value forKey:@"latLong"];
                        }
                        SEL selector = NSSelectorFromString(key);
                        if ([pregnantMom.destination respondsToSelector:selector] && value != NSNull.null) {
                           [pregnantMom.destination setValue:value forKey:key];
                        }
                     }];
                     
                  }
                  if ([key isEqualToString:@"id"]) {
                     pregnantMom.motherId = parsedData[@"motherData"][key];
                  };
                  //I was getting an error for so over an hour in the RequestRideVC. I would get the error whenever I would try to access the latLong string. This is because I was assigning a dictionary to the pregnantMom's start object AFTER figuring out all of the start object's properties.
                  if (![key isEqual: @"start"] && ![key isEqual:@"destination"]) {
                     SEL selector = NSSelectorFromString(key);
                     if ([pregnantMom respondsToSelector:selector] && value != NSNull.null) {
                        [pregnantMom setValue:value forKey:key];
                     }
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
                     driver.driverId = parsedData[@"driverData"][key];
                  };
                  SEL selector = NSSelectorFromString(key);
                  if ([driver respondsToSelector:selector] && value != NSNull.null) {
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
