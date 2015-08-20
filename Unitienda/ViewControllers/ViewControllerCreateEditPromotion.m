//
//  ViewControllerCreateEditPromotion.m
//  Unitienda
//
//  Created by Fly on 8/10/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "ViewControllerCreateEditPromotion.h"

#define kStartDateLabelIndex 4
#define kEndDateLabelIndex 6

#define kStartDatePickerViewIndex 5
#define kEndDatePickerViewIndex 7

#define kNumberOfSections 1
#define kNumberOfRowsInSection 8

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
    
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(hideKeyboard)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [[self itemNameTextField] setInputAccessoryView:toolBar];
    [[self percentageDiscountTextField] setInputAccessoryView:toolBar];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return kNumberOfRowsInSection;
}

#pragma mark - Listener identifier TableView Selected
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == kStartDateLabelIndex){
        if([self startDatePickerIsShowing]){
            [self hideStartDatePickerCell];
        }else{
            [self showStartDatePickerCell];
        }
    }else if(indexPath.row == kEndDateLabelIndex){
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
