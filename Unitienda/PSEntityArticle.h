//
//  ArticleData.h
//  Unitienda
//
//  Created by Fly on 6/19/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArticleMO.h"
#import "StoreMO.h"
#import "CategoryMO.h"
#import "PromotionMO.h"

@protocol PSEntityArticle

-(NSArray*) getArticleListByStore:(StoreMO*) storeMO;                   //Gives an array of (ArticleMO class) related with specific (StoreMO class), saved on the persistence application tool

-(NSArray*) getArticleListByCategory:(CategoryMO*) categoryMO;          //Gives an array of (ArticleMO class) related with specific (Category class), saved on the persistence application tool

-(NSArray*) getAllArticles;                                             //Gives an array of all (ArticleMO class) saved on the persistence application tool, saved on the persistence application tool

-(ArticleMO*) getArticleByPromotion:(PromotionMO*) promotionMO;           //Gives an (ArticleMO class) object related with specific (PromotionMO class), saved on the persistence application tool

@end
