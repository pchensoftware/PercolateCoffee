//====================================================================================================
// Author: Peter Chen
// Created: 5/24/15
// Copyright 2015 Peter Chen
//====================================================================================================

#import "CoffeeView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+PercolateCoffee.h"
#import "UIView+AutoLayoutHelper.h"

#define kMargin 15

@interface CoffeeView()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *lastUpdatedLabel;
@property (nonatomic, strong) NSLayoutConstraint *imageViewHeightConstraint;

@end

@implementation CoffeeView

+ (NSString *)lastUpdatedStringFromDate:(NSDate *)date {
   return [date description];
}

- (id)initWithFrame:(CGRect)frame {
   if ((self = [super initWithFrame:frame])) {
      self.backgroundColor = [UIColor whiteColor];
      
      self.scrollView = [[UIScrollView alloc] init];
      self.scrollView.alwaysBounceVertical = YES;
      [self addSubview:self.scrollView];
      
      self.contentView = [[UIView alloc] init];
      [self.scrollView addSubview:self.contentView];
      
      self.nameLabel = [[UILabel alloc] init];
      self.nameLabel.font = [UIFont boldSystemFontOfSize:27];
      self.nameLabel.textColor = [UIColor percolateDarkGray];
      [self.contentView addSubview:self.nameLabel];
      
      self.descriptionLabel = [[UILabel alloc] init];
      self.descriptionLabel.font = [UIFont systemFontOfSize:17];
      self.descriptionLabel.numberOfLines = 0;
      self.descriptionLabel.textColor = [UIColor percolateGray];
      [self.contentView addSubview:self.descriptionLabel];
      
      self.imageView = [[UIImageView alloc] init];
      self.imageView.contentMode = UIViewContentModeScaleAspectFill;
      self.imageView.clipsToBounds = YES;
      [self.contentView addSubview:self.imageView];

      self.lastUpdatedLabel = [[UILabel alloc] init];
      self.lastUpdatedLabel.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:17];
      self.lastUpdatedLabel.textColor = [UIColor percolateGray];
      [self.contentView addSubview:self.lastUpdatedLabel];
      
      self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
      self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
      [self addConstraintFormat:@"H:|[scroll]|" viewsDict:@{ @"scroll" : self.scrollView }];
      [self addConstraintFormat:@"V:|[scroll]|" viewsDict:@{ @"scroll" : self.scrollView }];
      [self.scrollView addConstraintFormat:@"H:|[content]|" viewsDict:@{ @"content" : self.contentView }];
      [self.scrollView addConstraintFormat:@"V:|[content]|" viewsDict:@{ @"content" : self.contentView }];
      
      self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
      self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
      self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
      self.lastUpdatedLabel.translatesAutoresizingMaskIntoConstraints = NO;
      NSDictionary *views = @{ @"name" : self.nameLabel,
                               @"desc" : self.descriptionLabel,
                               @"image" : self.imageView,
                               @"updated" : self.lastUpdatedLabel,
                               };
      [self.contentView addConstraintFormat:@"H:|-15-[name]-15-|" viewsDict:views];
      [self.contentView addConstraintFormat:@"H:|-15-[desc]-15-|" viewsDict:views];
      [self.contentView addConstraintFormat:@"H:|-15-[image]-15-|" viewsDict:views];
      [self.contentView addConstraintFormat:@"H:|-15-[updated]-15-|" viewsDict:views];
      [self.contentView addConstraintFormat:@"V:|-15-[name]-[desc]-[image]-[updated]-15-|" viewsDict:views];
      
      self.imageViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil attribute:0 multiplier:1 constant:100];
      [self.contentView addConstraint:self.imageViewHeightConstraint];
      
      // Auto-calculate scroll view's contentSize
      NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                        attribute:NSLayoutAttributeLeading
                                                                        relatedBy:0
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1
                                                                         constant:0];
      [self addConstraint:leftConstraint];
      
      NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                         attribute:NSLayoutAttributeTrailing
                                                                         relatedBy:0
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1
                                                                          constant:0];
      [self addConstraint:rightConstraint];
   }
   return self;
}

- (UIImage *)image {
   return self.imageView.image;
}

- (void)setCoffee:(Coffee *)coffee {
   _coffee = coffee;
   [self didUpdateCoffee];
   
   [self.imageView sd_setImageWithURL:[NSURL URLWithString:coffee.image_url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
      if (image.size.width > 0)
         self.imageViewHeightConstraint.constant = self.bounds.size.width - 2 * kMargin * image.size.height / image.size.width;
      else
         self.imageViewHeightConstraint.constant = 0;
      
      [self setNeedsUpdateConstraints];
   }];
}

- (void)didUpdateCoffee {
   self.nameLabel.text = self.coffee.name;
   self.descriptionLabel.text = self.coffee.desc;
   self.lastUpdatedLabel.text = [CoffeeView lastUpdatedStringFromDate:self.coffee.last_updated];
   [self setNeedsUpdateConstraints];
}

@end
