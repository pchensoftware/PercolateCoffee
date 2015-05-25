//
//  Coffee.m
//  PercolateCoffee
//
//  Created by pchen on 5/19/15.
//  Copyright (c) 2015 Peter Chen. All rights reserved.
//

#import "Coffee.h"


@implementation Coffee

@dynamic desc;
@dynamic idstr;
@dynamic image_url;
@dynamic name;
@dynamic last_updated_at;
@synthesize last_updated;

+ (Coffee *)createNewCoffee {
   Coffee *coffee = [Coffee MR_createEntity];
   return coffee;
}

+ (NSArray *)getAllCoffees {
   NSArray *coffees = [Coffee MR_findAll];
   return coffees;
}

+ (Coffee *)getCoffeeWithIdStr:(NSString *)idstr {
   Coffee *coffee = [Coffee MR_findFirstByAttribute:@"idstr" withValue:idstr];
   return coffee;
}

+ (void)deleteAllCoffees {
   [Coffee MR_truncateAll];
}

+ (void)deleteCoffeesNotInJsons:(NSArray *)jsons {
   NSArray *idstrs = [jsons valueForKey:@"idstr"];
   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT(idstr IN %@)", idstrs];
   [Coffee MR_deleteAllMatchingPredicate:predicate];
}

+ (NSArray *)updateAndReplaceWithJsons:(NSArray *)jsons {
   [self deleteCoffeesNotInJsons:jsons];
   
   NSMutableArray *coffees = [NSMutableArray array];
   
   for (NSDictionary *json in jsons) {
      Coffee *coffee = [Coffee createNewCoffee];
      [coffee setupWithJson:json];
      [coffees addObject:coffee];
   }
   
   return coffees;
}

// ex. datestr = @"2015-05-17 18:55:00.607100"
+ (NSDate *)dateFromString:(NSString *)datestr {
   static NSDateFormatter *dateFormatter = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      dateFormatter = [[NSDateFormatter alloc] init];
      dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSSSSS";
   });
   return [dateFormatter dateFromString:datestr];
}

- (void)setupWithJson:(NSDictionary *)json {
   [self MR_importValuesForKeysWithObject:json];
   self.last_updated = [Coffee dateFromString:self.last_updated_at];
}

- (void)updateFromCoffee:(Coffee *)coffee {
   self.name = coffee.name;
   self.desc = coffee.desc;
   self.image_url = coffee.image_url;
   self.last_updated_at = coffee.last_updated_at;
   self.last_updated = [Coffee dateFromString:self.last_updated_at];
}

- (BOOL)hasImageURL {
   return [self.image_url length] > 0;
}

@end
