//
//  ViewControllerCreateEditPromotion.m
//  Unitienda
//
//  Created by Fly on 8/10/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "ViewControllerCreateEditPromotion.h"

#import "WebServiceAbstractFactory.h"

#import "Constants.h"
#import "RefreshTokenMetaMO.h"

#import "Promotion.h"
#import "Article.h"

#define kStartDateFieldTextIndex 6
#define kEndDateFieldTextIndex 9

#define kStartDatePickerViewIndex 7
#define kEndDatePickerViewIndex 10

#define kItemLabelIndex 0
#define kDiscountLabelIndex 2
#define kValidityLabelIndex 4
#define kStartDateLabelIndex 5
#define kEndDateLabelIndex 8

#define kNumberOfSections 1
#define kNumberOfRowsInSection 12

#define kLabelCellHeight 20
#define kFieldTextCellHeight 40

#define kDatePickerCellHeight 162

@interface ViewControllerCreateEditPromotion ()

@property (nonatomic) Boolean startDatePickerIsShowing;
@property (nonatomic) Boolean endDatePickerIsShowing;

@property (strong, nonatomic) UITextField *activeTextField;
@property (nonatomic) Promotion* promotion;

@end

@implementation ViewControllerCreateEditPromotion

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!_isCreationModeOn){
        [self initiateCoreDataComponets];
    }
    [self initiateUIComponents];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewWillAppear:(BOOL)animated{
    [self registerNotifyProcess];
}

-(void) viewWillDisappear:(BOOL)animated{
    [self unregisterNotifyProcess];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}


#pragma mark - setup components of ViewController

-(void) initiateUIComponents{

    int offset = 0.f;
    int offsetRigth = 0.f;
    self.tableView.contentInset = UIEdgeInsetsMake(offset, offsetRigth, 0, 0);
    
    [self hideStartDatePickerCell];
    [self hideEndDatePickerCell];
    
    // Configure toolbar
    // Add button of Done (hideKeyBoard) and button space.
    
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(hideKeyboard)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [[self percentageDiscountTextField] setInputAccessoryView:toolBar];
//  [[self itemNameTextField] setInputAccessoryView:toolBar];
    
    [_startDatePicker setMinimumDate:[NSDate date]];
    [_endDatePicker setMinimumDate:[NSDate date]];
    
    /**Configure navigation bar**/
    [self configureNavigationBar];
}


// Call all needs objects on core data

-(void) initiateCoreDataComponets{
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Promotion"
                                              inManagedObjectContext:_managedObjectContext];
    // Initialize Fetch Request
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    // Add Sort Predicate
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %i", @"promotionId",[_promotionId integerValue]]];
    
    NSError *error;
    NSArray *array = [_managedObjectContext executeFetchRequest:request error:&error];
    if (array == nil || [array count] == 0){
        NSLog(@"Error getting info of promotion with id: %li. Error: %@",(long)[_promotionId integerValue],error);
    }else{
        if([[array objectAtIndex:0] isKindOfClass:[Promotion class]]){
            _promotion = [array objectAtIndex:0];
        }
    }
    
    // Init values of components
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MMM/YYYY"];
    
    [[self startDatePicker] setDate:[_promotion creationDate]];
    [[self endDatePicker] setDate:[_promotion dueDate]];
    
    self.startDateFieldText.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:_promotion.creationDate]];
    
    self.endDateFieldText.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:_promotion.dueDate]];
    

    [[self itemNameTextField] setText:[_promotion name]];
    [[self priceTextField] setText:[NSString stringWithFormat:@"%@ %@",@"$",[[[_promotion article] price] stringValue]]];
    [[self percentageDiscountTextField] setText:[NSString stringWithFormat:@"%f%%",[[_promotion percentageDiscount] floatValue]]];
}

-(void) configureNavigationBar{
    //Shows the navigatoin bar
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    //Always extract the last object of view controller, that is the current navbar of the current view controller
    UINavigationController *navigationController = [self.navigationController.viewControllers lastObject];
    UINavigationBar *navigationBar =[[navigationController navigationController] navigationBar];
    UINavigationItem* navigationItem = [navigationController navigationItem];
    
    [navigationBar setBarTintColor:[UIColor colorWithRed:(232.0/255.0) green:(94.0/255.0) blue:(42.0/255.0) alpha:1]];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [navigationItem setTitle: ([self isCreationModeOn])?@"Crear promoción":@"Editar promoción"];
    [navigationItem setHidesBackButton:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kNumberOfRowsInSection;
}

#pragma mark - Listener identifier TableView Selected
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == kStartDateFieldTextIndex){
        if([self startDatePickerIsShowing]){
            [self hideStartDatePickerCell];
        }else{
            [self showStartDatePickerCell];
        }
    }else if(indexPath.row == kEndDateFieldTextIndex){
        if([self endDatePickerIsShowing]){
            [self hideEndDatePickerCell];
        }else{
            [self showEndDatePickerCell];
        }
    }
}

#pragma mark - Calculator height for a given row

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = self.tableView.rowHeight;
    if (indexPath.row == kStartDatePickerViewIndex){
        height = self.startDatePickerIsShowing ? kDatePickerCellHeight:0.0f;
    }else if(indexPath.row == kEndDatePickerViewIndex){
        height = self.endDatePickerIsShowing ? kDatePickerCellHeight:0.0f;
    }else if(indexPath.row == kItemLabelIndex || indexPath.row == kDiscountLabelIndex||
             indexPath.row == kValidityLabelIndex || indexPath.row == kStartDateLabelIndex ||
             indexPath.row == kEndDateLabelIndex){
        height = kLabelCellHeight;
    }
    return height;
}

#pragma mark - UI View effects to PickerViews
-(void) showStartDatePickerCell{
    self.startDatePickerIsShowing = YES;
    [self.tableView beginUpdates];
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.startDatePicker.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         self.startDatePicker.hidden = NO;
                     }];
    [self.tableView endUpdates];
}

-(void) hideStartDatePickerCell{
    self.startDatePickerIsShowing = NO;
    [self.tableView beginUpdates];
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.startDatePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         self.startDatePicker.hidden = YES;
                     }];

    [self.tableView endUpdates];
}

-(void) showEndDatePickerCell{
    self.endDatePickerIsShowing = YES;
    [self.tableView beginUpdates];
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.endDatePicker.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         self.endDatePicker.hidden = NO;
                     }];
    [self.tableView endUpdates];
}

-(void) hideEndDatePickerCell{
    self.endDatePickerIsShowing = NO;
    [self.tableView beginUpdates];
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.endDatePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         self.endDatePicker.hidden = YES;
                     }];
    [self.tableView endUpdates];
}

#pragma mark - Change the content of picker

- (IBAction)startDateChanged:(id)sender {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MMM/YYYY"];
    self.startDateFieldText.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:self.startDatePicker.date]];
}

- (IBAction)endDateChanged:(id)sender {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MMM/YYYY"];
    self.endDateFieldText.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:self.endDatePicker.date]];
}

#pragma mark - Action mehthod of save/edit button
- (IBAction)actionSaveEdit:(id)sender {
    
    // Send Alerts notifying user about creation or edit
    
    if(![self formCorrectlyFilled]){
        [self showAlertControllerOfNotificationWithTitle:@"Es necesario diligenciar todos los campos del formulario promoción"];
    }else{
        [self showAlertControllerOfFlow];
    }
    
}

#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
}


#pragma mark - Resign hide keyboard

-(void) hideKeyboard{
    [self.activeTextField resignFirstResponder];
}


#pragma mark - Call Web Services

-(void) requestCreateOrEditPromotion{
    
    //Prepare Promotion Object
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *temp;
    
    [_promotion setName:[_itemNameTextField text]];
    
    temp = [f numberFromString:[[_priceTextField text] stringByReplacingOccurrencesOfString:@"$" withString:@""]];
    [[_promotion article] setPrice: temp];
    
    temp = [f numberFromString:[[_percentageDiscountTextField text] stringByReplacingOccurrencesOfString:@"%" withString:@""]];
    [_promotion setPercentageDiscount: temp];
    
    [_promotion setCreationDate:[_startDatePicker date]];
    [_promotion setDueDate:[_endDatePicker date]];
    
    id wsPromotionConnector = [WebServiceAbstractFactory createWebServicePromotionConnection:ApacheType];
    if(_isCreationModeOn){
        [wsPromotionConnector createPromotion:_promotion];
    }else{
        [wsPromotionConnector editPromotion:_promotion];
    }
}


-(void) requestRefreshToken{
    id _wsLoginConnection = [WebServiceAbstractFactory createWebServiceLoginConnection:ApacheType];
    [_wsLoginConnection refreshTokenWithRefreshToken:[[NSUserDefaults standardUserDefaults] valueForKey:[Constants GET_GRANT_TYPE_REFRESH_TOKEN]]];
}

#pragma mark - Notifying Web services proccess
-(void) registerNotifyProcess{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveRefreshNotification:)
                                                 name:[Constants GET_LABEL_NAME_REFRESH_TOKEN_RESPONSE_NOTIFICATOIN]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveEditPromotionNotification:)
                                                 name:[Constants GET_LABEL_NAME_EDIT_PROMOTION_RESPOSNE_NOTIFICATION]
                                               object:nil];
}

-(void) unregisterNotifyProcess{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:[Constants GET_LABEL_NAME_REFRESH_TOKEN_RESPONSE_NOTIFICATOIN]
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:[Constants GET_LABEL_NAME_EDIT_PROMOTION_RESPOSNE_NOTIFICATION]
                                               object:nil];
}

-(void)receiveRefreshNotification:(NSNotification *) notification{
    NSDictionary *dictionary = notification.userInfo;
    RefreshTokenMetaMO* refreshTokenResponseMO = (RefreshTokenMetaMO*) dictionary[[Constants GET_LABEL_NAME_REFRESH_TOKEN_RESPONSE]];
    
    if([[refreshTokenResponseMO errorDetail ] containsString: [Constants GET_ERROR_DESCRIPTION_EXPIRED_REFRESH_TOKEN_VALUE] ]){     //Refresh token has expired. The authentication proccess has to star again.
        
        //Return application to loggin (remove as many view as viewController had sotored)
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
        [viewControllers removeLastObject];
        [[self navigationController] setViewControllers:viewControllers animated:YES];
        
        
    }else if([refreshTokenResponseMO errorDetail] == 0){         //Not error reported
        
        //Save the access token, and username
        [[NSUserDefaults standardUserDefaults]setObject:[refreshTokenResponseMO accessToken] forKey:[Constants GET_LABEL_NAME_ACCESS_TOKEN]];
        
#warning Write "CreatePromotion" method
        [self requestCreateOrEditPromotion];
    }
}

-(void) receiveEditPromotionNotification:(NSNotification *) notification{
    NSDictionary *dictionary = notification.userInfo;
    NSArray* array = dictionary[[Constants GET_LABEL_NAME_EDIT_PROMOTION_RESPOSNE]];
    
    if([array count] == 1 && [[array objectAtIndex:0] isKindOfClass:[MetaMO class]]){
        MetaMO* meta = (MetaMO*)[array objectAtIndex:0];
        if([meta code] == 401 && [[meta errorDetail] isEqualToString:[Constants GET_ERROR_DESCRIPTION_EXPIRED_TOKEN_VALUE]]){
            [self requestRefreshToken];
        }else if([meta code] == 200){
            [self showAlertControllerOfNotificationWithTitle:@"La promoción fué editada correctamente"];
            RKLogError(@"Success edit");
        }
    }else{
        RKLogError(@"Error updating Promotion");
    }
}



#pragma mark - AlertController configuration

/**
 *  Use to show an Alert Controller that call a method of specific WS product
 **/

-(void) showAlertControllerOfFlow{
    UIAlertAction *destroyAction;
    UIAlertAction *otherAction;
    
    NSString *title = (_isCreationModeOn)?@"Está seguro de crear un articulo con la configuración dada?"
                                         :@"Está seguro de editar un articulo con la configuración dada?";
    
    UIAlertController * alertController= [UIAlertController alertControllerWithTitle:title
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    destroyAction = [UIAlertAction actionWithTitle:@"Si"
                                             style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action) {
                                               [self requestCreateOrEditPromotion];
                                           }];
    
    otherAction = [UIAlertAction actionWithTitle:@"No"
                                           style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction *action) {
                                             [alertController dismissViewControllerAnimated:YES completion:nil];
                                         }];
    
    [alertController addAction:destroyAction];
    [alertController addAction:otherAction];
    [alertController setModalPresentationStyle:UIModalPresentationCurrentContext];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) showAlertControllerOfNotificationWithTitle:(NSString* ) title{
    
    UIAlertAction *dismissAction;
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    dismissAction = [UIAlertAction actionWithTitle:@"OK"
                                           style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction *action) {
                                             [alertController dismissViewControllerAnimated:YES completion:nil];
                                         }];
    
    [alertController addAction:dismissAction];
    [alertController setModalPresentationStyle:UIModalPresentationCurrentContext];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


/**
 Validate if all form fields are fill
 **/

-(Boolean) formCorrectlyFilled{
    
    if(([_itemNameTextField text] && [[_itemNameTextField text] length]>0) &&
       ([_priceTextField text] && [[_priceTextField text] length]>0) &&
       ([_percentageDiscountTextField text] && [[_percentageDiscountTextField text] length]>0)){
        
        return true;
    }
    
    return false;
}

@end
