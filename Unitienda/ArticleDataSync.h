//
//  ArticleDataSync.h
//  Unitienda
//
//  Created by Fly on 7/2/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArticleMO.h"
#import "StoreMO.h"
#import "CategoryMO.h"
#import "PromotionMO.h"

@protocol ArticleDataSync

-(NSArray*) getArticleListByStore:(StoreMO*) storeMO usingWSRequest:(BOOL) flag;                   //Depends on the flag, the method use WS to get Article List By Store and store it on local DB ( if flag is true ), or only get the Article List By Store from local DB ( if flag is false )

-(NSArray*) getArticleListByCategory:(CategoryMO*) categoryMO usingWSRequest:(BOOL) flag;           //Depends on the flag, the method use WS to get Article List By Category and store it on local DB ( if flag is true ), or only get the Article List By CAtegory from local DB ( if flag is false )

-(NSArray*) getAllArticlesUsingWSRequest:(BOOL) flag;                                             //Depends on the flag, the method use WS to get All Articles and store it on local DB ( if flag is true ), or only get the All Articles from local DB ( if flag is false )

-(ArticleMO*) getArticleByPromotion:(PromotionMO*) promotionMO usingWSRequest:(BOOL) flag;         //Depends on the flag, the method use WS to get an Article By Promotion and store it on local DB ( if flag is true ), or only get an Article By Promotion from local DB ( if flag is false )

@end