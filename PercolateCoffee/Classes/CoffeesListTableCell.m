//====================================================================================================
// Author: Peter Chen
// Created: 5/19/15
// Copyright 2015 Peter Chen
//====================================================================================================

#import "CoffeesListTableCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+PercolateCoffee.h"
#import "UIView+AutoLayoutHelper.h"

#define kMargin            15
#define kThumbnailHeight   100

@interface CoffeesListTableCell()

@property (nonatomic, strong) UILabel *coffeeNameLabel;
@property (nonatomic, strong) UILabel *coffeeDescriptionLabel;
@property (nonatomic, strong) UIImageView *thumbnailImageView;
@property (nonatomic, strong) NSLayoutConstraint *imageViewWidthContraint;

@end

@implementation CoffeesListTableCell

// Can optimize this method as needed, cache heights.
+ (CGFloat)heightForCoffee:(Coffee *)coffee tableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier {
   static NSMutableDictionary *heightCells = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      heightCells = [NSMutableDictionary dictionary];
   });
   
   CoffeesListTableCell *cell = heightCells[reuseIdentifier];
   if (! cell) {
      cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
      heightCells[reuseIdentifier] = cell;
   }
   
   CGRect bounds = cell.bounds;
   bounds.size.height = 500;
   bounds.size.width = tableView.bounds.size.width;
   cell.bounds = bounds;
   cell.contentView.bounds = bounds;
   
   [cell setTextInfoFromCoffee:coffee];
   [cell setNeedsUpdateConstraints];
   [cell updateConstraintsIfNeeded];
   
   [cell setNeedsLayout];
   [cell layoutIfNeeded];
   
   CGFloat height = 1 + [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
   return height;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
   if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
      self.coffeeNameLabel = [[UILabel alloc] init];
      self.coffeeNameLabel.font = [UIFont systemFontOfSize:17];
      self.coffeeNameLabel.textColor = [UIColor percolateDarkGray];
      self.coffeeNameLabel.numberOfLines = 0;
      [self.contentView addSubview:self.coffeeNameLabel];
      
      self.coffeeDescriptionLabel = [[UILabel alloc] init];
      self.coffeeDescriptionLabel.font = [UIFont systemFontOfSize:17];
      self.coffeeDescriptionLabel.textColor = [UIColor percolateGray];
      self.coffeeDescriptionLabel.numberOfLines = 0;
      [self.contentView addSubview:self.coffeeDescriptionLabel];
      
      self.thumbnailImageView = [[UIImageView alloc] init];
      self.thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
      self.thumbnailImageView.clipsToBounds = YES;
      [self.contentView addSubview:self.thumbnailImageView];
      
      self.coffeeNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
      self.coffeeDescriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
      self.thumbnailImageView.translatesAutoresizingMaskIntoConstraints = NO;
      NSDictionary *viewsDict = @{ @"name" : self.coffeeNameLabel,
                                   @"desc" : self.coffeeDescriptionLabel,
                                   @"thumb" : self.thumbnailImageView, };
      [self.contentView addConstraintFormat:@"H:|-15-[name]-15-|" viewsDict:viewsDict];
      [self.contentView addConstraintFormat:@"H:|-15-[desc]-15-|" viewsDict:viewsDict];
      [self.contentView addConstraintFormat:@"V:|-15-[name]-5-[desc]" viewsDict:viewsDict];
   }
   return self;
}

- (void)layoutSubviews {
   [super layoutSubviews];
   self.coffeeDescriptionLabel.preferredMaxLayoutWidth = self.contentView.bounds.size.width;
}

- (void)updateConstraints {
   if (self.thumbnailImageView.image)
      self.imageViewWidthContraint.constant = kThumbnailHeight * self.thumbnailImageView.image.size.width / self.thumbnailImageView.image.size.height;
   else
      self.imageViewWidthContraint.constant = kThumbnailHeight;

   [super updateConstraints];
}

- (void)setCoffee:(Coffee *)coffee {
   [self setTextInfoFromCoffee:coffee];
   
   self.thumbnailImageView.image = nil;
   if ([coffee hasImageURL]) {
      [self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:coffee.image_url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
         [self setNeedsUpdateConstraints];
      }];
   }
}

- (void)setTextInfoFromCoffee:(Coffee *)coffee {
   _coffee = coffee;
   self.coffeeNameLabel.text = coffee.name;
   self.coffeeDescriptionLabel.text = coffee.desc;
}

@end

//====================================================================================================
#pragma mark - With image
//====================================================================================================

@implementation CoffeesListWithImageTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
   if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
      NSDictionary *viewsDict = @{ @"name" : self.coffeeNameLabel,
                                   @"desc" : self.coffeeDescriptionLabel,
                                   @"thumb" : self.thumbnailImageView, };
      [self.contentView addConstraintFormat:@"H:|-15-[thumb]" viewsDict:viewsDict];
      [self.contentView addConstraintFormat:@"V:[desc]-5-[thumb(100)]-(15)-|" viewsDict:viewsDict];
      
      self.imageViewWidthContraint = [NSLayoutConstraint constraintWithItem:self.thumbnailImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil attribute:0 multiplier:1 constant:100];
      [self.contentView addConstraint:self.imageViewWidthContraint];
   }
   return self;
}

@end

//====================================================================================================
#pragma mark - Without image
//====================================================================================================

@implementation CoffeesListWithoutImageTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
   if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
      NSDictionary *viewsDict = @{ @"name" : self.coffeeNameLabel,
                                   @"desc" : self.coffeeDescriptionLabel,
                                   @"thumb" : self.thumbnailImageView, };
      [self.contentView addConstraintFormat:@"V:[desc]-(15)-|" viewsDict:viewsDict];
   }
   return self;
}

@end
