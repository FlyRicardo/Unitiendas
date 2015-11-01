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

#import "Article.h"
#import "Promotion.h"
#import "Store.h"

#import "Constants.h"

#import "AppDelegate.h"

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

// This Method only was a test to trying synchronizing
// the success response block with the returned response of
// the method 'getPromotionsByStore:store'

/** Call to <-(void) getPromotionsByStore:(NSInteger)storeId block:(void (^)(id))block> signature
-(void) getPromotionsByStore:(NSInteger)storeId{
     **
    [self getPromotionsByStore:storeId
                         block:^(id obj) {
                             NSArray *promotionList = obj;
                             NSDictionary* userInfo = @{[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_WS_RESPONSE]: promotionList};
                             [[NSNotificationCenter defaultCenter] postNotificationName:[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_WS_RESPONSE_NOTIFICATION] object:nil userInfo:userInfo];
                         }
     ];
}
 **
 **/

/**
-(void) getPromotionsByStore:(NSInteger)storeId block:(void (^)(id))block
 **/

// Implementation method of:  promotion list by store

-(void) getPromotionsByStoreWS:(NSInteger)storeId
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
    [postBody setStoreId:storeId];
    
    /**
     RESPONSE DESCRIPTIOR CONFIGURATION
     **/
    //ENTITY APPROACH
    RKEntityMapping *responseMapping = [RKEntityMapping mappingForEntityForName:@"Article" inManagedObjectStore:[[_wsConnectionApache objectManager] managedObjectStore]];
    responseMapping.identificationAttributes = @[@"articleId"];
    
    //When parameters of incomming response doesn't match with parameters of destination entity,
    //HAS to be used <addAttributeMappingsFromDictionary> method of RKEntityMapping.
    //When parameters of incomming response match with patameters of destination entity,
    //SHOULD to be used  <addAttributeMappingsFromArray>
    [responseMapping addAttributeMappingsFromDictionary:@{
                                                     @"articleId": @"articleId",
                                                     @"name": @"name",
                                                     @"price": @"price",
                                                     @"articleDescription": @"articleDescription"
                                                     }];
    
    //define photo entity mapping
    RKEntityMapping *photoMapping = [RKEntityMapping mappingForEntityForName:@"Photo" inManagedObjectStore:[[_wsConnectionApache objectManager] managedObjectStore]];
    [photoMapping setIdentificationAttributes : @[@"photoId"]];
    
    [photoMapping addAttributeMappingsFromArray:@[@"photoId", @"name", @"url", @"type"]];
    
    //define store entity mapping
    RKEntityMapping *storeMapping = [RKEntityMapping mappingForEntityForName:@"Store" inManagedObjectStore:[[_wsConnectionApache objectManager] managedObjectStore]];
    [storeMapping setIdentificationAttributes: @[@"storeId"]];
    
    [storeMapping addAttributeMappingsFromArray:@[@"storeId", @"name", @"number", @"email"]];
    
    //define promotion entity mapping
    RKEntityMapping *promotionMapping = [RKEntityMapping mappingForEntityForName:@"Promotion" inManagedObjectStore:[[_wsConnectionApache objectManager]managedObjectStore]];
    [promotionMapping setIdentificationAttributes:@[@"promotionId"]];
    
    [promotionMapping addAttributeMappingsFromArray:@[@"promotionId", @"name", @"creationDate", @"dueDate", @"percentageDiscount",@"effectiveness"]];
    
    //nesting Objects mapping
    [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"storeVO" toKeyPath:@"store" withMapping:storeMapping]];
    [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"photoVO" toKeyPath:@"photo" withMapping:photoMapping]];
    [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"promotionVO" toKeyPath:@"promotion" withMapping:promotionMapping]];
    //Setup response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                            method:RKRequestMethodPOST
                                                                                        pathPattern:@"/CC/WS/WS_GetPromotionsByStore.php"
                                                                                            keyPath:@"response.Articles"
                                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    //Adding request and response descriptor to ObjectManager
    [[_wsConnectionApache objectManager] addRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager] addResponseDescriptor:responseDescriptor];
    
    //Nesting the blocks to handle the success or failire routines
    NSLog(@"store_id: %li, access_token: %@",(long)[postBody storeId],[postBody accessToken]);
    [[_wsConnectionApache objectManager]postObject:postBody
                                              path:@"/CC/WS/WS_GetPromotionsByStore.php"
                                          parameters:nil
                                             success: ^(RKObjectRequestOperation *operation, RKMappingResult *result){
                                                 
                                                 //It's not necesary create an operation that writtes on DB, because RESTKit is already configurate with CoreData
                                                 //Just for Log intents, the success notify to its listernes the success response
                                                 
                                                 NSArray *promotionList = [result array];
                                                 if([promotionList count]>0){
                                                     NSDictionary* userInfo = @{[Constants GET_LABEL_NAME_PROMOTIONS_BY_STORE_WS_RESPONSE]: promotionList};
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:[Constants GET_LABEL_NAME_PROMOTIONS_BY_STORE_WS_RESPONSE_NOTIFICATION] object:nil userInfo:userInfo];
                                                 }else{
                                                     NSLog(@"Error, no object attached on response");
                                                 }
                                                 /**  Response using block as parameter of signature method <-(void) getPromotionsByStore:(NSInteger)storeId block:(void (^)(id))block>
                                                  
                                                  block(resulList);
                                                  
                                                  **/
                                            }
                                            failure:^(RKObjectRequestOperation *operation, NSError *error){
                                                
                                                AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                                                if(![app.managedObjectContext save:&error]) {
                                                    NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
                                                    NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
                                                    if(detailedErrors != nil && [detailedErrors count] > 0) {
                                                        for(NSError* detailedError in detailedErrors) {
                                                            NSLog(@"  DetailedError: %@", [detailedError userInfo]);
                                                        }
                                                    }
                                                    else {
                                                        NSLog(@"  %@", [error userInfo]);
                                                    }
                                                }
                                                
                                                MetaMO* responseMO = [[MetaMO alloc] init];
                                                [responseMO setCode:[error code]];
                                                [responseMO setErrorDetail:[[error userInfo] objectForKey:@"NSLocalizedRecoverySuggestion"]];
                                                
                                                NSDictionary* userInfo = @{[Constants GET_LABEL_NAME_PROMOTIONS_BY_STORE_WS_RESPONSE]: responseMO};
                                                [[NSNotificationCenter defaultCenter] postNotificationName:[Constants GET_LABEL_NAME_PROMOTIONS_BY_STORE_WS_RESPONSE_NOTIFICATION] object:nil userInfo:userInfo];

                                                
                                                /**  Response using block as parameter of signature method <-(void) getPromotionsByStore:(NSInteger)storeId block:(void (^)(id))block>
                                                 
                                                 block(responseMO);
                                                 
                                                 **/
                                            }
    ];
    
    //Flushing the request and response descriptors
    [[_wsConnectionApache objectManager] removeRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager] removeResponseDescriptor:responseDescriptor];
    
    // Enable Activity Indicator Spinner
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}


// Implementation method of: Create promotion

-(void) createPromotion:(Promotion *)promotion{
    
    /**
     REQUEST DESCRIPTIOR CONFIGURATION
     **/
    
    //Configuration of Object Mapping for Wrapper <Promotion class>
    
    RKObjectMapping *promotionMapping = [RKObjectMapping requestMapping];
    [promotionMapping addAttributeMappingsFromDictionary:@{
                                                         @"percentageDiscount":@"percentage_discount",
                                                         @"creationDate":@"start_date",
                                                         @"dueDate":@"end_date"
                                                         }];
    
    
    //Configuration of Object Mapping for <Article class>
    
    RKObjectMapping *articleMapping = [RKObjectMapping requestMapping];
    [articleMapping addAttributeMappingsFromArray:@[@"articleId"]];
    
    RKRelationshipMapping *articleRelationship = [RKRelationshipMapping
                                                relationshipMappingFromKeyPath:@"article"
                                                toKeyPath:@"article"
                                                withMapping:articleMapping];
    
    
    //Configuration of Object Mapping for <Store class>
    
    RKObjectMapping *storeMapping = [RKObjectMapping requestMapping];
    [storeMapping addAttributeMappingsFromArray:@[@"name"]];
    
    RKRelationshipMapping *storeRelationship = [RKRelationshipMapping
                                                  relationshipMappingFromKeyPath:@"article.store"
                                                  toKeyPath:@"article.store"
                                                  withMapping:storeMapping];

    
    // Adding every nested class to Wrapper class <Article class>
    
    [promotionMapping addPropertyMapping:articleRelationship];
    [promotionMapping addPropertyMapping:storeRelationship];
    
    
    // Initiate Resquest Descriptor with Mapping Wrapper class <Promotion class>
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:promotionMapping
                                                                                   objectClass:[Promotion class]
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodPOST];
    
    /**
     RESPONSES DESCRIPTIOR CONFIGURATION
     **/
    
    // Construct a response mapping for our class
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[MetaMO class]];
    
    //Add Atributes to ObjectMapping
    [responseMapping addAttributeMappingsFromDictionary:@{
                                                          @"code":@"code",
                                                          @"errorType":@"errorType",
                                                          @"errorDetail":@"errorDetail"
                                                          }];
    
    // Initiate Resquest Descriptor with Mapping Wrapper class <Promotion class>
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                            method: RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath: nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    // Adding Request and Response descriptor to Object Manager by Posting the Wrapper <Promotion class> container of specific info
    
    [[_wsConnectionApache objectManager] addRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager] addResponseDescriptor:responseDescriptor];
    
    // Nesting the blocks to handle the success or failire routines
    
    [[_wsConnectionApache objectManager] postObject:promotion
                                               path:@"/CC/WS/WS_CreatePromotion.php"
                                         parameters:nil
                                            success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
                                                NSLog(@"Loading mapping result: %@", result);
                                                
                                            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                RKLogError(@"Operation failed with error: %@", error);
                                            }];
    
    [[_wsConnectionApache objectManager] removeRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager] removeResponseDescriptor:responseDescriptor];
    
}


// Implementation method of: Edit promotion
-(void) editPromotion:(Promotion *)promotion{
    
    /**
     REQUEST DESCRIPTIOR CONFIGURATION
     **/
    
    //Configuration of Entity Mapping for Wrapper <Promotion class>
    
    RKEntityMapping *promotionMapping = [RKEntityMapping mappingForEntityForName:@"Promotion"
                                                            inManagedObjectStore:[[_wsConnectionApache objectManager] managedObjectStore]];
    
    [promotionMapping setIdentificationAttributes:@[@"promotionId"]];

    [promotionMapping addAttributeMappingsFromDictionary:@{
                                                           @"promotion_id":@"promotionId",
                                                           @"percentage_discount":@"percentageDiscount",
                                                           @"start_date":@"creationDate",
                                                           @"end_date":@"dueDate"
                                                           }];
    
    //Configuration of Entity Mapping for <Article class>
    
    RKEntityMapping *articleMapping = [RKEntityMapping mappingForEntityForName:@"Article"
                                                            inManagedObjectStore:[[_wsConnectionApache objectManager] managedObjectStore]];
    
    [articleMapping setIdentificationAttributes:@[@"articleId"]];

    [articleMapping addAttributeMappingsFromArray : @[@"articleId"]];
    
    RKRelationshipMapping *articleRelationship = [RKRelationshipMapping
                                                  relationshipMappingFromKeyPath:@"article"
                                                  toKeyPath:@"article"
                                                  withMapping:articleMapping];
    
    
    //Configuration of Object Mapping for <Store class>
    RKEntityMapping *storeMapping = [RKEntityMapping mappingForEntityForName:@"Store"
                                                            inManagedObjectStore:[[_wsConnectionApache objectManager] managedObjectStore]];
    
    [storeMapping setIdentificationAttributes:@[@"storeId"]];

    [storeMapping addAttributeMappingsFromArray:@[@"name"]];
    
    RKRelationshipMapping *storeRelationship = [RKRelationshipMapping
                                                relationshipMappingFromKeyPath:@"store"
                                                toKeyPath:@"store"
                                                withMapping:storeMapping];
    
    
    // Adding every nested class to Wrapper class <Promotion class> and <Article class>

    [articleMapping addPropertyMapping:storeRelationship];
    [promotionMapping addPropertyMapping:articleRelationship];

    
    // Setting the tokens
    
    [[[_wsConnectionApache objectManager] HTTPClient] setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:[Constants GET_LABEL_NAME_ACCESS_TOKEN]]]];
    
    // Initiate Resquest Descriptor with Mapping Wrapper class <Promotion class>
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[promotionMapping inverseMapping]
                                                                                   objectClass:[Promotion class]
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodPOST];
    /**
     RESPONSES DESCRIPTIOR CONFIGURATION
     **/
    
    // Construct a response mapping for our class
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[MetaMO class]];
    
    //Add Atributes to ObjectMapping
    [responseMapping addAttributeMappingsFromDictionary:@{
                                                          @"code":@"code",
                                                          @"errorType":@"errorType",
                                                          @"errorDetail":@"errorDetail"
                                                          }];
    
    // Initiate Resquest Descriptor with Mapping Wrapper class <Promotion class>
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                            method: RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:@"/CC/WS/WS_UpdatePromotion.php"
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    // Adding Request and Response descriptor to Object Manager by Posting the Wrapper <Promotion class> container of specific info
    
    [[_wsConnectionApache objectManager] addRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager] addResponseDescriptor:responseDescriptor];
    
    // Nesting the blocks to handle the success or failire routines
    
    [[_wsConnectionApache objectManager] postObject:[self enqueueManagedObjectPromotion:promotion]
                                               path:@"/CC/WS/WS_UpdatePromotion.php"
                                         parameters:nil
                                            success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
                                                
                                                NSArray *promotionList = [result array];
                                                if([promotionList count]>0){
                                                    NSDictionary* userInfo = @{[Constants GET_LABEL_NAME_EDIT_PROMOTION_RESPOSNE]: promotionList};
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:[Constants GET_LABEL_NAME_EDIT_PROMOTION_RESPOSNE_NOTIFICATION] object:nil userInfo:userInfo];
                                                }else{
                                                    NSLog(@"Error, no object attached on response");
                                                }
                                                
                                            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                
                                                NSLog(@"Failed to EDIT to data store: %@", [error localizedDescription]);
                                                NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
                                                if(detailedErrors != nil && [detailedErrors count] > 0) {
                                                    for(NSError* detailedError in detailedErrors) {
                                                        RKLogError(@"  DetailedError: %@", [detailedError userInfo]);
                                                    }
                                                }
                                                else {
                                                    RKLogError(@"  %@", [error userInfo]);
                                                }
                                                
                                            }];
    
    [[_wsConnectionApache objectManager] removeRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager] removeResponseDescriptor:responseDescriptor];
    
}


#pragma mark - ManagedObject to Enqueue ManagedObject Conversors

-(Promotion*) enqueueManagedObjectPromotion:(Promotion*) promotion{
    
//    [[[_wsConnectionApache objectManager] HTTPClient] setAuthorizationHeaderWithToken:[[NSUserDefaults standardUserDefaults] objectForKey:[Constants GET_LABEL_NAME_ACCESS_TOKEN]]];
    

    
    Promotion *enqueuedPromotion =[NSEntityDescription insertNewObjectForEntityForName:@"Promotion"
                                                               inManagedObjectContext:[[[_wsConnectionApache objectManager] managedObjectStore] mainQueueManagedObjectContext]];
    
    [enqueuedPromotion setPromotionId:[promotion promotionId]];
    [enqueuedPromotion setName: [promotion name]];
    [enqueuedPromotion setPercentageDiscount:[promotion percentageDiscount]];
    [enqueuedPromotion setEffectiveness:[promotion effectiveness]];
    [enqueuedPromotion setCreationDate: [promotion creationDate]];
    [enqueuedPromotion setDueDate:[promotion dueDate]];
    
    [enqueuedPromotion setArticle:[self enqueueManagedObjectArticle:[promotion article]]];
    
    return enqueuedPromotion;
    
}

-(Article*) enqueueManagedObjectArticle:(Article*) article{
    Article *enqueuedArticle =[NSEntityDescription insertNewObjectForEntityForName:@"Article" inManagedObjectContext:[[[_wsConnectionApache objectManager] managedObjectStore] mainQueueManagedObjectContext]];
    
    [enqueuedArticle setArticleId: [article articleId]];
    
    [enqueuedArticle setStore: [self enqueueManagedObjectStore:[article store]]];

    return  enqueuedArticle;
}


-(Store*) enqueueManagedObjectStore:(Store*) store{
    Store *enqueuedStore =[NSEntityDescription insertNewObjectForEntityForName:@"Store" inManagedObjectContext:[[[_wsConnectionApache objectManager] managedObjectStore] mainQueueManagedObjectContext]];
    
    [enqueuedStore setStoreId: [store storeId]];
    [enqueuedStore setName: [store name]];
    
    return  enqueuedStore;
}

@end
