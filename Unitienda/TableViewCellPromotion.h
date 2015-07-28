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

@property (weak, nonatomic) IBOutlet UIImageView *rowArticleImageView;
@property (weak, nonatomic) IBOutlet UILabel *rowArticleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowPercentageEffectivenessLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowDueDateLabel;

/************************************************************
 ** UTILITIES ELEMENTS
 ***********************************************************/
-(void) setArticle:(Article *)article;

@end
