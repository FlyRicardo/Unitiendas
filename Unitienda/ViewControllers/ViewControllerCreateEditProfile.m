//
//  ViewControllerCreateProfile.m
//  Unitienda
//
//  Created by Fly on 4/12/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "ViewControllerCreateEditProfile.h"

#import "WSLoginConnector.h"
#import "RefreshTokenMetaMO.h"
#import "LogoutMetaMO.h"
#import "WebServiceAbstractFactory.h"

#import "Store.h"

#import "ViewControllerSelectVenue.h"
#import "ViewControllerPromotionList.h"

#import "Constants.h"

#import <QuartzCore/QuartzCore.h>

#define kNameStoreFieldIndex 1

#define kVenuePickerIndex 2
#define kPasswordFieldsIndex 5
#define kVenuePickerCellHeight 270
#define kPasswordFieldsCellHeight 90

#define kTextFieldCurrentPasswor 5
#define kTextFieldNewPasswor 7
#define kTextFieldConfirmPasswor 9


static NSString *kSegueIdentifierInMap = @"selectVenueInMapSegue";
static NSString *kSegueIdentifierPromotionList = @"CreateProfiileToPromotionListSegue";

@interface ViewControllerCreateEditProfile()
    
@property (nonatomic) RefreshTokenMetaMO* refreshTokenResponseMO;
@property (nonatomic) LogoutMetaMO*  logoutResponseMO;

@property (strong, nonatomic) IBOutlet UITableView *tableViewCreateProfile;
@property (strong, nonatomic) IBOutlet UIPickerView *venuePicker;
@property (strong, nonatomic) IBOutlet UILabel *labelValueVenue;
@property (weak, nonatomic) IBOutlet UIView *contentPickerView;


@property (weak, nonatomic) IBOutlet UIView *contentPasswordFields;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCurrentPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldConfirmNewPassword;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (strong, nonatomic) NSMutableArray *errors;
@property (nonatomic, assign) Boolean wasCreateProfielNotified;
@property (nonatomic, assign) Boolean wasChangePasswordNotified;
@property (nonatomic, assign) Boolean wasCreateProfielSuccessfully;
@property (nonatomic, assign) Boolean wasChangePasswordSuccessfully;

@property (nonatomic) Boolean venuerPickerIsShowing;
@property (nonatomic) Boolean passwordFieldsAreShowing;
@property NSArray* dataPicker;
@property NSDictionary *dictionaryStorePoint;
@property NSString *venueSelected;

@property (strong, nonatomic) UITextField *activeTextField;

@property (strong, nonatomic)UIActivityIndicatorView *activityIndicator;

@end


@implementation ViewControllerCreateEditProfile

-(void) viewDidLoad{
    [super viewDidLoad];
    [self initiateCoreDataComponet];
    [self initiateUIComponents];
    [self hideVenuePickerCell];
    [self hidePasswordFieldsCell];
    [self initActivityIndicator];
}

-(void) viewWillAppear:(BOOL)animated{
    [self registerNotifyProcess];
    [self configureNavigationBar];
    [self signUpForKeyboardNotifications];
}

-(void) viewWillDisappear:(BOOL)animated{
    [self unregisterNotifyProcess];
    [self unregisterForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
}

#pragma mark - setting up venue picker
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = self.tableViewCreateProfile.rowHeight;
    if (indexPath.row == kVenuePickerIndex){
        height = self.venuerPickerIsShowing ? kVenuePickerCellHeight:0.0f;
    }else if(indexPath.row == kPasswordFieldsIndex){
        height = self.passwordFieldsAreShowing ? kPasswordFieldsCellHeight:0.0f;
    }
    return height;
}

#pragma mark - setup components of ViewController

-(void) initiateUIComponents{
    
    //Init venue element
    _dataPicker= [Constants GET_NUMBER_STORES];
    _dictionaryStorePoint = [Constants GET_POSITION_DICTIONARY_STORE_NUMBER_AS_KEY];
    
    ////Init the form of store info
    [_nameTextField setText:[_store name]];
    [_labelValueVenue setText:[_store number]];
    [_emailTextField setText:[[NSUserDefaults standardUserDefaults]valueForKey:[Constants GET_LABEL_USER_NAME]]];
    
    //Init stock of alert controllers
    _errors = [[NSMutableArray alloc]init];
    _wasChangePasswordNotified = NO;
    _wasCreateProfielNotified = NO;

}

-(void) initiateCoreDataComponet{
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Store"
                                              inManagedObjectContext:_managedObjectContext];
    
    // Initialize Fetch Request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    // Add Sort Predicate
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"storeId",
                           [[NSUserDefaults standardUserDefaults]
                            valueForKey:[Constants GET_LABEL_STORE_ID]]
                           ]];
    
//            [request setPredicate:[NSPredicate predicateWithFormat:@"storeId == %@",
//                                   [[NSUserDefaults standardUserDefaults]
//                                    valueForKey:[Constants GET_LABEL_STORE_ID]]
//                                   ]];

    NSError *error;
    NSArray *array = [_managedObjectContext executeFetchRequest:request error:&error];
    if (array == nil || [array count] == 0){
        NSLog(@"Error getting info of store with id: %lu. Error: %@",(long)[[NSUserDefaults standardUserDefaults]
                                                                            integerForKey:[Constants GET_LABEL_STORE_ID]],error);
    }

    for (int i = 0 ; i < [array count]; i++) {                                        // This was neccesary, because the NSPredicate senteces, was returning the array result with an extra object with all its parameters as nil
        Store *temp = [array objectAtIndex:i];
        NSLog(@"store name : %@, store number: %@, store email: %@, with id : %lu",[temp name],[temp number],[temp email], (long)[[temp storeId]integerValue]);
        if([temp name] != nil){
            _store = temp;
            break;
        }
    }
    
}

#pragma mark - NavigationController configuration
-(void) configureNavigationBar{
    //Shows the navigatoin bar
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    //Always extract the last object of view controller, that is the current navbar of the current view controller
    UINavigationController *navigationController = [self.navigationController.viewControllers lastObject];
    UINavigationBar *navigationBar =[[navigationController navigationController] navigationBar];
    UINavigationItem* navigationItem = [navigationController navigationItem];

    [navigationBar setBarTintColor:[UIColor colorWithRed:(255.0/255.0) green:(210.0/255.0) blue:(9.0/255.0) alpha:1]];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [navigationItem setTitle: @"Crear perfilr"];
    [navigationItem setHidesBackButton:NO];
}

#pragma mark - protocol methods of UIPickerViewDataSource, UIPickerViewDelegate
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _dataPicker.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _dataPicker[row];
}

#pragma mark - Listener identifier TableView Selected
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1){
        
        if (self.venuerPickerIsShowing){
            
            [self hideVenuePickerCell];
            
        }else {
            
            [self.activeTextField resignFirstResponder];
            [self showVenuePickerCell];
        }
    }else if(indexPath.row == 4){
        
        if (self.passwordFieldsAreShowing){
            
            [self hidePasswordFieldsCell];
            
        }else {
            
            [self.activeTextField resignFirstResponder];
            [self showPasswordFieldsCell];
        }
    }
    
    [self.tableViewCreateProfile deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UI View effects to PickerView
- (void)showVenuePickerCell {
    
    self.venuerPickerIsShowing = YES;
    
    [self.tableViewCreateProfile beginUpdates];
    [self.tableViewCreateProfile endUpdates];
    
    self.contentPickerView.hidden = NO;
    self.contentPickerView.alpha = 0.0f;

    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.contentPickerView.alpha = 1.0f;
        
    }];
}


- (void)hideVenuePickerCell {
    
    self.venuerPickerIsShowing = NO;
    
    [self.tableViewCreateProfile beginUpdates];
    [self.tableViewCreateProfile endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.contentPickerView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.contentPickerView.hidden = YES;
                     }];
}

#pragma mark - UI View effects to change passwords fields

- (void)showPasswordFieldsCell {
    
    self.passwordFieldsAreShowing = YES;
    [self. tableViewCreateProfile beginUpdates];
    [self.tableViewCreateProfile endUpdates];
    
    self.contentPasswordFields.hidden= NO;
    
    self.contentPasswordFields.alpha= 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.contentPasswordFields.alpha = 1.0f;
    }];
    
}

-(void) hidePasswordFieldsCell{
    self.passwordFieldsAreShowing = NO;
    
    [self.tableViewCreateProfile beginUpdates];
    [self.tableViewCreateProfile endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.contentPasswordFields.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.contentPasswordFields.hidden = YES;
                     }];

}

#pragma mark - KeyBoard Notifications
- (void)signUpForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                            object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)unregisterForKeyboardNotifications
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWillShow:(NSNotification*)aNotification {
    if (self.venuerPickerIsShowing){
        [self hideVenuePickerCell];
    }if(self.passwordFieldsAreShowing && self.activeTextField.tag != kTextFieldCurrentPasswor
        && self.activeTextField.tag != kTextFieldNewPasswor && self.activeTextField.tag != kTextFieldConfirmPasswor){ // Hide the Password viewContainer only when the focus of app ( first responder ) will not be one of the fields of Password : current, new and confirm new.
        [self hidePasswordFieldsCell];
    }
    
    [self moveUpTableViewContent:aNotification];
}

-(void)keyboardWillBeHidden:(NSNotification*)aNotification{
    [self moveDownTableViewContent:aNotification];
}

// Method of UITextFieldDelegate to hide keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [_activeTextField resignFirstResponder];
}

#pragma mark - Effect moving content TableView when KeyBoard showing/hiding
- (void) moveUpTableViewContent:(NSNotification*)aNotification                                                  // Move the tableView content up 100 units
                                                                                                                // Called when the UIKeyboardDidShowNotification is sent
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height+40, 0.0);        //The addition of 40 is to appearing the text field hided
    self.tableViewCreateProfile.contentInset = contentInsets;
    self.tableViewCreateProfile.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin) )   //If the area of view.frame is hidding the activeTextField.frame.origin
    {
        [self.tableViewCreateProfile scrollRectToVisible:self.activeTextField.frame animated:YES];
    }
}


- (void) moveDownTableViewContent:(NSNotification*)aNotification                                                // Called when the UIKeyboardWillHideNotification is sent
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableViewCreateProfile.contentInset = contentInsets;
    self.tableViewCreateProfile.scrollIndicatorInsets = contentInsets;
}

#pragma mark - Change the content of picker
- (IBAction)pickerVenueChanged:(UIPickerView *)sender {
    
    //Every UIPickerView have a delegate, in this case: self.
    //Asking this delegate for your picker's selected row title via something like:
    _venueSelected =[self pickerView:sender titleForRow:[sender selectedRowInComponent:0] forComponent:0];
    [_labelValueVenue setText:_venueSelected];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self pickerVenueChanged:_venuePicker];
}


#pragma mark - SelectVenueDelegate methods
-(void)showStoreNumber:(NSString*)storeNumber{
    [_labelValueVenue setText:storeNumber];
    NSInteger rowOfComponent = [[[storeNumber componentsSeparatedByString:@"-"] objectAtIndex:1]integerValue]-100;
    [_venuePicker selectRow:rowOfComponent inComponent:0 animated:YES];
}

#pragma mark - Notifying Web services proccess
-(void)registerNotifyProcess{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveRefreshNotification:)
                                                 name:[Constants GET_LABEL_NAME_REFRESH_TOKEN_RESPONSE_NOTIFICATOIN]
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveCreateProfileNotification:)
                                                 name:[Constants GET_LABEL_NAME_PROFILE_CREATOR_UPDATER_RESPONSE_NOTIFICATION]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveChangePasswordNotification:)
                                                 name:[Constants GET_LABEL_NAME_PROFILE_CHANGE_PASSWORD_RESPONSE_NOTIFICATION]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLogoutNotification:)
                                                 name:[Constants GET_LABEL_NAME_LOGOUT_RESPONSE_NOTIFICATION]
                                               object:nil];
    
    //register to notify logout proccess
}

-(void) unregisterNotifyProcess{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:[Constants GET_LABEL_NAME_REFRESH_TOKEN_RESPONSE_NOTIFICATOIN]
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:[Constants GET_LABEL_NAME_PROFILE_CREATOR_UPDATER_RESPONSE_NOTIFICATION]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:[Constants GET_LABEL_NAME_PROFILE_CHANGE_PASSWORD_RESPONSE_NOTIFICATION]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:[Constants GET_LABEL_NAME_LOGOUT_RESPONSE_NOTIFICATION]
                                                  object:nil];

}

-(void)receiveRefreshNotification:(NSNotification *) notification{
    NSDictionary *dictionary = notification.userInfo;
    _refreshTokenResponseMO = (RefreshTokenMetaMO*) dictionary[[Constants GET_LABEL_NAME_REFRESH_TOKEN_RESPONSE]];
    
    if([[_refreshTokenResponseMO errorDetail ] containsString: [Constants GET_ERROR_DESCRIPTION_EXPIRED_REFRESH_TOKEN_VALUE] ]){     //Refresh token has expired. The authentication proccess has to star again.
        
        //Return application to loggin (remove as many view as viewController had sotored)
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
        [viewControllers removeLastObject];
        [[self navigationController] setViewControllers:viewControllers animated:YES];
        
        
    }else if([_refreshTokenResponseMO errorDetail] == 0){         //Not error reported
        
        //Save the access and refresh token, and username
        [[NSUserDefaults standardUserDefaults]setObject:[_refreshTokenResponseMO accessToken] forKey:@"access_token"];
        
        [self requestCreateStoreProfile];
        [self requestChangePassword];
    }
}


-(void)receiveCreateProfileNotification:(NSNotification*) notification{
    
    _wasCreateProfielNotified = YES;
    
    NSDictionary *dictionary = notification.userInfo;
    MetaMO *meta = (MetaMO*) dictionary[[Constants GET_LABEL_NAME_PROFILE_CREATOR_UPDATER_RESPONSE]];
    
    if([meta code] == 200){
        /**Once notified the success update of register on server, has to be saved the NSManagedObject Store updated**/
        NSError *error = nil;
        if(![_managedObjectContext save:&error]){
            NSLog(@"Could not save store: %@", [error userInfo]);
        }
        
        _wasCreateProfielSuccessfully = YES;
        [self showAlertControllerWithTitle:@"Su perfil fue guardado exitosamente" message:@""];
        
    }else if([[meta errorDetail] isEqualToString:[Constants GET_ERROR_DESCRIPTION_EXPIRED_TOKEN_VALUE]]){
        
        [self requestRefreshToken];
        
    }else if([meta code] != 0){                                                                             // Handling posible errors:
                                                                                                            // 1)Duplicate entry for number_store
                                                                                                            // 2)Duplicate entry for email
        
        if([[meta errorDetail] containsString:@"Duplicate entry"]){
            NSString* message;
            if([[meta errorDetail ] containsString:@"\'number\'"]){
                message = @"El número de local ya ha sido selecionado. \n Por favor seleccione otro o comuniquese con el administrador";
                
            }else if([[meta errorDetail ] containsString:@"\'email\'"]){
                message = @"El email ya ha sido seleccoinado.\n Por favor seleccione otro o comuniquese con el administrador";
            }
            
            NSError *error = [NSError errorWithDomain:@"Error creando perfil"
                                                 code:-101
                                             userInfo:@{
                                                        @"error_description":message
                                                        }];
            [_errors addObject:error];                                                                      // Global NSMutableArray to coordinate:
                                                                                                            // Notification of Create promotion
                                                                                                            // Notification of Change password
            [self showAlertControllerUsingNSError];
        }
    }
    
}

-(void) receiveChangePasswordNotification:(NSNotification*) notification{
    
    _wasChangePasswordNotified = YES;
    
    NSDictionary *dictionary = notification.userInfo;
    MetaMO *responseMO = (MetaMO*) dictionary[[Constants GET_LABEL_NAME_PROFILE_CHANGE_PASSWORD_RESPONSE]];
    
    if([responseMO code] == 200){
        
        _wasChangePasswordSuccessfully = YES;
        [self showAlertControllerWithTitle:@"Cambio de contraseña exitoso" message:@""];
        
    }else if([[responseMO errorType ] containsString:@"Password incorrect"] ||
             [[responseMO errorDetail] containsString:@"The enter password was incorrect"]){

        NSError *error = [NSError errorWithDomain:@"Error cambiando password"
                                             code:-101
                                         userInfo:@{
                                                    @"error_description":@"Password incorrecto, ó, nuevo password y confirmación de password no coincide."
                                                    }];
        [_errors addObject:error];                                                                          // Global NSMutableArray to coordinate:
                                                                                                            // Notification of Create promotion
                                                                                                            // Notification of Change password
        [self showAlertControllerUsingNSError];
    }
    
}

-(void) receiveLogoutNotification:(NSNotification*) notification{
    
    NSDictionary *dictionary = notification.userInfo;
    MetaMO *meta = (MetaMO*) dictionary[[Constants GET_LABEL_NAME_LOGOUT_RESPONSE]];
    
    if([meta code] == 200){
        
        /**Pops all the view controllers on the stack except the root view controller and updates the display**/
        [[self navigationController] popToRootViewControllerAnimated:NO];
        
    }else{
        [self showAlertControllerWithTitle:@"Error cerrando sesión" message: [meta errorDetail]];
    }
    
}



#pragma mark - AlertController configuration

-(void) showAlertControllerConfirmRequest{
    
    [self showActivitiIndicator:NO];
    
    UIAlertAction *destroyAction;
    UIAlertAction *otherAction;
    
    UIAlertController * alertController= [UIAlertController alertControllerWithTitle:@"Confirma que desea guardar su perfil?"
                                                           message:nil
                                                    preferredStyle:UIAlertControllerStyleAlert];
    
    destroyAction = [UIAlertAction actionWithTitle:@"Si"
                                             style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action) {
                                               [self showActivitiIndicator:YES];
                                               
                                               _wasCreateProfielNotified = NO;                                      //Ws create profile has not notifying yet
                                               _wasChangePasswordNotified = NO;                                     //Ws change password has not notifying yet
                                               
                                               if(!_wasChangePasswordSuccessfully)[self requestChangePassword];     //In case of not been changed the password successfully, call ws
                                               if(!_wasCreateProfielSuccessfully){                                   //In case of not been created the profile successfully, call ws
                                                   if(_isCreationModeOn){
                                                       [self requestCreateStoreProfile];
                                                   }else{
                                                       [self requestUpdateStoreProfile];
                                                   }
                                               }
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


-(void) showAlertControllerWithTitle:(NSString*) title message:(NSString*) message{
    
    [self showActivitiIndicator:NO];
    
    UIAlertAction *destroyAction;
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title
                                                           message:message
                                                    preferredStyle:UIAlertControllerStyleAlert];
    
    destroyAction = [UIAlertAction actionWithTitle:@"Aceptar"
                                           style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction *action) {
                                             [alertController dismissViewControllerAnimated:YES completion:nil];
                                             [self showAlertControllerUsingNSError];
                                         }];
    
    [alertController addAction:destroyAction];
    [alertController setModalPresentationStyle:UIModalPresentationCurrentContext];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void) showAlertControllerUsingNSError{                                                                               // Alert controller that coordinate the
    
    [self showActivitiIndicator:NO];
    
    if(_wasCreateProfielNotified && _wasChangePasswordNotified ){                                                      // If both ws has notified or successful created, and
                                                                                                                       // exist 'errors' objects notified
                                                                                                                       // shows all errors in the NSMutableArray Errors
        if([_errors count] > 0){
            
            [self showActivitiIndicator:NO];
            
            NSError *error = [_errors lastObject];
            UIAlertAction *destroyAction;
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:error.domain
                                                                                      message:error.localizedDescription
                                                                               preferredStyle:UIAlertControllerStyleAlert];
            
            destroyAction = [UIAlertAction actionWithTitle:@"Aceptar"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       [alertController dismissViewControllerAnimated:YES completion:nil];
                                                       
                                                       [_errors removeLastObject];                                      // Remove one by one errors
                                                       [self showAlertControllerUsingNSError];                          // Show one by one errors, every time press Accept
                                                   }];
            
            [alertController addAction:destroyAction];
            [alertController setModalPresentationStyle:UIModalPresentationCurrentContext];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
      }if(_wasCreateProfielSuccessfully && _wasChangePasswordSuccessfully){                                      // If not exist 'errors' stored ,
                                                                                                                 // and creatinonProfile and changePassword proccess was successful
          [self performSegueWithIdentifier:kSegueIdentifierPromotionList sender:self];
      }
}

/**
 *  Use to show an Alert Controller that call a method of specific WS product
 **/
-(void) showAlertControllerUsingWSProduct:(id)wsLoginConnection{
    UIAlertAction *destroyAction;
    UIAlertAction *otherAction;
    
    UIAlertController * alertController= [UIAlertController alertControllerWithTitle:@"Confirma que desea cerrar sessión?"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    destroyAction = [UIAlertAction actionWithTitle:@"Si"
                                             style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action) {
                                               [wsLoginConnection executeLogout];
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

#pragma mark - UI component's actions

- (IBAction)saveEditProfileAction:(id)sender {
    
    if([[_nameTextField text] isEqualToString:@""] || [[_labelValueVenue text]isEqualToString:@""]
       || [[_emailTextField text] isEqualToString:@""]){
        
        [self showAlertControllerWithTitle:@"Campos obligatorios"
                                   message:@"Diligencie los campos de la información de la tienda"];
        
    }else if([[_textFieldCurrentPassword text] isEqual: @""] || [[_textFieldNewPassword text] isEqual: @""]
             || [[_textFieldConfirmNewPassword text] isEqual: @""]){
        
        [self showAlertControllerWithTitle:@"Campos obligatorios"
                                   message:@"Si desea cambiar la contraseña, diligencie todos los campos"];
        
    }else{
        [self showAlertControllerConfirmRequest];
    }
}

- (IBAction)logoutAction:(id)sender {
        id wsLoginConnector =  [WebServiceAbstractFactory createWebServiceLoginConnection:ApacheType];
    [self showAlertControllerUsingWSProduct: wsLoginConnector];
}

#pragma mark - Call Web Services

-(void) requestCreateStoreProfile{
    id wsProfileConnector = [WebServiceAbstractFactory createWebServiceProfileConnection:ApacheType];
    
    [_store setValue:[_nameTextField text] forKey:@"name"];
    [_store setValue:[_labelValueVenue text] forKey:@"number"];
    [_store setValue:[_emailTextField text] forKey:@"email"];
    
    [wsProfileConnector createProfileWithStoreInfo:_store];
}

-(void) requestUpdateStoreProfile{
    id wsProfileConnector = [WebServiceAbstractFactory createWebServiceProfileConnection:ApacheType];
    NSLog(@"storeId : %i", [[_store storeId] intValue]);

    /**Save on property store of self**/
    [_store setValue:[_nameTextField text] forKey:@"name"];
    [_store setValue:[_labelValueVenue text] forKey:@"number"];
    [_store setValue:[_emailTextField text] forKey:@"email"];
    
    //Update ws routine
    [wsProfileConnector updateProfileWithStoreInfo:_store];
}

-(void) requestChangePassword{
    id _wsLoginConnection = [WebServiceAbstractFactory createWebServiceLoginConnection:ApacheType];
    
    UserMO *userMO = [[UserMO alloc]init];
    [userMO setUsername:[[NSUserDefaults standardUserDefaults] valueForKey:[Constants GET_LABEL_USER_NAME]]];
    [userMO setPassword:([[_textFieldCurrentPassword text] isEqual: @""])?nil:[_textFieldCurrentPassword text]];
    [userMO setTheNewPassword:([[_textFieldNewPassword text] isEqual: @""])?nil:[_textFieldNewPassword text]];
    
    [_wsLoginConnection changePassword:userMO];
}

-(void) requestRefreshToken{
    
    id _wsLoginConnection = [WebServiceAbstractFactory createWebServiceLoginConnection:ApacheType];
    [_wsLoginConnection refreshTokenWithRefreshToken:[[NSUserDefaults standardUserDefaults] valueForKey:[Constants GET_GRANT_TYPE_REFRESH_TOKEN]]];
    
}


#pragma mark - Spping waiter
-(void) initActivityIndicator{
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_activityIndicator setFrame:self.view.frame];
    
    [_activityIndicator.layer setBackgroundColor:[[UIColor colorWithWhite: 0.0 alpha:0.3] CGColor]];
    CGPoint center = self.view.center;
    _activityIndicator.center = center;
    [self.view addSubview:_activityIndicator];
}

-(void) showActivitiIndicator:(Boolean) shouldShowed
{
    if(shouldShowed){
        [_activityIndicator startAnimating];
        [self.view setUserInteractionEnabled:NO];
    }else{
        [_activityIndicator stopAnimating];
        [self.view setUserInteractionEnabled:YES];
    }
}

#pragma mark - Segues
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:kSegueIdentifierInMap]){
        
        ViewControllerSelectVenue *controller =[segue destinationViewController];
        [controller setDelegate:self];
        CGPoint point = [[_dictionaryStorePoint objectForKey:_venueSelected] CGPointValue];;
        [controller setPoint:point];
        
    }else if([[segue identifier] isEqualToString:kSegueIdentifierPromotionList]){
        
        NSLog(@"Go to Create Promotion List Segue");
        ViewControllerPromotionList *viewController = [segue destinationViewController];
        [viewController setManagedObjectContext:self.managedObjectContext];
        
    }
}

@end