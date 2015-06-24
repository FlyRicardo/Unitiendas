//
//  PromotionVO.h
//  Unitienda
//
//  Created by Fly on 4/27/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ArticleMO;

@interface PromotionMO : NSObject

@property (nonatomic) NSInteger promotionId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *creationDate;
@property (strong, nonatomic) NSDate *dueDate;
@property (strong, nonatomic) NSNumber *percentageDiscount;
@property (strong, nonatomic) NSNumber *effectiveness;

@end
