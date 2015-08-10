//
//  DataSyncServiceAbstractFactory.h
//  Unitienda
//
//  Created by Fly on 7/3/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PromotionDataSync.h"
#import "ArticleDataSync.h"
#import "StoreDataSync.h"
#import "CategoryDataSync.h"
#import "DataChecker.h"

typedef enum DataSyncTypes {
    Impl1,
    Impl2
} DataSyncTypes;

@interface DataSyncServiceAbstractFactory : NSObject

+(id<DataChecker>) createDataChecker:(DataSyncTypes)type;
+(id<PromotionDataSync>) createPromotionDataSycn:(DataSyncTypes)type;
+(id<ArticleDataSync>) createArticleDataSycn:(DataSyncTypes)type;
+(id<StoreDataSync>) createStoreDataSycn:(DataSyncTypes)type;
+(id<CategoryDataSync>) createCategoryDataSycn:(DataSyncTypes)type;

@end
