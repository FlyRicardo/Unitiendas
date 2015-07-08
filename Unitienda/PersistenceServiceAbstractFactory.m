//
//  PersistanceServiceAbstractFactory.m
//  Unitienda
//
//  Created by Fly on 6/24/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "PersistenceServiceAbstractFactory.h"

#import "PersistenceServiceCoreDataFactory.h"

@implementation PersistenceServiceAbstractFactory

#pragma mark - Singleton Pattern implementation

static PersistenceServiceAbstractFactory* _instance;

+(void)initialize{
    if(self == [PersistenceServiceAbstractFactory class]){
        _instance = [[PersistenceServiceAbstractFactory alloc]init];
    }
}

-(id)init{
    self = [super init];
    if(self){
        //Initialite own parammeters
    }
    return self;
}

+(id)getInstance{
    return _instance;
}

#pragma mark - interface implementations

+(id<PSEntityArticle>) createPersistanceServiceEntityArticle:(PersistenceTypes)type{
    return nil;
}

+(id<PSEntityCategory>) createPersistanceServiceEntityCategory:(PersistenceTypes)type{
    return nil;
}

+(id<PSEntityPromotion>) createPersistanceServiceEntityPromotion:(PersistenceTypes)type{
    switch (type) {
        case CoreDataType:{
            return [PersistenceServiceCoreDataFactory createPersistenceServiceEntityPromotion];
        }
        case SqliteType:{
            return nil;
        }
    }
     return nil;
}

+(id<PSEntityStore>) createPersistanceServiceEntityStore:(PersistenceTypes)type{
     return nil;
}


@end
