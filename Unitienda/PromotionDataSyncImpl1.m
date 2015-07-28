//
//  PromotionDataSync.m
//  Unitienda
//
//  Created by Fly on 7/2/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "PromotionDataSyncImpl1.h"

#import "WebServiceAbstractFactory.h"

#import "Constants.h"

@interface PromotionDataSyncImpl1()

@property (weak, nonatomic) id wsPromotionConnector;
@property (weak, nonatomic) id psEntityPromotion;

@end


@implementation PromotionDataSyncImpl1

#pragma mark - Singleton Pattern implementation

static PromotionDataSyncImpl1* _instance;

+(void)initialize{
    if(self == [PromotionDataSyncImpl1 class]){
        _instance = [[PromotionDataSyncImpl1 alloc]init];
        _instance.wsPromotionConnector = [WebServiceAbstractFactory createWebServicePromotionConnection:ApacheType];
        [_instance registerNotifyProcess];
    }
}

-(id)init{
    self = [super init];
    if(self){
        //Initialite own parammeters
        //Object manager configuration
    }
    return self;
}

-(void) dealloc{
    [self unregisterNotifyProcess];
}

+(id)getInstance{
    return _instance;
}

#pragma mark - Protocol methos implementation
-(void) getPromotionsListByStore:(StoreMO*) store usingWSRequest:(BOOL) flag{
    if(flag){
        [_wsPromotionConnector getPromotionsByStoreWS:[store storeId]];
    }else{
        [_wsPromotionConnector getPromotionsByStorePersistence:[store storeId]];
    }
}

-(void) getPromotionDetail:(PromotionMO*) prmotion usingWSRequest:(BOOL) flag{
}


#pragma mark - Notifying Web Service proccess
-(void)registerNotifyProcess{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivePromotionByStoreWsNotification:)
                                                 name:[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_WS_RESPONSE_NOTIFICATION]
                                               object:nil];

}

-(void)unregisterNotifyProcess{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_WS_RESPONSE_NOTIFICATION]
                                                  object:nil];

}

-(void) receivePromotionByStoreWsNotification:(NSNotification *) notification{
    
    NSDictionary *dictionary = notification.userInfo;
    if([dictionary[[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_WS_RESPONSE]] isKindOfClass:[NSFetchRequest class]]){
        
        NSFetchRequest* fetchRequestPromotionList = (NSFetchRequest*)dictionary[[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_WS_RESPONSE]];
        
        //Broadcast notification of DataSync
        NSDictionary* userInfo = @{[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_DATASYNC_RESPONSE]: fetchRequestPromotionList};
        [[NSNotificationCenter defaultCenter] postNotificationName:[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_DATASYNC_RESPONSE_NOTIFICATION] object:nil userInfo:userInfo];
        
    }else if([dictionary[[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_WS_RESPONSE]] isKindOfClass:[MetaMO class]]){
        
        MetaMO* metaMO = (MetaMO*)dictionary[[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_WS_RESPONSE]];
        
        NSDictionary* userInfo = @{[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_DATASYNC_RESPONSE]: metaMO};
        [[NSNotificationCenter defaultCenter] postNotificationName:[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_DATASYNC_RESPONSE_NOTIFICATION] object:nil userInfo:userInfo];
    }
}
@end
