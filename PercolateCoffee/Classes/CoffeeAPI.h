//====================================================================================================
// Author: Peter Chen
// Created: 5/19/15
// Copyright 2015 Peter Chen
//====================================================================================================

#import <Foundation/Foundation.h>
#import "Coffee.h"

@interface CoffeeAPI : NSObject

- (void)getAllCoffeesCompletion:(void(^)(NSArray *coffees))completion;
- (void)getCoffeeDetailsForIdStr:(NSString *)idstr completion:(void(^)(Coffee *tmpCoffee))completion;

@end
