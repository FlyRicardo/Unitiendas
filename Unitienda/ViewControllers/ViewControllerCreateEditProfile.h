//
//  ViewControllerCreateProfile.h
//  Unitienda
//
//  Created by Fly on 4/12/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectVenueDelegate.h"

@interface ViewControllerCreateProfile : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate,SelectVenueDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end