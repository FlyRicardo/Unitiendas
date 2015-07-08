//
//  PromotionDataSync.h
//  Unitienda
//
//  Created by Fly on 7/2/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PromotionMO.h"
#import "StoreMO.h"

@protocol PromotionDataSync

-(void) getPromotionsListByStore:(StoreMO*) store usingWSRequest:(BOOL) flag;              //Depends on the flag, the method use WS to get Promotion List and store on local DB ( if flag is true ), or only get the Promotion List from local DB ( if flag is false )

-(void) getPromotionDetail:(PromotionMO*) prmotion usingWSRequest:(BOOL) flag;         //Depends on the flag, the method use WS to get Promotion Detail and store on local DB ( if flag is true ), or only get the Promotion Detail from local DB ( if flag is false )

@end