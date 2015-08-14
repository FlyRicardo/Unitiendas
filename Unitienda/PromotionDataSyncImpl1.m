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
#import "Store.h"

#import "AppDelegate.h"

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
        /**
         *  In case of register notification proccess from NSNotificationManger, this code should be executed right here
         **/
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
    /**
     *  In case of unregister notification proccess from NSNotificationCenter, this code should be executed right here
     **/
}

+(id)getInstance{
    return _instance;
}

#pragma mark - Protocol methos implementation
/**
 *  Use to get the promotions of specific store. 
 *  CURRENTLY THIS METHOD IS NOT BEEN USED, BECAUSE THE NSFetchResultController approach
 **/
-(NSArray*) getPromotionsByStore:(Store*) store{
    // Fetching.

    NSManagedObjectContext *context = store.managedObjectContext;                                  //This NSManagedObject subclased retains a reference to its NSManagedObjectContext internally and it is possible access it
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Article"];
    
    // Add Sort Descriptor
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"articleId" ascending:YES];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"store.storeId", [[NSUserDefaults standardUserDefaults] objectForKey:[Constants GET_LABEL_STORE_ID]]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"store.storeId", @(1)];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    [fetchRequest setPredicate:predicate];
    
    // Execute Fetch Request
    NSError *fetchError = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&fetchError];
    
    if (!fetchError) {
        NSLog(@"Fetching data successfully.");
    } else {
        NSLog(@"Error fetching data.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
    }
    return result;
}
    
/**
 *  Get detail of specific promotion
 **/
-(Promotion*) getPromotionDetail:(Promotion*) prmotion{
    return nil;
}

@end
