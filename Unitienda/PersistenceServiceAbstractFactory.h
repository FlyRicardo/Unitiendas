//
//  PersistanceServiceAbstractFactory.h
//  Unitienda
//
//  Created by Fly on 6/24/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PSEntityArticle.h"
#import "PSEntityCategory.h"
#import "PSEntityPromotion.h"
#import "PSEntityStore.h"

typedef enum PersistenceTypes {
    CoreDataType,
    SqliteType
} PersistenceTypes;

@interface PersistenceServiceAbstractFactory : NSObject

+(id<PSEntityArticle>) createPersistanceServiceEntityArticle:(PersistenceTypes)type;
+(id<PSEntityCategory>) createPersistanceServiceEntityCategory:(PersistenceTypes)type;
+(id<PSEntityPromotion>) createPersistanceServiceEntityPromotion:(PersistenceTypes)type;
+(id<PSEntityStore>) createPersistanceServiceEntityStore:(PersistenceTypes)type;

@end
