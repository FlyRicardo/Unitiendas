//
//  Store.h
//  Unitienda
//
//  Created by Fly on 7/3/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Article;

@interface Store : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSNumber * storeId;
@property (nonatomic, retain) NSSet *article;
@end

@interface Store (CoreDataGeneratedAccessors)

- (void)addArticleObject:(Article *)value;
- (void)removeArticleObject:(Article *)value;
- (void)addArticle:(NSSet *)values;
- (void)removeArticle:(NSSet *)values;

@end
