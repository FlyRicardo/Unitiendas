//
//  ViewControllerSelectVenue.h
//  Unitienda
//
//  Created by Fly on 4/18/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVGKit.h"

#import "CALayerExporter.h"
#import "SVGKImage.h"
#import "SelectVenueDelegate.h"

#define LOAD_SYNCHRONOUSLY 0 // Synchronous load is less code, easier to write - but poor for large images

#define ALLOW_2X_STYLE_SCALING_OF_SVGS_AS_AN_EXAMPLE 1 // demonstrates using the "SVGKImage.scale" property to scale an SVG *before it generates output image data*

#define ALLOW_SVGKFASTIMAGEVIEW_TO_DO_HIT_TESTING 1 // only exists because people ignore the docs and try to do this when they clearly shouldn't. If you're foolish enough to do this, this code will show you how to do it CORRECTLY. Look how much code this requires! It's insane! Use SVGKLayeredImageView instead if you need hit-testing!

#define SHOW_DEBUG_INFO_ON_EACH_TAPPED_LAYER 1 // each time you tap and select a layer, that layer's info is displayed on-screen

@interface ViewControllerSelectVenue : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate , CALayerExporterDelegate, UIScrollViewDelegate>

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) UITextView* exportText;
@property (nonatomic, retain) NSMutableString* exportLog;
@property (nonatomic, retain) CALayerExporter* layerExporter;
@property (nonatomic, retain) UITapGestureRecognizer* tapGestureRecognizer;

@property (nonatomic, retain) id detailItem;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewForSVG;
//@property (weak, nonatomic) IBOutlet SVGKImageView *contentView;
@property (weak, nonatomic) IBOutlet SVGKFastImageView *contentView;

@property (weak, nonatomic) IBOutlet UIProgressView *proggresLoading;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *viewActivityIndicator;
@property (weak, nonatomic) IBOutlet UIView *subViewLoadingPopup;

@property (weak, nonatomic) id<SelectVenueDelegate>delegate;
@property (nonatomic) CGPoint point;

-(void) selectLayerWithPoint:(CGPoint)point;

@end