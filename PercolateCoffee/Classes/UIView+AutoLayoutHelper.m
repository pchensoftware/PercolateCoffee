//====================================================================================================
// Author: Peter Chen
// Created: 5/24/15
// Copyright 2015 Peter Chen
//====================================================================================================

#import "UIView+AutoLayoutHelper.h"


@implementation UIView (AutoLayoutHelper)

- (void)addConstraintFormat:(NSString *)format viewsDict:(NSDictionary *)viewsDict {
   [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:viewsDict]];
}

@end
