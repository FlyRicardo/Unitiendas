//
//  StoreMO+RequestMO.m
//  Unitienda
//
//  Created by Fly on 5/15/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "StoreMO+RequestMO.h"
#import <objc/runtime.h>

@implementation StoreMO (RequestMO)

-(NSString*) accessToken{
    return objc_getAssociatedObject(self, @selector(accessToken));
}

-(void) setAccessToken:(NSString *)accessTokenParam{
    objc_setAssociatedObject(self, @selector(accessToken), accessTokenParam, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
