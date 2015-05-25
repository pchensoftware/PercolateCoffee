//
//  Coffee.h
//  PercolateCoffee
//
//  Created by pchen on 5/19/15.
//  Copyright (c) 2015 Peter Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>

@interface Coffee : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * idstr;
@property (nonatomic, retain) NSString * image_url;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * last_updated_at;
@property (nonatomic, retain) NSDate * last_updated;

+ (Coffee *)createNewCoffee;
+ (NSArray *)getAllCoffees;
+ (Coffee *)getCoffeeWithIdStr:(NSString *)idstr;
+ (void)deleteAllCoffees;
+ (NSArray *)updateAndReplaceWithJsons:(NSArray *)jsons;
- (void)setupWithJson:(NSDictionary *)json;
- (void)updateFromCoffee:(Coffee *)coffee;
- (BOOL)hasImageURL;

@end
