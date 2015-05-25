//====================================================================================================
// Author: Peter Chen
// Created: 5/24/15
// Copyright 2015 Peter Chen
//====================================================================================================

#import <UIKit/UIKit.h>
#import "Coffee.h"

@interface CoffeeView : UIView

@property (nonatomic, strong) Coffee *coffee;
@property (nonatomic, readonly) UIImage *image;

- (void)didUpdateCoffee;

@end
