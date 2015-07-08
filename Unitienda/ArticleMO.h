//
//  ArticleVO.h
//  Unitienda
//
//  Created by Fly on 4/27/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StoreMO;
@class PhotoMO;
@class PromotionMO;

@interface ArticleMO : NSObject

@property (nonatomic) NSInteger articleId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSString *article_description;

@property (strong, nonatomic) StoreMO *storeMO;
@property (strong, nonatomic) PhotoMO *photoMO;
@property (strong, nonatomic) PromotionMO *promotionMO;

@end