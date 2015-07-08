//
//  DataSyncServiceAbstractFactory.m
//  Unitienda
//
//  Created by Fly on 7/3/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "DataSyncServiceAbstractFactory.h"

#import "DataSyncServiceFactoryImpl1.h"
#import "DataSyncServiceFactoryImpl2.h"

@implementation DataSyncServiceAbstractFactory

#pragma mark - Singleton Pattern implementation

static DataSyncServiceAbstractFactory* _instance;

+(void)initialize{
    if(self == [DataSyncServiceAbstractFactory class]){
        _instance = [[DataSyncServiceAbstractFactory alloc]init];
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

+(id<PromotionDataSync>) createPromotionDataSycn:(DataSyncTypes)type{
    
    switch (type) {
            
        case Impl1:
            return [DataSyncServiceFactoryImpl1 createPromotionDataSycn];
            break;
        case Impl2:
            return [DataSyncServiceFactoryImpl2 createPromotionDataSycn];
            break;
            
        default:
            return [DataSyncServiceFactoryImpl1 createPromotionDataSycn];
            break;
    }
}

+(id<ArticleDataSync>) createArticleDataSycn:(DataSyncTypes)type{
    
    switch (type) {
            
        case Impl1:
              return [DataSyncServiceFactoryImpl1 createArticleDataSycn];
            break;
        case Impl2:
            return [DataSyncServiceFactoryImpl2 createArticleDataSycn];
            break;
            
        default:
            return [DataSyncServiceFactoryImpl1 createArticleDataSycn];
            break;
    }

    
}

+(id<StoreDataSync>) createStoreDataSycn:(DataSyncTypes)type{
    
    switch (type) {
            
        case Impl1:
            return [DataSyncServiceFactoryImpl1 createStoreDataSycn];
            break;
        case Impl2:
            return [DataSyncServiceFactoryImpl2 createStoreDataSycn];
            break;
            
        default:
            return [DataSyncServiceFactoryImpl1 createStoreDataSycn];
            break;
    }

}

+(id<CategoryDataSync>) createCategoryDataSycn:(DataSyncTypes)type{
    
    switch (type) {
            
        case Impl1:
                return [DataSyncServiceFactoryImpl1 createCategoryDataSycn];
            break;
        case Impl2:
                return [DataSyncServiceFactoryImpl2 createCategoryDataSycn];
            break;
            
        default:
            return [DataSyncServiceFactoryImpl1 createCategoryDataSycn];
            break;
    }

}

@end
