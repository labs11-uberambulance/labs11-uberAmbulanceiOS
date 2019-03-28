//
//  NSString+ConvertFromSnakeCaseToCamelCase.m
//  BirthRide
//
//  Created by Austin Cole on 3/28/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

#import "NSString+ConvertFromSnakeCaseToCamelCase.h"

@implementation NSString (ConvertFromSnakeCaseToCamelCase)

- (NSString *)convertFromSnakeCaseToCamelCase {
    NSString *newString = [[self stringByReplacingOccurrencesOfString:@"_" withString:@" "] capitalizedString];
    return [[newString stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
}

@end
