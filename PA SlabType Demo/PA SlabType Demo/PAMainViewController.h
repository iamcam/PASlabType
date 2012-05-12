//
//  PAMainViewController.h
//  PA SlabType Demo
//
//  Created by Cameron Perry on 5/3/12.
//  Copyright (c) 2012 Pivotal Action, Inc. All rights reserved.
//

#import "PAFlipsideViewController.h"
#import "PASlabText.h"

@interface PAMainViewController : UIViewController <PAFlipsideViewControllerDelegate, UIPopoverControllerDelegate, UITextViewDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;
@property (nonatomic, retain) PASlabText *slab;
@property (nonatomic, retain) IBOutlet UITextView *textInput;
@property (nonatomic, retain) IBOutlet UISlider *charCountSlider;
@property (nonatomic, retain) IBOutlet UISlider *boxWidthSlider;

-(IBAction)sliderDidUpdateWithValue: (id) sender;
-(IBAction)boxSliderUpdated: (id) sender;

@end
