//
//  DataSyncServiceImpl2.m
//  Unitienda
//
//  Created by Fly on 7/3/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "DataSyncServiceFactoryImpl2.h"
#import "FileHandler.h"

@implementation DataSyncServiceFactoryImpl2

#pragma mark - Singleton Pattern implementation

static DataSyncServiceFactoryImpl2* _instance;

+(void)initialize{
    if(self == [DataSyncServiceFactoryImpl2 class]){
        _instance = [[DataSyncServiceFactoryImpl2 alloc]init];
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
    return nil;
}

+(id<PromotionDataSync>) createPromotionDataSycn{
    return nil;
}

+(id<ArticleDataSync>) createArticleDataSycn{
    return nil;
}

+(id<StoreDataSync>) createStoreDataSycn{
    return nil;
}

+(id<CategoryDataSync>) createCategoryDataSycn{
    return nil;
}

@end
