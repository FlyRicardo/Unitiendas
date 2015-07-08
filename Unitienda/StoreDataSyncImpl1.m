//
//  StoreDataSync.m
//  Unitienda
//
//  Created by Fly on 7/2/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "StoreDataSyncImpl1.h"
#import "StoreMO.h"

@implementation StoreDataSyncImpl1

#pragma mark - Singleton Pattern implementation
static StoreDataSyncImpl1* _instance;

+(void)initialize{
    if(self == [StoreDataSyncImpl1 class]){
        _instance = [[StoreDataSyncImpl1 alloc]init];
    }
}

-(id)init{
    self = [super init];
    if(self){
        //Initialite own parammeters
        //Object manager configuration
    }
    return self;
}

+(id)getInstance{
    return _instance;
}

#pragma mark - Protocol methos implementation
-(StoreMO*) getStoreProfile:(StoreMO*) store usingWSRequest:(BOOL) flag{
    return nil;
}

@end
