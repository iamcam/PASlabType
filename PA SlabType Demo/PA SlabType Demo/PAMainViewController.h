//
//  PAMainViewController.h
//  PA SlabType Demo
//
//  Created by Cameron Perry on 5/3/12.
//  Copyright (c) 2012 Pivotal Action, Inc. All rights reserved.
//

#import "PAFlipsideViewController.h"
#import "PASlabText.h"

@interface PAMainViewController : UIViewController <PAFlipsideViewControllerDelegate, UIPopoverControllerDelegate, UITextViewDelegate, PASlabTextDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;
@property (nonatomic, retain) PASlabText *slab;
@property (nonatomic, retain) IBOutlet UITextView *textInput;
@property (nonatomic, retain) IBOutlet UISlider *charCountSlider;
@property (nonatomic, retain) IBOutlet UISlider *boxWidthSlider;


@property (nonatomic, retain) UIView *boundsView;
@property (nonatomic, strong) UIView *eastHandle;
@property (nonatomic, strong) UIPanGestureRecognizer *eastHandlePan;
@property (nonatomic, strong) UIPanGestureRecognizer *boxPan;

-(IBAction)sliderDidUpdateWithValue: (id) sender;
-(IBAction)boxSliderUpdated: (id) sender;

-(void)boxPan:(UIPanGestureRecognizer *)recognizer;
-(void)boxGrow:(UIPanGestureRecognizer *)recognizer;


@end
