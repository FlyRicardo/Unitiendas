//
//  DataSyncServiceImpl1.m
//  Unitienda
//
//  Created by Fly on 7/3/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "DataSyncServiceFactoryImpl1.h"

#import "PromotionDataSyncImpl1.h"
#import "ArticleDataSyncImpl1.h"
#import "StoreDataSyncImpl1.h"
#import "CategoryDataSyncImpl1.h"
#import "DataCheckerImpl1.h"

@implementation DataSyncServiceFactoryImpl1

#pragma mark - Singleton Pattern implementation

static DataSyncServiceFactoryImpl1* _instance;

+(void)initialize{
    if(self == [DataSyncServiceFactoryImpl1 class]){
        _instance = [[DataSyncServiceFactoryImpl1 alloc]init];
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

+(id<DataChecker>) createDataChecker{
    return [DataCheckerImpl1 getInstance];
}

+(id<PromotionDataSync>) createPromotionDataSycn{
    return [PromotionDataSyncImpl1 getInstance];
}

+(id<ArticleDataSync>) createArticleDataSycn{
    return [ArticleDataSyncImpl1 getInstance];
}

+(id<StoreDataSync>) createStoreDataSycn{
    return [StoreDataSyncImpl1 getInstance];
}

+(id<CategoryDataSync>) createCategoryDataSycn{
    return [CategoryDataSyncImpl1 getInstance];
}

@end
