//
//  EntityPromotionPersistance.m
//  Unitienda
//
//  Created by Fly on 6/24/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "PSEntityPromotionCoreData.h"

#import "WebServiceAbstractFactory.h"
#import "WSProfileConnector.h"

#import "Constants.h"

@interface PSEntityPromotionCoreData()

@property (nonatomic, strong) PSEntityPromotionCoreData *psEntityPromotionCoreData;

@property(strong, nonatomic) id wsPromotionConnector;

@end

@implementation PSEntityPromotionCoreData

#pragma mark - Singleton Pattern implementation

static PSEntityPromotionCoreData* _instance;

+(void)initialize{
    if(self == [PSEntityPromotionCoreData class]){
        _instance = [[PSEntityPromotionCoreData alloc]init];
    }
}

-(id)init{
    self = [super init];
    if(self){
        //Initialite own parammeters
        
        //Object manager configuration
        _psEntityPromotionCoreData = [PSEntityPromotionCoreData getInstance];
        _wsPromotionConnector = [WebServiceAbstractFactory createWebServicePromotionConnection:ApacheType];
        [self registerNotifyProcess];
        
    }
    return self;
}

+(id)getInstance{
    return _instance;
}

//-(void)dealloc{
//    NSLog(@"The dealloc method is called on PSEntityPromotionCoreData");
//}


#pragma mark - Protocol methos implementation
-(NSArray*) getPromotionsListByStore:(StoreMO*) store{               //Gives an array of (Promotion class) related with specific (StoreMO class),
                                                                     //saved on the persistence application tool
    return nil;

}

-(PromotionMO*) getPromotionDetail:(PromotionMO*) prmotion;{         //Gives an (Promotion class) object related with specific (Promotion class) attributes,
                                                                     //saved on the persistence application tool
    return  nil;
}

#pragma mark - Notifying Web Service proccess

-(void)registerNotifyProcess{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivePromotionsByStoreNotification:)
                                                 name:[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_WS_RESPONSE_NOTIFICATION]
                                               object:nil];
    
}

-(void) unregisterNotifyProcess{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_WS_RESPONSE_NOTIFICATION]
                                                  object:nil];
}

-(void)receivePromotionsByStoreNotification:(NSNotification *) notification{
    NSDictionary *dictionary = notification.userInfo;
    if([dictionary[[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_WS_RESPONSE]] isKindOfClass:[NSArray class]]){
        NSArray* promotionList = (NSArray*)dictionary[[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_WS_RESPONSE]];
        NSLog(@"Promotions count: %lu", (unsigned long)[promotionList count]);
    }else if([dictionary[[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_WS_RESPONSE]] isKindOfClass:[MetaMO class]]){
        MetaMO* metaMO = (MetaMO*)dictionary[[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_WS_RESPONSE]];
    }
}

//-(void)receiveRefreshNotification:(NSNotification *) notification{
//    NSDictionary *dictionary = notification.userInfo;
//    _refreshTokenResponseMO = (RefreshTokenMetaMO*) dictionary[[Constants GET_LABEL_NAME_REFRESH_TOKEN_RESPONSE]];
//    
//    if([[_refreshTokenResponseMO errorDetail ] containsString: [Constants GET_ERROR_DESCRIPTION_EXPIRED_REFRESH_TOKEN_VALUE] ]){     //Refresh token has expired. The authentication proccess has to star again.
//        
//        //Return application to loggin (remove as many view as viewController had sotored)
//        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
//        [viewControllers removeLastObject];
//        [[self navigationController] setViewControllers:viewControllers animated:YES];
//        
//        
//    }else if([_refreshTokenResponseMO errorDetail] == 0){         //Not error reported
//        
//        //Save the access and refresh token, and username
//        [[NSUserDefaults standardUserDefaults]setObject:[_refreshTokenResponseMO accessToken] forKey:@"access_token"];
//        
//        [self requestGetPromotionsByStore];
//    }
//}

@end