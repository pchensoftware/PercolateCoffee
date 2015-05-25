//====================================================================================================
// Author: Peter Chen
// Created: 5/24/15
// Copyright 2015 Peter Chen
//====================================================================================================

#import "NavbarLogoView.h"

@interface NavbarLogoView()



@end

@implementation NavbarLogoView

- (id)initWithFrame:(CGRect)frame {
   if ((self = [super initWithFrame:frame])) {
      self.contentMode = UIViewContentModeScaleAspectFit;
      self.image = [UIImage imageNamed:@"drip-white"];
   }
   return self;
}

@end
