//====================================================================================================
// Author: Peter Chen
// Created: 5/19/15
// Copyright 2015 Peter Chen
//====================================================================================================

#import <UIKit/UIKit.h>
#import "Coffee.h"

@interface CoffeesListTableCell : UITableViewCell

@property (nonatomic, strong) Coffee *coffee;

+ (CGFloat)heightForCoffee:(Coffee *)coffee tableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier;

@end

@interface CoffeesListWithImageTableCell : CoffeesListTableCell

@end

@interface CoffeesListWithoutImageTableCell : CoffeesListTableCell

@end
