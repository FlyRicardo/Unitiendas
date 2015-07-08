//
//  PersistanceServiceAbstractFactoryProtocol.h
//  Unitienda
//
//  Created by Fly on 6/24/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#ifndef Unitienda_PersistanceServiceAbstractFactoryProtocol_h
#define Unitienda_PersistanceServiceAbstractFactoryProtocol_h

#import "PSEntityArticle.h"
#import "PSEntityPromotion.h"
#import "PSEntityCategory.h"
#import "PSEntityStore.h"

@protocol PersistenceServiceAbstractFactoryProtocol

+(id<PSEntityArticle>) createPersistenceServiceEntityArticle;
+(id<PSEntityPromotion>) createPersistenceServiceEntityPromotion;
+(id<PSEntityCategory>) createPersistenceServiceEntityCategory;
+(id<PSEntityStore>) createPersistenceServiceEntityStore;

@end

#endif
