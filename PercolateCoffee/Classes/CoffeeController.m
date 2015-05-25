//====================================================================================================
// Author: Peter Chen
// Created: 5/19/15
// Copyright 2015 Peter Chen
//====================================================================================================

#import "CoffeeController.h"
#import "CoffeeDataManager.h"
#import "UIColor+PercolateCoffee.h"
#import "CoffeeView.h"
#import "NavbarLogoView.h"

@interface CoffeeController()

@property (nonatomic, strong) CoffeeView *coffeeView;

@end

@implementation CoffeeController

- (id)init {
   if ((self = [super init])) {
   }
   return self;
}

- (void)viewDidLoad {
   [super viewDidLoad];
   
   self.navigationItem.titleView = [[NavbarLogoView alloc] initWithFrame:CGRectMake(0, 0, kNavbarLogoViewWidth, kNavbarLogoViewHeight)];
   self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(_actionButtonTapped)];
   
   self.coffeeView = [[CoffeeView alloc] initWithFrame:self.view.bounds];
   self.coffeeView.coffee = self.coffee;
   self.coffeeView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
   [self.view addSubview:self.coffeeView];
   
   [[CoffeeDataManager manager] downloadAndUpdateCoffeeDetails:self.coffee completion:^{
      [self.coffeeView didUpdateCoffee];
      [self.delegate coffeeControllerDidUpdateCoffee:self];
   }];
}

//====================================================================================================
#pragma mark - Events
//====================================================================================================

- (void)_actionButtonTapped {
   NSMutableArray *items = [NSMutableArray arrayWithObjects:self.coffee.name, self.coffee.desc, nil];
   if (self.coffeeView.image)
      [items addObject:self.coffeeView.image];
   NSArray *activities = @[];
   UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:activities];
   [self presentViewController:controller animated:YES completion:nil];
}

@end
