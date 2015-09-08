//
//  Promotion.h
//  Unitienda
//
//  Created by Fly on 9/4/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Article;

@interface Promotion : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSNumber * effectiveness;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * percentageDiscount;
@property (nonatomic, retain) NSNumber * promotionId;
@property (nonatomic, retain) Article *article;

@end
