//
//  PromotionData.h
//  Unitienda
//
//  Created by Fly on 6/19/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.

#import <Foundation/Foundation.h>
#import "PromotionMO.h"
#import "StoreMO.h"

@protocol PSEntityPromotion

-(NSArray*) getPromotionsListByStore:(StoreMO*) store;                //Gives an array of (Promotion class) related with specific (StoreMO class), saved on the persistence application tool

-(PromotionMO*) getPromotionDetail:(PromotionMO*) prmotion;         //Gives an (Promotion class) object related with specific (Promotion class) attributes, saved on the persistence application tool

@end