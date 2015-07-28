
//
//  ViewControllerPromotionList.m
//  Unitienda
//
//  Created by Fly on 5/7/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "ViewControllerPromotionList.h"
#import "DataSyncServiceAbstractFactory.h"

#import "RefreshTokenMetaMO.h"

#import "Constants.h"
#import "ArticleMO.h"
#import "Article.h"
#import "Photo.h"
#import "MetaMO.h"

#import "TableViewCellPromotion.h"

#import "Reachability.h"

@interface ViewControllerPromotionList()<NSFetchedResultsControllerDelegate>

@property (nonatomic) RefreshTokenMetaMO* refreshTokenResponseMO;

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation ViewControllerPromotionList

-(void) viewDidLoad{
    
    [super viewDidLoad];
    [self configureFetchedResultsController];
    [self registerNotifyProcess];
    [self configureNavigationBar];
    [self configureReachabilityParameters];
    [self requestGetPromotionsByStore];
}

-(void) viewWillAppear:(BOOL)animated{
}

-(void) viewWillDisappear:(BOOL)animated{
    [self unregisterNotifyProcess];
}

#pragma mark - NavigationController configuration
-(void) configureFetchedResultsController{
    NSLog(@"Managed object context : %@", self.managedObjectContext);
    
    // Initialize Fetch Request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Promotion"];
    
    // Add Sort Descriptors
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"promotionId" ascending:YES]]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"article.store.storeId", @(1)]];
    
    // Initialize Fetched Results Controller
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:fetchRequest
                                     managedObjectContext:self.managedObjectContext
                                     sectionNameKeyPath:nil
                                     cacheName:nil];
    
    
    // Configure Fetched Results Controller
    [self.fetchedResultsController setDelegate:self];
    
    // Perform Fetch
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
}

-(void) configureNavigationBar{
    //Shows the navigatoin bar
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    //The index of View controllers, for this case, should be : 2 , or the second view Added to the Navigation Controler
    UINavigationController *navigationController = [self.navigationController.viewControllers lastObject];
    UINavigationBar *navigationBar =[[navigationController navigationController] navigationBar];
    UINavigationItem* navigationItem = [navigationController navigationItem];
    
    [navigationBar setBarTintColor:[UIColor colorWithRed:(240.0/255.0) green:(141.0/255.0) blue:(36.0/255.0) alpha:1]];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [navigationItem setTitle: @"Promociones"];
    [navigationItem setHidesBackButton:YES];
}

#pragma mark - Call Web services

-(void) requestGetPromotionsByStore{
    id dataSyncPromotion = [DataSyncServiceAbstractFactory createPromotionDataSycn:Impl1];
    NSLog(@"Store id: %li",(long)[[[NSUserDefaults standardUserDefaults] valueForKey:[Constants GET_LABEL_STORE_ID]] integerValue]);
    StoreMO* store = [[StoreMO alloc]init];
    [store setStoreId:1];

    //ask for update ws
    NSLog(@"_hostReachability: %li",(long)[_hostReachability currentReachabilityStatus]);
    NSLog(@"_internetReachability: %li",(long)[_internetReachability currentReachabilityStatus]);
    NSLog(@"_wifiReachability: %li",(long)[_wifiReachability currentReachabilityStatus]);

    if([_hostReachability currentReachabilityStatus] !=  NotReachable){                                                             //The app stablish connectoin with the server successfully
        [dataSyncPromotion getPromotionsListByStore:store usingWSRequest:YES];
    }else if([_internetReachability currentReachabilityStatus] == NotReachable){                                                    //Couldn't stablish TCP/IP connection
        NSLog(@"No se ha detactado conexión a internet. Por favor revise sus preferencias de conexión e intentelo nuevamente.");
        [dataSyncPromotion getPromotionsListByStore:store usingWSRequest:NO];
    }else{
        NSLog(@"No se ha podido establecer conección con el servidor, por favor pongase en contacto con el administador");          //Stablish TCP/IP connection, but couldn't stablish connection to the server
        [dataSyncPromotion getPromotionsListByStore:store usingWSRequest:NO];
    }
}

/**
 *  Use to configure the parameters that is gonna check the internet connection
 **/
-(void) configureReachabilityParameters{
    //Change the host name here to change the server you want to monitor.
    NSString *remoteHostName = @"www.flyinc.co";
    
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
}

-(void) requestRefreshToken{
    
//    id _wsLoginConnection = [WebServiceAbstractFactory createWebServiceLoginConnection:ApacheType];
//    [_wsLoginConnection refreshTokenWithRefreshToken:[[NSUserDefaults standardUserDefaults] valueForKey:[Constants GET_GRANT_TYPE_REFRESH_TOKEN]]];
    
}

#pragma mark - Implemented UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView{
    return [[self.fetchedResultsController sections] count];
//    return 1;
}

- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section{
    
    NSArray *sections = [self.fetchedResultsController sections];
    
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* identifier = @"articleCell";
    TableViewCellPromotion* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell==nil){
        cell = [[TableViewCellPromotion alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    Promotion* promotion = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell setArticle:[promotion article]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat kNormalCellHeigh = 94;
    return  kNormalCellHeigh;
}

#pragma mark - Implementing the Delegate Protocol
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self configureCell:(TableViewCellPromotion*)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

- (void)configureCell:(TableViewCellPromotion *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Fetch Record
    NSManagedObject *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Update Cell
//    [cell.nameLabel setText:[record valueForKey:@"name"]];
//    [cell.doneButton setSelected:[[record valueForKey:@"done"] boolValue]];
}


#pragma mark - Notifying Web Service proccess
-(void)registerNotifyProcess{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivePromotionByStoreNotification:)
                                                 name:[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_DATASYNC_RESPONSE_NOTIFICATION]
                                               object:nil];
}

-(void)unregisterNotifyProcess{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_DATASYNC_RESPONSE_NOTIFICATION]
                                                  object:nil];
}

#pragma mark - Implement selector methods
-(void) receivePromotionByStoreNotification:(NSNotification *) notification{
    NSDictionary *dictionary = notification.userInfo;
    if([dictionary[[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_DATASYNC_RESPONSE]] isKindOfClass:[NSFetchRequest class]]){
        
//        Article* article = [promotionList objectAtIndex:0];
//        NSSet *photoList = [article photo];
//        Photo *photo = (Photo*)[photoList anyObject];
//        NSLog((@"Article at index : %i, with id: %@ ,name: %@, and photo url: %@"),0,[article articleId], [article name], [photo url]);
//        
//        article = [promotionList objectAtIndex:1];
//        photo = (Photo*)[photoList anyObject];
//        NSLog((@"Article at index : %i, with id: %@ ,name: %@, and photo url: %@"),1,[article articleId], [article name], [photo url]);
        
    }else if([dictionary[[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_DATASYNC_RESPONSE]] isKindOfClass:[MetaMO class]]){
        
        MetaMO* metaMO = (MetaMO*)dictionary[[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_DATASYNC_RESPONSE]];
        
        NSDictionary* userInfo = @{[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_WS_RESPONSE]: metaMO};
        [[NSNotificationCenter defaultCenter] postNotificationName:[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_DATASYNC_RESPONSE] object:nil userInfo:userInfo];
    }
}

@end
