//
//  WSArticleConnectorApache.m
//  Unitienda
//
//  Created by Fly on 9/8/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "WSArticleConnectorApache.h"
#import "WSConnectionApache.h"

#import "MetaMO.h"
#import "ArticleMO.h"

@interface WSArticleConnectorApache()

@property (nonatomic, strong) WSConnectionApache *wsConnectionApache;

@end

@implementation WSArticleConnectorApache

#pragma mark - Singleton Pattern implementation

static WSArticleConnectorApache* _instance;

+(void)initialize{
    if(self == [WSArticleConnectorApache class]){
        _instance = [[WSArticleConnectorApache alloc]init];
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

-(void) createArticle:(Article*) article{
    
    /**
     REQUEST DESCRIPTIOR CONFIGURATION
     **/
    
    //Configuration of Object Mapping for Wrapper class <ArticleMO>
    
    RKObjectMapping *articleMapping = [RKObjectMapping requestMapping];
    [articleMapping addAttributeMappingsFromArray:@[@"articleId",@"articleDescription",@"name",@"price"]];
    
    //Configuration of Object Mapping for storeId
    
    RKObjectMapping *storeMapping = [RKObjectMapping requestMapping];
    [storeMapping addAttributeMappingsFromArray:@[@"storeId"]];
    
    RKRelationshipMapping *storeRelationship = [RKRelationshipMapping
                                                relationshipMappingFromKeyPath:@"storeMO"
                                                toKeyPath:@"store"
                                                withMapping:storeMapping];
    
    //Configuration of Object Mapping for <ArticleCategory>
    
    RKObjectMapping *categoryMapping = [RKObjectMapping requestMapping];
    [categoryMapping addAttributeMappingsFromArray:@[@"categoryId"]];
    
    RKRelationshipMapping *categoryRelationship = [RKRelationshipMapping
                                                   relationshipMappingFromKeyPath:@"articleCategoryMO"
                                                   toKeyPath:@"articleCategory"
                                                   withMapping:categoryMapping];
    
    //Configuration of Object Mapping for array of <PhotoMO>
    
    RKObjectMapping *photoMapping = [RKObjectMapping requestMapping];
    [photoMapping addAttributeMappingsFromArray:@[@"name", @"type", @"url"]];
    
    RKRelationshipMapping *photoRelationship = [RKRelationshipMapping
                                                relationshipMappingFromKeyPath:@"photosMO"
                                                toKeyPath:@"photos"
                                                withMapping:photoMapping];
    
    [articleMapping addPropertyMapping:photoRelationship];
    [articleMapping addPropertyMapping:storeRelationship];
    [articleMapping addPropertyMapping:categoryRelationship];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:articleMapping
                                                                                   objectClass:[ArticleMO class]
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodPOST];
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
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                            method: RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath: nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    // Adding Request and Response descriptor to Object Manager by Posting the Wrapper <Article class> container of specific info
    
    [[_wsConnectionApache objectManager] addRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager] addResponseDescriptor:responseDescriptor];
    
    [[_wsConnectionApache objectManager] postObject:article
                                               path:@"/CC/WS/WS_CreateArticle.php"
                                         parameters:nil
                                            success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
                                                NSLog(@"Loading mapping result: %@", result);
                                                
                                            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                RKLogError(@"Operation failed with error: %@", error);
                                            }];
    
    [[_wsConnectionApache objectManager] removeRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager] removeResponseDescriptor:responseDescriptor];
    
}

-(void) editArticle:(Article*) article{
    /**
     REQUEST DESCRIPTIOR CONFIGURATION
     **/
    
    //Configuration of Object Mapping for Wrapper class <ArticleMO>
    
    RKObjectMapping *articleMapping = [RKObjectMapping requestMapping];
    [articleMapping addAttributeMappingsFromArray:@[@"articleId",@"articleDescription",@"name",@"price"]];
    
    //Configuration of Object Mapping for storeId
    
    RKObjectMapping *storeMapping = [RKObjectMapping requestMapping];
    [storeMapping addAttributeMappingsFromArray:@[@"storeId"]];
    
    RKRelationshipMapping *storeRelationship = [RKRelationshipMapping
                                                relationshipMappingFromKeyPath:@"storeMO"
                                                toKeyPath:@"store"
                                                withMapping:storeMapping];
    
    //Configuration of Object Mapping for <ArticleCategory>
    
    RKObjectMapping *categoryMapping = [RKObjectMapping requestMapping];
    [categoryMapping addAttributeMappingsFromArray:@[@"categoryId"]];
    
    RKRelationshipMapping *categoryRelationship = [RKRelationshipMapping
                                                   relationshipMappingFromKeyPath:@"articleCategoryMO"
                                                   toKeyPath:@"articleCategory"
                                                   withMapping:categoryMapping];
    
    //Configuration of Object Mapping for array of <PhotoMO>
    
    RKObjectMapping *photoMapping = [RKObjectMapping requestMapping];
    [photoMapping addAttributeMappingsFromArray:@[@"name", @"type", @"url"]];
    
    RKRelationshipMapping *photoRelationship = [RKRelationshipMapping
                                                relationshipMappingFromKeyPath:@"photosMO"
                                                toKeyPath:@"photos"
                                                withMapping:photoMapping];
    
    [articleMapping addPropertyMapping:photoRelationship];
    [articleMapping addPropertyMapping:storeRelationship];
    [articleMapping addPropertyMapping:categoryRelationship];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:articleMapping
                                                                                   objectClass:[ArticleMO class]
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodPOST];
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
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                            method: RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath: nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    
    [[_wsConnectionApache objectManager] addRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager] addResponseDescriptor:responseDescriptor];
    
    [[_wsConnectionApache objectManager] postObject:article
                                               path:@"/CC/WS/WS_EditArticle.php"
                                         parameters:nil
                                            success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
                                                NSLog(@"Loading mapping result: %@", result);
                                                
                                            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                RKLogError(@"Operation failed with error: %@", error);
                                            }];
    
    [[_wsConnectionApache objectManager] removeRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager] removeResponseDescriptor:responseDescriptor];
}

@end
