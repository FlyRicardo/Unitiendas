//
//  ArticleMO+ResponseMO.m
//  Unitienda
//
//  Created by Fly on 5/15/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "ArticleMO+ResponseMO.h"
#import <objc/runtime.h>

@implementation ArticleMO (ResponseMO)

-(NSString*) responseMO{
    return objc_getAssociatedObject(self, @selector(responseMO));
}

-(void) setResponseMO:(NSString *)responseParam{
    objc_setAssociatedObject(self, @selector(responseMO), responseParam, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
