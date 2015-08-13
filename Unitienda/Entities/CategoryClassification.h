//
//  CategoryClassification.h
//  Unitienda
//
//  Created by Fly on 7/3/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Article, Icon;

@interface CategoryClassification : NSManagedObject

@property (nonatomic, retain) NSNumber * categoryId;
@property (nonatomic, retain) NSNumber * icon_url;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * short_name;
@property (nonatomic, retain) NSSet *article;
@property (nonatomic, retain) Icon *icon;
@end

@interface CategoryClassification (CoreDataGeneratedAccessors)

- (void)addArticleObject:(Article *)value;
- (void)removeArticleObject:(Article *)value;
- (void)addArticle:(NSSet *)values;
- (void)removeArticle:(NSSet *)values;

@end
