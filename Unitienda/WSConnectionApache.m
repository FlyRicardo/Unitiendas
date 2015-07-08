//
//  WSConnection.m
//  CC
//
//  Created by Fly on 11/26/14.
//  Copyright (c) 2014 ___FlyInc___. All rights reserved.
//

#import "WSConnectionApache.h"


@implementation WSConnectionApache{
    NSString *baseUrl;
    AFHTTPClient *client;
}

#pragma mark - Singleton Pattern implementation

static WSConnectionApache* _instance;

+(void)initialize{
    if(self == [WSConnectionApache class]){
        _instance = [[WSConnectionApache alloc]init];
    }
}


-(id)init{
    
    /**Configuration baseUrl to flyinc.co**/
//    baseUrl = @"http://www.flyinc.co" ;
    
    /**Configuration baseUrl to localhost:82**/
    baseUrl = @"http://127.0.0.1:82";
    
   return [self initWithBaseUrl:baseUrl];
    
}

-(id) initWithBaseUrl:(NSString *)url{
    if (self = [super init]) {
        
        // setup object mappings
        NSURL *baseURL = [NSURL URLWithString:url];
        client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
        
        _objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
        
        // Initialize managed object model from bundle
        NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        // Initialize managed object store
        RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
        _objectManager.managedObjectStore = managedObjectStore;
        
        // Complete Core Data stack initialization
        [managedObjectStore createPersistentStoreCoordinator];
        NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Unitienda.sqlite"];
        NSString *seedPath = [[NSBundle mainBundle] pathForResource:@"RKSeedDatabase" ofType:@"sqlite"];
        NSError *error;
        NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:seedPath withConfiguration:nil options:nil error:&error];
        NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
        
        // Create the managed object contexts
        [managedObjectStore createManagedObjectContexts];
        
        // Configure a managed object cache to ensure we do not create duplicate objects
        managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
        
    }
    return self;
}

+(id)getInstance{
    return _instance;
}

@end
