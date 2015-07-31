//
//  WSPromotionConnector.h
//  Unitienda
//
//  Created by Fly on 5/15/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "WSPromotionConnector.h"

@protocol WSPromotionConnector

-(void) getPromotionsByStoreWS:(NSInteger)storeId;     //Notify to its selector the status of promotionsByStoreWS
                                                                                //Params: Success NSArray {@Meta class, @Promotion class}
                                                                                //        Failure @Meta class

@end