//====================================================================================================
// Author: Peter Chen
// Created: 5/19/15
// Copyright 2015 Peter Chen
//====================================================================================================

#import <Foundation/Foundation.h>
#import "Coffee.h"

#define kCoffeeDataManager_DidDownloadAllCoffeesNotification   @"kCoffeeDataManager_DidDownloadAllCoffeesNotification"

@interface CoffeeDataManager : NSObject

@property (nonatomic, strong) NSArray *coffees;

+ (instancetype)manager;
- (void)downloadAllCoffeesCompletion:(void(^)(NSArray *coffees))completion;
- (void)downloadAndUpdateCoffeeDetails:(Coffee *)coffee completion:(void(^)(void))completion;

@end
