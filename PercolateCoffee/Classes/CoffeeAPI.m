//====================================================================================================
// Author: Peter Chen
// Created: 5/19/15
// Copyright 2015 Peter Chen
//====================================================================================================

#import "CoffeeAPI.h"
#import <AFNetworking.h>

#define kAPIUrl   @"https://coffeeapi.percolate.com"
#define kAPIKey   @"WuVbkuUsCXHPx3hsQzus4SE"

@interface CoffeeAPI()

@property (nonatomic, strong) AFHTTPRequestOperationManager *httpManager;

@end

@implementation CoffeeAPI

- (id)init {
   if ((self = [super init])) {
      self.httpManager = [[AFHTTPRequestOperationManager alloc] init];
      [self.httpManager.requestSerializer setValue:kAPIKey forHTTPHeaderField:@"Authorization"];
   }
   return self;
}

- (void)getAllCoffeesCompletion:(void(^)(NSArray *coffees))completion {
   NSString *url = [kAPIUrl stringByAppendingString:@"/api/coffee/"];
   [self.httpManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
      NSArray *coffees = [Coffee updateAndReplaceWithJsons:responseObject];
      if (completion) completion(coffees);
      
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      NSLog(@"Error: %@", error);
   }];
}

- (void)getCoffeeDetailsForIdStr:(NSString *)idstr completion:(void(^)(Coffee *tmpCoffee))completion {
   NSString *url = [kAPIUrl stringByAppendingFormat:@"/api/coffee/%@", idstr];
   [self.httpManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
      Coffee *tmpCoffee = [Coffee createNewCoffee];
      [tmpCoffee setupWithJson:responseObject];
      if (completion) completion(tmpCoffee);
      [tmpCoffee MR_deleteEntity];
      
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      NSLog(@"Error: %@", error);
   }];
}

@end
