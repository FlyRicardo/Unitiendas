//
//  CategoryDataSync.m
//  Unitienda
//
//  Created by Fly on 7/2/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "CategoryDataSyncImpl1.h"

@implementation CategoryDataSyncImpl1

#pragma mark - Singleton Pattern implementation
static CategoryDataSyncImpl1* _instance;

+(void)initialize{
    if(self == [CategoryDataSyncImpl1 class]){
        _instance = [[CategoryDataSyncImpl1 alloc]init];
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
-(CategoryMO*) getAllCategoriesUsingWSRequest:(BOOL) flag{
    return nil;
}

-(IconMO*) getIconByCategory:(CategoryMO*) category usingWSRequest:(BOOL) flag{
    return nil;
}

@end
