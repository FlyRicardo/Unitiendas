//
//  TableViewCellPromotion.h
//  Unitienda
//
//  Created by Fly on 6/18/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "Promotion.h"

@interface TableViewCellPromotion : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *rowPromotionImageView;
@property (weak, nonatomic) IBOutlet UILabel *rowPromotionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowPercentageEffectivenessLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowDueDateLabel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

/************************************************************
 ** UTILITIES ELEMENTS
 ***********************************************************/
-(void) setPromotion:(Promotion*) promotion AndManagedObjectContext:(NSManagedObjectContext*) managedObjectContext;

@end
