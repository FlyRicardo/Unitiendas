//
//  UILabelWithPadding.m
//  Unitienda
//
//  Created by Fly on 4/17/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "UILabelWithPadding.h"

@implementation UILabelWithPadding

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 10, 0, 10};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}


@end
