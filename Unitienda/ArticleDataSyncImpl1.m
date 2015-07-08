//
//  ArticleDataSync.m
//  Unitienda
//
//  Created by Fly on 7/2/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "ArticleDataSyncImpl1.h"

@implementation ArticleDataSyncImpl1

#pragma mark - Singleton Pattern implementation
static ArticleDataSyncImpl1* _instance;

+(void)initialize{
    if(self == [ArticleDataSyncImpl1 class]){
        _instance = [[ArticleDataSyncImpl1 alloc]init];
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

-(NSArray*) getArticleListByStore:(StoreMO*) storeMO usingWSRequest:(BOOL) flag{
    return nil;
}

-(NSArray*) getArticleListByCategory:(CategoryMO*) categoryMO usingWSRequest:(BOOL) flag{
    return nil;
}

-(NSArray*) getAllArticlesUsingWSRequest:(BOOL) flag{
    return nil;
}

-(ArticleMO*) getArticleByPromotion:(PromotionMO*) promotionMO usingWSRequest:(BOOL) flag{
    return nil;
}

@end
