//
//  PromotionDataSync.h
//  Unitienda
//
//  Created by Fly on 7/2/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Promotion.h"
#import "Store.h"

@protocol PromotionDataSync

-(NSArray*) getPromotionsByStore:(Store*) store;             //Get the Promotion List from local DB ( if flag is false )
-(Promotion*) getPromotionDetail:(Promotion*) prmotion;      //Get the Promotion Detail from local DB ( if flag is false )

@end