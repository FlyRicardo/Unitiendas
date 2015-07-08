//
//  Article.h
//  Unitienda
//
//  Created by Fly on 7/3/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CategoryClassification, Photo, Promotion, Store;

@interface Article : NSManagedObject

@property (nonatomic, retain) NSNumber * articleDescription;
@property (nonatomic, retain) NSNumber * articleId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) CategoryClassification *category;
@property (nonatomic, retain) NSSet *photo;
@property (nonatomic, retain) NSSet *promotion;
@property (nonatomic, retain) Store *store;
@end

@interface Article (CoreDataGeneratedAccessors)

- (void)addPhotoObject:(Photo *)value;
- (void)removePhotoObject:(Photo *)value;
- (void)addPhoto:(NSSet *)values;
- (void)removePhoto:(NSSet *)values;

- (void)addPromotionObject:(Promotion *)value;
- (void)removePromotionObject:(Promotion *)value;
- (void)addPromotion:(NSSet *)values;
- (void)removePromotion:(NSSet *)values;

@end
