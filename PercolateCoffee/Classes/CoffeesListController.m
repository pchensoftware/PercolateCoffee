//
//  ViewController.m
//  PercolateCoffee
//
//  Created by pchen on 5/19/15.
//  Copyright (c) 2015 Peter Chen. All rights reserved.
//

#import "CoffeesListController.h"
#import "CoffeesListTableCell.h"
#import "CoffeeDataManager.h"
#import "CoffeeController.h"
#import "NavbarLogoView.h"

@interface CoffeesListController () <UITableViewDataSource, UITableViewDelegate, CoffeeControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CoffeesListController

- (void)viewDidLoad {
   [super viewDidLoad];
   
   self.navigationItem.titleView = [[NavbarLogoView alloc] initWithFrame:CGRectMake(0, 0, kNavbarLogoViewWidth, kNavbarLogoViewHeight)];
   self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
   
   self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
   self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   self.tableView.dataSource = self;
   self.tableView.delegate = self;
   [self.tableView registerClass:[CoffeesListWithImageTableCell class] forCellReuseIdentifier:@"CoffeeCellWithImageId"];
   [self.tableView registerClass:[CoffeesListWithoutImageTableCell class] forCellReuseIdentifier:@"CoffeeCellWithoutImageId"];
   [self.view addSubview:self.tableView];
   
   // iOS 8 only
   //self.tableView.rowHeight = UITableViewAutomaticDimension;
   //self.tableView.estimatedRowHeight = 200;
   
   [[CoffeeDataManager manager] downloadAllCoffeesCompletion:^(NSArray *coffees) {
      [self.tableView reloadData];
   }];
}

- (void)viewWillAppear:(BOOL)animated {
   [super viewWillAppear:animated];
   [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

//====================================================================================================
#pragma mark - Table view
//====================================================================================================

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return [[CoffeeDataManager manager].coffees count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   Coffee *coffee = [CoffeeDataManager manager].coffees[indexPath.row];
   if ([coffee hasImageURL])
      return [CoffeesListTableCell heightForCoffee:coffee tableView:tableView reuseIdentifier:@"CoffeeCellWithImageId"];
   else
      return [CoffeesListTableCell heightForCoffee:coffee tableView:tableView reuseIdentifier:@"CoffeeCellWithoutImageId"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   Coffee *coffee = [CoffeeDataManager manager].coffees[indexPath.row];
   
   CoffeesListTableCell *cell;
   if ([coffee hasImageURL])
      cell = [tableView dequeueReusableCellWithIdentifier:@"CoffeeCellWithImageId" forIndexPath:indexPath];
   else
      cell = [tableView dequeueReusableCellWithIdentifier:@"CoffeeCellWithoutImageId" forIndexPath:indexPath];
   
   cell.coffee = coffee;
   return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   CoffeeController *controller = [[CoffeeController alloc] init];
   Coffee *selectedCoffee = [CoffeeDataManager manager].coffees[indexPath.row];
   controller.coffee = selectedCoffee;
   controller.delegate = self;
   [self.navigationController pushViewController:controller animated:YES];
}

//====================================================================================================
#pragma mark - CoffeeControllerDelegate
//====================================================================================================

- (void)coffeeControllerDidUpdateCoffee:(CoffeeController *)controller {
   NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
   if (indexPath) {
      [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
      [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
      [self.tableView beginUpdates];
      [self.tableView endUpdates];
   }
}

@end
