//
//  ViewControllerCreateEditPromotion.h
//  Unitienda
//
//  Created by Fly on 8/10/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerCreateEditPromotion : UITableViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;

@property (weak, nonatomic) IBOutlet UITextField *startDateFieldText;
@property (weak, nonatomic) IBOutlet UITextField *endDateFieldText;

@property (weak, nonatomic) IBOutlet UILabel *itemNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *percentageDiscountTextField;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) BOOL isCreationModeOn;

@property (nonatomic) NSNumber* promotionId;

@end
