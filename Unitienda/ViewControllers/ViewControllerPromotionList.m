
//
//  ViewControllerPromotionList.m
//  Unitienda
//
//  Created by Fly on 5/7/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "ViewControllerPromotionList.h"
#import "WebServiceAbstractFactory.h"
#import "DataSyncServiceAbstractFactory.h"

#import "ViewControllerCreateEditProfile.h"
#import "ViewControllerCreateEditPromotion.h"

#import "RefreshTokenMetaMO.h"

#import "Constants.h"
#import "ArticleMO.h"
#import "Article.h"
#import "Photo.h"
#import "MetaMO.h"
#import "TableViewCellPromotion.h"
#import "ReachabilityImpl.h"

#import <CoreData/CoreData.h>


static NSString *kSegueIdentifierEditCreatePromotion = @"EditCreatePromotionSegue";
static NSString *kSegueIdentifierEditProfileSegue = @"EditUserProfileSegue";

@interface ViewControllerPromotionList()<NSFetchedResultsControllerDelegate>

@property (nonatomic) RefreshTokenMetaMO* refreshTokenResponseMO;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property DataSyncServiceAbstractFactory* dataSyncServiceAbstractFactory;

@property id dataSyncPromotion;
@property id dataChecker;
@property id wsPromotionConnector;

@end

@implementation ViewControllerPromotionList

-(void) viewDidLoad{
    [self configureElementsOnView];
    [self requestGetPromotionsByStore];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewDidLoad];
    [self configureNavigationBar];
}


/**
 *  Use to instantiate a the fetchedResultsController
 **/
- (NSFetchedResultsController *)fetchedResultsController{
    if (!_fetchedResultsController) {
        NSLog(@"Managed object context : %@", self.managedObjectContext);
        
        // Initialize Fetch Request
        //    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Promotion"];
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Promotion class])];
        
        // Add Sort Descriptors
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"promotionId" ascending:YES]]];
        
        // Add Sort Predicate
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"article.store.storeId",
//                                    @(1)
                                    @([[NSUserDefaults standardUserDefaults]
                                       integerForKey:[Constants GET_LABEL_STORE_ID]])
                                    ]];
        
        // Initialize Fetched Results Controller
        self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                         initWithFetchRequest:fetchRequest
                                         managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext
                                         //                                     managedObjectContext:self.managedObjectContext
                                         sectionNameKeyPath:nil
                                         cacheName:nil];
        
        
        // Configure this VC as Fetched Results Controller
        [self.fetchedResultsController setDelegate:self];
        
        // Perform Fetch
        NSError *error = nil;
        [self.fetchedResultsController performFetch:&error];
        
        if (error) {
            NSLog(@"Unable to perform fetch.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
    }
    return _fetchedResultsController;
}


#pragma mark - configuration of elements view
-(void) configureElementsOnView{
//    _tableView.contentInset = UIEdgeInsetsMake(0,0,0,-10);
    
    if([[self.fetchedResultsController sections] count]>0){
        [[self promotionNotFoundLabel] setHidden:YES];
    }else{
        [[self promotionNotFoundLabel] setHidden:NO];
    }
}

-(void) configureNavigationBar{
    //Shows the navigatoin bar
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    //The index of View controllers, for this case, should be : 2 , or the second view Added to the Navigation Controler
    UINavigationController *navigationController = [self.navigationController.viewControllers lastObject];
    UINavigationBar *navigationBar =[[navigationController navigationController] navigationBar];
    UINavigationItem* navigationItem = [navigationController navigationItem];
    
    [navigationBar setTintColor:[UIColor whiteColor]];
    [navigationBar setBarTintColor:[UIColor colorWithRed:(240.0/255.0) green:(141.0/255.0) blue:(36.0/255.0) alpha:1]];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [navigationItem setTitle: @"Promociones"];
    [navigationItem setHidesBackButton:YES];
}

#pragma mark - Call Web services
-(void) requestGetPromotionsByStore{
    
    _dataSyncPromotion = [DataSyncServiceAbstractFactory createPromotionDataSycn:Impl1];
    _dataChecker = [DataSyncServiceAbstractFactory createDataChecker:Impl1];
    _wsPromotionConnector = [WebServiceAbstractFactory createWebServicePromotionConnection:ApacheType];
    
    Store* store = (Store*)[NSEntityDescription
                                    insertNewObjectForEntityForName:@"Store"
                                    inManagedObjectContext:self.managedObjectContext];
    
//    [store setStoreId:[NSNumber numberWithInt: 1]];
    [store setStoreId:[NSNumber numberWithInt:(int)[[NSUserDefaults standardUserDefaults]
                                                    integerForKey:[Constants GET_LABEL_STORE_ID]]]];
    
    
    if(![_dataChecker hasData:self.managedObjectContext]){                                                                    //If dataChecker component doesnt detect any data, then force sync with WS
        
//        [_wsPromotionConnector getPromotionsByStoreWS:1];
        [_wsPromotionConnector getPromotionsByStoreWS:[[NSUserDefaults standardUserDefaults]
                                                       integerForKey:[Constants GET_LABEL_STORE_ID]]];
    }
    
    [_dataSyncPromotion getPromotionsByStore:store];

    if(![[ReachabilityImpl getInstance] wifiIsAvailable] && ![[ReachabilityImpl getInstance] tcpIpIsAvailable]){                                                                 //Couldn't stablish TCP/IP connection
        [self showAlertControllerWithTittle:@"No hay conexion a internet"
                                 AndMessage:@"No se ha detactado conexión a internet. Por favor revise sus preferencias de conexión e intentelo nuevamente."];
    }else if(![[ReachabilityImpl getInstance] hostIsReachable]){                                                                                                                    //Stablish TCP/IP connection, but couldn't stablish connection to the server
        [self showAlertControllerWithTittle:@"Error en los servidores de Unitienda"
                                 AndMessage:@"No se ha podido establecer conección con el servidor, por favor pongase en contacto con el administador"];
    }
}


-(void) requestRefreshToken{
//    id _wsLoginConnection = [WebServiceAbstractFactory createWebServiceLoginConnection:ApacheType];
//    [_wsLoginConnection refreshTokenWithRefreshToken:[[NSUserDefaults standardUserDefaults] valueForKey:[Constants GET_GRANT_TYPE_REFRESH_TOKEN]]];
    
}

#pragma mark - Implemented UITableViewDelegate
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.preservesSuperviewLayoutMargins = NO;
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView{
    return [[self.fetchedResultsController sections] count];
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
    [cell setPromotion:promotion AndManagedObjectContext:_managedObjectContext];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat kNormalCellHeigh = 94;
    return  kNormalCellHeigh;
}

#pragma mark - Implementing the Delegate Protocol: NSFetchedResultsControllerDelegate
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

#pragma mark - Alert controllers implementation
-(void) showAlertControllerWithTittle:(NSString*) title AndMessage:(NSString*)message{
    UIAlertAction *destroyAction;
    
    UIAlertController * alertController= [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    destroyAction = [UIAlertAction actionWithTitle:@"Aceptar"
                                             style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action) {
                                           }];
    
    [alertController addAction:destroyAction];
    [alertController setModalPresentationStyle:UIModalPresentationCurrentContext];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Action buttons of View

- (IBAction)editProfileButton:(id)sender {
    [self performSegueWithIdentifier:kSegueIdentifierEditProfileSegue sender:self];
}

- (IBAction)addPromotionButton:(id)sender {
    [self performSegueWithIdentifier:kSegueIdentifierEditCreatePromotion sender:self];
}


/**
 *  User this method to force sync with WS
 **/
- (IBAction)refreshPromotionFromWS:(id)sender {
    [_wsPromotionConnector getPromotionsByStoreWS:[[NSUserDefaults standardUserDefaults]
                                                        integerForKey:[Constants GET_LABEL_STORE_ID]]];
}

#pragma mark - Navigation programatically
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString: kSegueIdentifierEditProfileSegue]){
        
        ViewControllerCreateEditProfile *viewController = [segue destinationViewController];
        
//      Get entity description and set it on ManagedObjectContext
//        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Store class])];
        NSEntityDescription *entityDescription = [NSEntityDescription
                                                  entityForName:@"Store" inManagedObjectContext:_managedObjectContext];
        
        // Initialize Fetch Request
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        // Add Sort Predicate
        [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"storeId",
                                    @([[NSUserDefaults standardUserDefaults]
                                       integerForKey:[Constants GET_LABEL_STORE_ID]])
                                    ]];
        NSError *error;
        NSArray *array = [_managedObjectContext executeFetchRequest:request error:&error];
        if (array == nil){
            NSLog(@"Error getting info of store with id: %lu. Error: %@",[[NSUserDefaults standardUserDefaults]
                                                               integerForKey:[Constants GET_LABEL_STORE_ID]],
                  error);
        }
        Store *store = [array objectAtIndex:0];
        
        [viewController setStore:store];
        [viewController setCreationMode:NO];
        
    }if([[segue identifier] isEqualToString: kSegueIdentifierEditCreatePromotion]){
        
        ViewControllerCreateEditPromotion *viewController = [segue destinationViewController];
        
    }
}

@end