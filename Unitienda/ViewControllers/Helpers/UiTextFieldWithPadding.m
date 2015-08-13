//
//  UiTextFieldWithPadding.m
//  Unitienda
//
//  Created by Fly on 4/17/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "UiTextFieldWithPadding.h"

@implementation UiTextFieldWithPadding

-(CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectInset( bounds , 10 , 0 );
}

-(CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectInset( bounds , 10 , 0 );
}

@end
