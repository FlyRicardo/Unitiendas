//
//  TableViewCellPromotion.m
//  Unitienda
//
//  Created by Fly on 6/18/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "TableViewCellPromotion.h"
#import "Article.h"
#import "Photo.h"
#import "Promotion.h"
#import "CacheManager.h"
#import "ReachabilityImpl.h"
#import "ImageHandler.h"

@interface TableViewCellPromotion()

@property (weak, nonatomic) IBOutlet UIView *contentViewMain;

@end

@implementation TableViewCellPromotion

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

//-(void) layoutSubviews{
//    [super layoutSubviews];
//    self.contentViewMain.frame = CGRectMake(-10.0f, 0, self.contentViewMain.frame.size.width, self.contentViewMain.frame.size.height);
//}

-(void) setCacheImage:(NSSet*)photos{
    __block Photo* photo;
    [photos enumerateObjectsUsingBlock:^(id obj, BOOL *stop) { // This block is the advised way to iterate over a Set (structure that doesn't has iterators)
        photo = (Photo*)obj;
        if([[photo type] isEqualToString:@"PEQ"]){
            *stop = YES;
        }
    }];
    
    UIImage *cached_image = [[CacheManager sharedCacheController] getCachedImage:[NSString stringWithFormat:@"image-%@",[photo url]]];
    
    if(cached_image != nil){
        [_rowArticleImageView setImage:cached_image];
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            UIImage *image;
            NSString* extension =[[ImageHandler getInstance] getExtensionFromURL:[photo url]];
            NSString* fileName =[[ImageHandler getInstance] getImageNameFromURL:[photo url]];

            if(![[ReachabilityImpl getInstance] hostIsReachable2]){
                image = [[ImageHandler getInstance] loadImage:fileName ofType:extension];
            }else{
                NSURL * imageURL = [NSURL URLWithString:photo.url];
                NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
                
                if([[ImageHandler getInstance] loadImage:fileName ofType:extension] == nil){
                    //If the image doesnt exist locally, save it from ws
                    [[ImageHandler getInstance] saveImageLocallyWithFileName:fileName ofType:extension AndURL:[photo url]];
                }
                image = [UIImage imageWithData:imageData];
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                [_rowArticleImageView setImage: image];
                [[CacheManager sharedCacheController] setCachedImage:image name:[NSString stringWithFormat:@"image-%@", [photo url]]];
            });
        });
    }
}

-(void) setPromotionParameter:(Promotion *)promotion articlePhotos:(NSSet*) photos{
    [self setCacheImage:photos];
}

-(void) setArticle:(Article *)article{
    [[self rowArticleNameLabel] setText:[article name]];
    [self setCacheImage:[article photo]];
}

-(void) setPromotion:(Promotion *)promotion{
    [[self rowPercentageEffectivenessLabel] setText:[NSString stringWithFormat:@"%d%% de efectividad",[[promotion effectiveness] intValue]]];

    int daysFromDate = [self daysFromDate:[promotion dueDate]];
    if(daysFromDate >=0){                                                                                                               //If promotion is still valid
        [[self rowDueDateLabel] setText:[NSString stringWithFormat:@"%d día(s) de vigencia",[self daysFromDate:[promotion dueDate]]]];
    }else{
        [[self rowDueDateLabel] setText:@"La promoción ha expirado"];
    }
    [self setArticle:[promotion article]];
}

-(NSString*) customFormatDate:(NSDate*) date{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormat stringFromDate:date];
}

/**
 * Returns number of days (absolute value) from another date (as number of midnights beween these dates)
 **/
- (int)daysFromDate:(NSDate *)pDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate* currentDate = [NSDate date];
    NSInteger startDay=[calendar ordinalityOfUnit:NSCalendarUnitDay
                                           inUnit:NSCalendarUnitEra
                                          forDate:currentDate];
    NSInteger endDay=[calendar ordinalityOfUnit:NSCalendarUnitDay
                                         inUnit:NSCalendarUnitEra
                                        forDate:pDate];
    return endDay-startDay;
}
@end
