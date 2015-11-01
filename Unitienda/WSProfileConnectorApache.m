//
//  WSProfileConnectionApache.m
//  OAuthLoginSample
//
//  Created by Fly on 3/24/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "WSProfileConnectorApache.h"
#import "ProfileRequestMO.h"
#import "WSConnectionApache.h"
#import "StoreMO+RequestMO.h"
#import "Store.h"
#import "MetaMO.h"

#import "ProfileMO.h"

#import "Constants.h"

@interface WSProfileConnectorApache()

@property (nonatomic, strong) WSConnectionApache *wsConnectionApache;

@end


@implementation WSProfileConnectorApache

#pragma mark - Singleton Pattern implementation

static WSProfileConnectorApache* _instance;

+(void)initialize{
    if(self == [WSProfileConnectorApache class]){
        _instance = [[WSProfileConnectorApache alloc]init];
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

-(void) getProfielResponseMOWithUsername:(NSString*)username{
    
    [self stablishProfileConnectionWithUsername:username];
    
}

-(void) stablishProfileConnectionWithUsername:(NSString*)username{
    
    /**
     REQUEST DESCRIPTIOR CONFIGURATION
     **/
    
    // Construct a request mapping for our class
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
                                                         @"accessToken":@"access_token",
                                                         @"username":@"username"
                                                         }];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[ProfileRequestMO class]
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodPOST];
    
    ProfileRequestMO* postBody = [[ProfileRequestMO alloc]init];

    [postBody setUsername:username];
    [postBody setAccessToken:(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:[Constants GET_LABEL_NAME_ACCESS_TOKEN]]];
    
    /**
     RESPONSE DESCRIPTIOR CONFIGURATION
     **/
    
    //Construct a response mapping for Meta response
    RKObjectMapping *metaResponseMapping = [RKObjectMapping mappingForClass:[MetaMO class]];
    [metaResponseMapping addAttributeMappingsFromDictionary:@{
                                                         @"code":@"code",
                                                         @"errorType":@"errorType",
                                                         @"errorDetail": @"errorDetail"
                                                         }];
    
    //Seting up response descriptor
    RKResponseDescriptor *responseDescriptorMeta = [RKResponseDescriptor responseDescriptorWithMapping:metaResponseMapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:@"meta"
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    //Construct a response mapping for Meta response
    RKObjectMapping *profileResponseMapping = [RKObjectMapping mappingForClass:[ProfileMO class]];
    [profileResponseMapping addAttributeMappingsFromDictionary:@{
                                                              @"username":@"username",
                                                              @"first_name":@"firstName",
                                                              @"last_name": @"lastName"
                                                              }];
    
    //Seting up response descriptor
    RKResponseDescriptor *responseMappingProfile = [RKResponseDescriptor responseDescriptorWithMapping:profileResponseMapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:@"response"
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    
    
    //Adding request and response descriptor to ObjectManager
    [[_wsConnectionApache objectManager] addRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager] addResponseDescriptor:responseDescriptorMeta];
    [[_wsConnectionApache objectManager] addResponseDescriptor:responseMappingProfile];

    
    //Nesting the blocks to handle the success or failire routines
    [[_wsConnectionApache objectManager]postObject:postBody
                                              path:@"/CC/WS/WS_Profile.php"
                                        parameters:nil
                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
                                               
                                               NSArray *profileResponse = [result array];
                                               if([profileResponse count]>0){

                                                   NSDictionary* userInfo = @{[Constants GET_LABEL_NAME_PROFILE_RESPONSE]: profileResponse};
                                                       [[NSNotificationCenter defaultCenter] postNotificationName:[Constants GET_LABEL_NAME_PROFILE_RESPONSE_NOTIFICATION] object:nil userInfo:userInfo];
                                                   
                                               }else{
                                                   NSLog(@"Error, no object attached on response");
                                               }
                                               
                                           }failure:^(RKObjectRequestOperation *operation, NSError *error){
                                               
                                               MetaMO* response = [[MetaMO alloc]init];
                                               [NSString stringWithFormat:@"error code : %li",(long)[error code]];
                                               [response setCode:[error code]];
                                               [response setErrorDetail:[[error userInfo] objectForKey:@"NSLocalizedDescription"]];
                                               NSDictionary* userInfo = @{[Constants GET_LABEL_NAME_PROFILE_RESPONSE]: response};
                                               [[NSNotificationCenter defaultCenter] postNotificationName:[Constants GET_LABEL_NAME_PROFILE_RESPONSE_NOTIFICATION] object:nil userInfo:userInfo];
                                               
                                           }];
    
    //Flushing the request and response descriptors
    [[_wsConnectionApache objectManager] removeRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager] addResponseDescriptor:responseDescriptorMeta];
    [[_wsConnectionApache objectManager] addResponseDescriptor:responseMappingProfile];
    
}


-(void) createProfileWithStoreInfo:(Store *)store{
    /**
     REQUEST DESCRIPTIOR CONFIGURATION
     **/
    
    //Construct a request mapping for our class
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
                                                         @"accessToken":@"access_token",
                                                         @"name":@"name",
                                                         @"number":@"number",
                                                         @"email":@"email"
                                                         }];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[StoreMO class]
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodPOST];
    
    StoreMO* postBody = [[StoreMO alloc]init];
    
    [postBody setAccessToken:(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:[Constants GET_LABEL_NAME_ACCESS_TOKEN]]];
    [postBody setName:[store name]];
    [postBody setNumber:[store number]];
    [postBody setEmail: [store email]];
    
    
    /**
     RESPONSE DESCRIPTIOR CONFIGURATION
     **/
    
    //Construct a response mapping for our class
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[MetaMO class]];
    
    //Add Atributes to ObjectMapping
    [responseMapping addAttributeMappingsFromDictionary:@{
                                                           @"code":@"code",
                                                           @"errorType":@"errorType",
                                                           @"errorDetail":@"errorDetail"
                                                           }];

    
    //Seting up response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:@"meta"
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    //Adding request and response descriptor to ObjectManager
    [[_wsConnectionApache objectManager] addRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager] addResponseDescriptor:responseDescriptor];
    
    

    //Nesting the blocks to handle the success or failire routines
    [[_wsConnectionApache objectManager]postObject:postBody
                                              path:@"/CC/WS/WS_CreateStoreProfile.php"
                                        parameters:nil
                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
                                               
                                               NSArray* profileResponse = nil;
                                               profileResponse = [result array];
                                               if([profileResponse count]>0){
                                                   if([[profileResponse objectAtIndex:0] isKindOfClass:[MetaMO class]]){
                                                       MetaMO* response = (MetaMO*) [profileResponse objectAtIndex:0];
                                                       
                                                       NSDictionary* userInfo = @{[Constants GET_LABEL_NAME_PROFILE_CREATOR_UPDATER_RESPONSE]: response};
                                                       [[NSNotificationCenter defaultCenter] postNotificationName:[Constants GET_LABEL_NAME_PROFILE_CREATOR_UPDATER_RESPONSE_NOTIFICATION] object:nil userInfo:userInfo];
                                                   }else{
                                                       NSLog(@"Error converting the response to ResponseMO class");
                                                   }
                                               }else{
                                                   NSLog(@"Error, no object attached on response");
                                               }
                                               
                                           }failure:^(RKObjectRequestOperation *operation, NSError *error){
                                               
                                               MetaMO* response = [[MetaMO alloc]init];
                                               [NSString stringWithFormat:@"%li",(long)[error code]];
                                               [response setErrorDetail:[[error userInfo] objectForKey:@"NSLocalizedRecoverySuggestion"]];
                                               NSDictionary* userInfo = @{[Constants GET_LABEL_NAME_PROFILE_CREATOR_UPDATER_RESPONSE]: response};
                                               [[NSNotificationCenter defaultCenter] postNotificationName:[Constants GET_LABEL_NAME_PROFILE_CREATOR_UPDATER_RESPONSE_NOTIFICATION] object:nil userInfo:userInfo];
                                               
                                           }];
    
    //Flushing the request and response descriptors
    [[_wsConnectionApache objectManager] removeRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager] removeResponseDescriptor:responseDescriptor];
    
}

-(void) updateProfileWithStoreInfo:(Store *)store{
    
    /**
     REQUEST DESCRIPTIOR CONFIGURATION
     **/
    
    //Construct a request mapping for our class
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
                                                         @"accessToken":@"access_token",
                                                         @"storeId":@"id",
                                                         @"name":@"name",
                                                         @"number":@"number",
                                                         @"email":@"email"
                                                         }];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[StoreMO class]
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodPOST];
    
    StoreMO* postBody = [[StoreMO alloc]init];
    
    [postBody setAccessToken:(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:[Constants GET_LABEL_NAME_ACCESS_TOKEN]]];
    [postBody setStoreId:[[store storeId] intValue]];
    [postBody setName:[store name]];
    [postBody setNumber:[store number]];
    [postBody setEmail: [store email]];
    
    
    /**
     RESPONSE DESCRIPTIOR CONFIGURATION
     **/
    
    //Construct a response mapping for our class
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[MetaMO class]];
    
    //Add Atributes to ObjectMapping
    [responseMapping addAttributeMappingsFromDictionary:@{
                                                          @"code":@"code",
                                                          @"errorType":@"errorType",
                                                          @"errorDetail":@"errorDetail"
                                                          }];
    
    
    //Seting up response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:@"meta"
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    //Adding request and response descriptor to ObjectManager
    [[_wsConnectionApache objectManager] addRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager] addResponseDescriptor:responseDescriptor];
    
    
    
    //Nesting the blocks to handle the success or failire routines
    [[_wsConnectionApache objectManager]postObject:postBody
                                              path:@"/CC/WS/WS_UpdateStoreProfile.php"
                                        parameters:nil
                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
                                               
                                               NSArray* profileResponse = nil;
                                               profileResponse = [result array];
                                               if([profileResponse count]>0){
                                                   if([[profileResponse objectAtIndex:0] isKindOfClass:[MetaMO class]]){
                                                       MetaMO* response = (MetaMO*) [profileResponse objectAtIndex:0];
                                                       
                                                       NSDictionary* userInfo = @{[Constants GET_LABEL_NAME_PROFILE_CREATOR_UPDATER_RESPONSE]: response};
                                                       [[NSNotificationCenter defaultCenter] postNotificationName:[Constants GET_LABEL_NAME_PROFILE_CREATOR_UPDATER_RESPONSE_NOTIFICATION] object:nil userInfo:userInfo];
                                                   }else{
                                                       NSLog(@"Error converting the response to ResponseMO class");
                                                   }
                                               }else{
                                                   NSLog(@"Error, no object attached on response");
                                               }
                                               
                                           }failure:^(RKObjectRequestOperation *operation, NSError *error){
                                               
                                               MetaMO* response = [[MetaMO alloc]init];
                                               [NSString stringWithFormat:@"%li",(long)[error code]];
                                               [response setErrorDetail:[[error userInfo] objectForKey:@"NSLocalizedRecoverySuggestion"]];
                                               NSDictionary* userInfo = @{[Constants GET_LABEL_NAME_PROFILE_CREATOR_UPDATER_RESPONSE]: response};
                                               [[NSNotificationCenter defaultCenter] postNotificationName:[Constants GET_LABEL_NAME_PROFILE_CREATOR_UPDATER_RESPONSE_NOTIFICATION] object:nil userInfo:userInfo];
                                               
                                           }];
    
    //Flushing the request and response descriptors
    [[_wsConnectionApache objectManager] removeRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager] removeResponseDescriptor:responseDescriptor];
}


-(void) getProfileStore:(NSString*) email{
    /**
     REQUEST DESCRIPTIOR CONFIGURATION
     **/
    
    //Construct a request mapping for our class
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
                                                         @"accessToken":@"access_token",
                                                         @"email":@"email_store"
                                                         }];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[StoreMO class]
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodPOST];
    
    StoreMO* postBody = [[StoreMO alloc]init];
    
    [postBody setAccessToken:(NSString*)[[NSUserDefaults standardUserDefaults]
                                         objectForKey:[Constants GET_LABEL_NAME_ACCESS_TOKEN]]];
    [postBody setEmail:email];
    
    /**
     RESPONSE DESCRIPTIOR CONFIGURATION
     **/
    
    //Construct a response mapping for our class
    
    //Add Atributes to ObjectMapping.
    RKObjectMapping *metaResponseMapping = [RKObjectMapping mappingForClass:[MetaMO class]];
    [metaResponseMapping addAttributeMappingsFromDictionary:@{
                                                              @"code":@"code",
                                                              @"errorType":@"errorType",
                                                              @"errorDetail": @"errorDetail"
                                                              }];
    
    //Seting up response descriptor
    RKResponseDescriptor *responseDescriptorMeta = [RKResponseDescriptor responseDescriptorWithMapping:metaResponseMapping
                                                                                                method:RKRequestMethodPOST
                                                                                           pathPattern:nil
                                                                                               keyPath:@"meta"
                                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[StoreMO class]];
    [responseMapping addAttributeMappingsFromDictionary:@{
                                                          @"storeId":@"storeId",
                                                          @"name":@"name",
                                                          @"number":@"number",
                                                          @"latitude":@"latitude",
                                                          @"longitude":@"longitude",
                                                          @"email":@"email"
                                                          }];
    
    //Seting up response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:@"response.Store"
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    //Adding request and response descriptor to ObjectManager
    [[_wsConnectionApache objectManager] addRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager] addResponseDescriptor:responseDescriptor];
    [[_wsConnectionApache objectManager] addResponseDescriptor:responseDescriptorMeta];
    
    
    
    //Nesting the blocks to handle the success or failire routines
    
    NSLog(@"access_token on WSProgileConnectorApache: %@", [postBody accessToken]);
    [[_wsConnectionApache objectManager]postObject:postBody
                                              path:@"/CC/WS/WS_GetProfileStoreByKey.php"
                                        parameters:nil
                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
                                               
                                               NSArray* profileResponse = [result array];
                                               if([profileResponse count]>0){

                                                   NSDictionary* userInfo = @{[Constants GET_LABEL_NAME_PROFILE_STORE_RESPONSE]: profileResponse};
                                                   [[NSNotificationCenter defaultCenter] postNotificationName:[Constants GET_LABEL_NAME_PROFILE_STORE_RESPONSE_NOTIFICATION] object:nil userInfo:userInfo];
                                                   
                                               }else{
                                                   NSLog(@"Error, no object attached on response");
                                               }
                                               
                                           }failure:^(RKObjectRequestOperation *operation, NSError *error){
                                               
                                               MetaMO* responseMO = [[MetaMO alloc] init];
                                               [responseMO setCode:[error code]];
                                               [responseMO setErrorDetail:[[error userInfo] objectForKey:@"NSLocalizedRecoverySuggestion"]];
                                               NSDictionary* userInfo = @{[Constants GET_LABEL_NAME_PROFILE_STORE_RESPONSE]: responseMO};
                                               [[NSNotificationCenter defaultCenter] postNotificationName:[Constants GET_LABEL_NAME_PROFILE_STORE_RESPONSE_NOTIFICATION] object:nil userInfo:userInfo];
                                               
                                           }];
    
    //Flushing the request and response descriptors
    [[_wsConnectionApache objectManager] removeRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager] removeResponseDescriptor:responseDescriptor];
    [[_wsConnectionApache objectManager] removeResponseDescriptor:responseDescriptorMeta];
}


@end
