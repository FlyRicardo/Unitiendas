//
//  PersistanceServiceCoreDataFactory.m
//  Unitienda
//
//  Created by Fly on 6/24/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "PersistenceServiceCoreDataFactory.h"

#import "PSEntityPromotionCoreData.h"

@implementation PersistenceServiceCoreDataFactory

#pragma mark - Singleton Pattern implementation

static PersistenceServiceCoreDataFactory* _instance;

+(void)initialize{
    if(self == [PersistenceServiceCoreDataFactory class]){
        _instance = [[PersistenceServiceCoreDataFactory alloc]init];
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

#pragma mark - Protocol methos implementation
+(id<PSEntityArticle>) createPersistenceServiceEntityArticle{
    return nil;
}

+(id<PSEntityPromotion>) createPersistenceServiceEntityPromotion{
    return [PSEntityPromotionCoreData getInstance];
}

+(id<PSEntityCategory>) createPersistenceServiceEntityCategory{
    return nil;
}

+(id<PSEntityStore>) createPersistenceServiceEntityStore{
    return nil;
}

@end
