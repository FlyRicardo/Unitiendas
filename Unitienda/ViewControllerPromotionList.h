//
//  ViewControllerPromotionList.h
//  Unitienda
//
//  Created by Fly on 5/7/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerPromotionList : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *promotions;

@end