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

@protocol DataSyncServiceAbstractFactoryProtocol

+(id<PromotionDataSync>) createPromotionDataSycn;
+(id<ArticleDataSync>) createArticleDataSycn;
+(id<StoreDataSync>) createStoreDataSycn;
+(id<CategoryDataSync>) createCategoryDataSycn;

@end