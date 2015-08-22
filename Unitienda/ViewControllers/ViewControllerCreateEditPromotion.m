//
//  ViewControllerCreateEditPromotion.m
//  Unitienda
//
//  Created by Fly on 8/10/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "ViewControllerCreateEditPromotion.h"

#import "Constants.h"
#import "RefreshTokenMetaMO.h"

#import "WebServiceAbstractFactory.h"

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
#define kNumberOfRowsInSection 11

#define kLabelCellHeight 20
#define kFieldTextCellHeight 40

#define kDatePickerCellHeight 162

@interface ViewControllerCreateEditPromotion ()

@property (nonatomic) Boolean startDatePickerIsShowing;
@property (nonatomic) Boolean endDatePickerIsShowing;

@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;

@property (weak, nonatomic) IBOutlet UITextField *startDateFieldText;
@property (weak, nonatomic) IBOutlet UITextField *endDateFieldText;

@property (weak, nonatomic) IBOutlet UITextField *itemNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *percentageDiscountTextField;

@property (strong, nonatomic) UITextField *activeTextField;

@end

@implementation ViewControllerCreateEditPromotion

- (void)viewDidLoad {
    [super viewDidLoad];
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
    /****/
    int offset = 0.f;
    int offsetRigth = 0.f;
    self.tableView.contentInset = UIEdgeInsetsMake(offset, offsetRigth, 0, 0);
    
    [self hideStartDatePickerCell];
    [self hideEndDatePickerCell];
    
    /**Configure toolbar**/
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(hideKeyboard)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [[self percentageDiscountTextField] setInputAccessoryView:toolBar];
    [[self itemNameTextField] setInputAccessoryView:toolBar];
    
    /**Configure navigation bar**/
    [self configureNavigationBar];
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
    
    [navigationItem setTitle: ([self isCreationModeOn])?@"Creat promoción":@"Editar Promoción"];
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
}

-(void) unregisterNotifyProcess{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:[Constants GET_LABEL_NAME_REFRESH_TOKEN_RESPONSE_NOTIFICATOIN]
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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
