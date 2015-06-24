//
//  WSPromotionConnectorApache.m
//  Unitienda
//
//  Created by Fly on 5/15/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "WSPromotionConnectorApache.h"
#import "WSConnectionApache.h"

#import "StoreMO+RequestMO.h"
#import "MetaMO.h"
#import "ArticleMO.h"
#import "PhotoMO.h"
#import "PromotionMO.h"

#import "Constants.h"

@interface WSPromotionConnectorApache()

@property (nonatomic, strong) WSConnectionApache *wsConnectionApache;

@end

@implementation WSPromotionConnectorApache

#pragma mark - Singleton Pattern implementation

static WSPromotionConnectorApache* _instance;

+(void)initialize{
    if(self == [WSPromotionConnectorApache class]){
        _instance = [[WSPromotionConnectorApache alloc]init];
    }
}

-(id)init{
    self = [super init];
    if(self){
        
        //Initialite own parammeters
        
        //Object manager configuration
        _wsConnectionApache = [WSConnectionApache getInstance];
        
    }
    return self;
}

+(id)getInstance{
    return _instance;
}

#pragma mark - Protocol methos implementation

-(void) getPromotionsByStore:(NSInteger)storeId
{
    /**
     REQUEST DESCRIPTIOR CONFIGURATION
     **/
    
    //Construct a request mapping for our class
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
                                                         @"accessToken":@"access_token",
                                                         @"storeId":@"store_id"
                                                         }];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[StoreMO class]
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodPOST];
    
    StoreMO* postBody = [[StoreMO alloc]init];
    
    [postBody setAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:[Constants GET_LABEL_NAME_ACCESS_TOKEN]]];
//    [postBody setStoreId:storeId];
    [postBody setStoreId:1];
    
    /**
     RESPONSE DESCRIPTIOR CONFIGURATION
     **/
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[ArticleMO class]];
    [responseMapping addAttributeMappingsFromDictionary:@{
                                                         @"articleId":@"articleId",
                                                         @"name":@"name",
                                                         @"price": @"price",
                                                         @"description": @"descriptionArticle"
                                                         }];
    
    // define icon objects mapping
    RKObjectMapping *storeMapping = [RKObjectMapping mappingForClass:[StoreMO class]];
    [storeMapping addAttributeMappingsFromArray:@[@"storeId", @"name", @"number" , @"latitude", @"longitude", @"email"]];
    
    RKObjectMapping *photoMapping =[RKObjectMapping mappingForClass: [PhotoMO class]];
    [photoMapping addAttributeMappingsFromArray:@[@"photoId", @"name", @"url", @"type"]];
    
    RKObjectMapping *promotionMapping = [RKObjectMapping mappingForClass: [PromotionMO class]];
    [promotionMapping addAttributeMappingsFromArray:@[@"promotionId", @"name", @"creationDate", @"dueDate", @"percentageDiscount", @"effectiveness"]];
    
    // nesting Objects mapping
    [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"storeVO" toKeyPath:@"storeMO" withMapping:storeMapping]];
    
    [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"photoVO" toKeyPath:@"photoMO" withMapping:photoMapping]];
    
    [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"promotionVO" toKeyPath:@"promotionMO" withMapping:promotionMapping]];
    
    //Seting up response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:@"/CC/WS/WS_GetPromotionDetailsByStore.php"
                                                                                           keyPath:@"response.Articles"
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    //Adding request and response descriptor to ObjectManager
    [[_wsConnectionApache objectManager] addRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager] addResponseDescriptor:responseDescriptor];
    
    
    
    //Nesting the blocks to handle the success or failire routines
    NSLog(@"store_id: %li, access_token: %@",[postBody storeId],[postBody accessToken]);
    [[_wsConnectionApache objectManager]postObject:postBody
                                              path:@"/CC/WS/WS_GetPromotionDetailsByStore.php"
                                        parameters:nil
                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
                                               
                                               NSArray *resulList = result.array;
                                               NSDictionary* userInfo = @{[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_RESPONSE]: resulList};
                                               [[NSNotificationCenter defaultCenter] postNotificationName:[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_RESPONSE_NOTIFICATION] object:nil userInfo:userInfo];
                                               
                                           }failure:^(RKObjectRequestOperation *operation, NSError *error){
                                               
                                               MetaMO* responseMO = [[MetaMO alloc] init];
                                               [responseMO setCode:[error code]];
                                               [responseMO setErrorDetail:[[error userInfo] objectForKey:@"NSLocalizedRecoverySuggestion"]];
                                               NSDictionary* userInfo = @{[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_RESPONSE]: responseMO};
                                               [[NSNotificationCenter defaultCenter] postNotificationName:[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_RESPONSE_NOTIFICATION] object:nil userInfo:userInfo];
                                               
                                           }];
    
    //Flushing the request and response descriptors
    [[_wsConnectionApache objectManager] removeRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager] removeResponseDescriptor:responseDescriptor];
}

@end
