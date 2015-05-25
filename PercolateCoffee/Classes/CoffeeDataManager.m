//====================================================================================================
// Author: Peter Chen
// Created: 5/19/15
// Copyright 2015 Peter Chen
//====================================================================================================

#import "CoffeeDataManager.h"
#import "CoffeeAPI.h"

@interface CoffeeDataManager()

@property (nonatomic, strong) CoffeeAPI *api;

@end

@implementation CoffeeDataManager

+ (instancetype)manager {
   static CoffeeDataManager *_shared = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      _shared = [[CoffeeDataManager alloc] init];
   });
   return _shared;
}

- (id)init {
   if ((self = [super init])) {
      self.api = [[CoffeeAPI alloc] init];
   }
   return self;
}

- (void)downloadAllCoffeesCompletion:(void(^)(NSArray *coffees))completion {
   [self.api getAllCoffeesCompletion:^(NSArray *coffees) {
      self.coffees = coffees;
      if (completion) completion(coffees);
   }];
}

- (void)downloadAndUpdateCoffeeDetails:(Coffee *)coffee completion:(void(^)(void))completion {
   [self.api getCoffeeDetailsForIdStr:coffee.idstr completion:^(Coffee *tmpCoffee) {
      [coffee updateFromCoffee:tmpCoffee];
      if (completion) completion();
   }];
}

@end
