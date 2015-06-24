//
//  RefreshTokenHelper.m
//  Unitienda
//
//  Created by Fly on 4/14/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "RefreshTokenHelper.h"


@interface RefreshTokenHelper()

@end

@implementation RefreshTokenHelper

static RefreshTokenHelper * _instance;

#pragma mark - Singleton Pattern implementation

+(void) initialize{
    if(self == [RefreshTokenHelper class]){
        _instance = [[RefreshTokenHelper alloc]init];//This init method is the custom of this class
    }
}

-(id)init{
    self = [super init];
    if(self){

    }
    return self;
}

+ (id) getInstance{
    return _instance;
}

@end
