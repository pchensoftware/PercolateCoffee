//====================================================================================================
// Author: Peter Chen
// Created: 5/19/15
// Copyright 2015 Peter Chen
//====================================================================================================

#import <UIKit/UIKit.h>
#import "Coffee.h"

@class CoffeeController;

@protocol CoffeeControllerDelegate <NSObject>
- (void)coffeeControllerDidUpdateCoffee:(CoffeeController *)controller;
@end

@interface CoffeeController : UIViewController

@property (nonatomic, strong) Coffee *coffee;
@property (nonatomic, weak) id<CoffeeControllerDelegate> delegate;

@end
