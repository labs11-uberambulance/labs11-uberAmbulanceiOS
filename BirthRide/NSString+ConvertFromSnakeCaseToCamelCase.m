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
    NSArray *newStringArray = [self componentsSeparatedByString:@"_"];
    NSMutableArray *newStringMutableArray = [newStringArray mutableCopy];
    for (int i = 1; i < newStringArray.count; i++) {
        NSString *newString = [newStringArray[i] capitalizedString];
        [newStringMutableArray removeObjectAtIndex: i];
        [newStringMutableArray insertObject:newString atIndex:i];
    }
    return [newStringMutableArray componentsJoinedByString:@""];
}

@end
