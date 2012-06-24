//
//  PAMainViewController.m
//  PA SlabType Demo
//
//  Created by Cameron Perry on 5/3/12.
//  Copyright (c) 2012 Pivotal Action, Inc. All rights reserved.
//

#import "PAMainViewController.h"

@implementation PAMainViewController

@synthesize flipsidePopoverController = _flipsidePopoverController;
@synthesize slab, textInput, boundsView;
@synthesize charCountSlider, boxWidthSlider;
@synthesize eastHandle, eastHandlePan, boxPan;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // TODO: We can hide the text field here.
    [textInput setHidden:YES];
    [textInput setAutocorrectionType:UITextAutocorrectionTypeNo];

    if(!slab){
        slab = [[PASlabText alloc] initWithFrame:CGRectMake(10.0, 10.0, 110, 230)];
        [slab setDelegate:self];
        [slab selectFontWithName:@"ChunkFive"];
        [slab selectFontWithName:@"League Gothic"];
        //    slab = [[PASlabText alloc] initWithFrame:CGRectMake(10.0, 10.0, 150, 210)];
        //        slab = [[PASlabText alloc] initWithFrame:CGRectMake(10, 10,152.0 , 232.0f)];
    }
    NSMutableString *string = [NSMutableString string];
    //    [string setString:@"Happy Mothers Day! That's right, I care abou nmy mom so much I start Tweeting to her early."];
//       [string setString:@"\"Narnia, Narnia, Narnia, awake. Love. Think. Speak. Be walking trees. Be talking beasts. Be divine waters.\""];
//    [string setString:@"I'M STARTING TO\nPREFER SKIPPING\nMOVIES IN THE THEATER\nJUST SO I HAVE"];
    //    [string setString:@"Dogs in the office"];
    //    [string setString:@" I might push towards poke for dinner tonight"];
    //    [string setString:@"Another day, another iOS surprise"];
    //    [string setString:@"Stop Selling & Start Telling"];
    [string setString:[@"Leadership has nothing to do with a person's title, but it has everything to do with a person's example" capitalizedString]];
//    [string setString:@"Leadership has nothing to do w\nsomethingorother"];
//    [string setString:@"THIS COULD BE THE\nGOLDEN\nTICKET THAT GETS US TO WONKA"];

    //    [string setString:@"Passion leads"];
    //    [string setString:@"\"Debt robs you of your options.\""];
    //    [string setString:@"Violence might be verbal violence the cos put on the women"];
    //    [string setString:@"I WISH IT WAS THAT SIMPLE\nTHAT I COULD ERASE MY PAST"];
//        [string setString:@"Debt robs you of your options."];
    
//    [string setString:@""];
    
    [slab splitTextInString:string];
    [textInput setText:[slab sentence]];
    [self.view addSubview:slab];
    [self.view sendSubviewToBack:slab];
    
    
    CGRect frame = slab.frame;
    self.boundsView = [[UIView alloc] initWithFrame:frame];
    [self.boundsView setBackgroundColor:[UIColor colorWithRed:0.0 green:255.0 blue:255.0 alpha:0.3]];
    [self.view addSubview:boundsView];
    
    self.eastHandle = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x + frame.size.width, frame.origin.y + frame.size.width, 25.0, 25.0)];
    self.eastHandle.center = CGPointMake(frame.origin.x + frame.size.width, frame.origin.y + frame.size.width);
    [self.eastHandle setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:self.eastHandle];
    
    self.eastHandlePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(boxGrow:)];
    [self.eastHandlePan setDelegate:self];
    self.boxPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveBoxText:)];
    [self.boxPan setDelegate:self];
    
    [self.eastHandle addGestureRecognizer:self.eastHandlePan];
    [self.boundsView addGestureRecognizer:self.boxPan];

    // Bring the slab view to the front and tell it to not pay attention to user touches
    [self.view bringSubviewToFront:self.slab];
    [slab setUserInteractionEnabled:NO];
}

-(void)moveBoxText:(UIPanGestureRecognizer *)recognizer {

    CGPoint translation = [recognizer translationInView:recognizer.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    
    self.eastHandle.center = CGPointMake(recognizer.view.frame.origin.x + recognizer.view.frame.size.width,
                                         recognizer.view.frame.origin.y + recognizer.view.frame.size.height);
    
    self.slab.frame = CGRectMake(recognizer.view.frame.origin.x, recognizer.view.frame.origin.y, self.slab.frame.size.width, self.slab.frame.size.height);
    
    [recognizer setTranslation:CGPointMake(0.0, 0.0) inView:self.view];
}


-(void)boxGrow:(UIPanGestureRecognizer *)recognizer{
//    NSLog(@"Growing");
    float aspect, x, y;
    
    y = self.boundsView.frame.size.height;
    x = self.boundsView.frame.size.width;
    aspect = y / x;
    NSLog(@"%.1f / %.1f / %.4f", x, y, aspect);

    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, 
                                         recognizer.view.center.y + aspect * translation.x);
    
    self.boundsView.frame = CGRectMake(self.boundsView.frame.origin.x,
                                       self.boundsView.frame.origin.y, 
                                       self.boundsView.frame.size.width + translation.x,
                                       self.boundsView.frame.size.height + aspect * translation.x);

    
    y = self.boundsView.frame.origin.y + self.boundsView.frame.size.height;
    float newHeight = self.slab.frame.size.height;
    NSLog(@"nh: %.2f",newHeight);

    if( y != 240.0 ){
        newHeight = 240.0 - self.slab.frame.origin.y;
    }
    self.slab.frame = CGRectMake(self.boundsView.frame.origin.x, 
                                 self.boundsView.frame.origin.y, 
                                 self.boundsView.frame.size.width, 
                                 newHeight);
    
    [self.slab setNeedsDisplay];

    [recognizer setTranslation:CGPointMake(0.0, 0.0) inView:self.view];


}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touches: %@ / %@", touches, event);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [textInput becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - input delegates

- (void)textViewDidChange:(UITextView *)textView {
    [slab clearText];
    [slab splitTextInString: [textView text]];
    [slab setNeedsDisplay];
}

-(IBAction)sliderDidUpdateWithValue: (id) sender{
    UISlider *slider = (UISlider *)sender;
    int v = round(slider.value);
    // Only send non-redundant updates
    if( v != [slab manualCharCountPerLine]){
        NSLog(@"Slider Val: %d", v);
        [slab setManualCharCountPerLine:v];
        [slab clearText];
        [slab splitTextInString: [textInput text]];
        [slab setNeedsDisplay];
    }
}

-(IBAction)boxSliderUpdated: (id) sender{
    UISlider *slider = (UISlider *)sender;
    float w = round(slider.value);
    if(w != slab.frame.size.width){
        CGRect newFrame = CGRectMake(slab.frame.origin.x, slab.frame.origin.y, w, slab.frame.size.height);
        [slab setFrame:newFrame];
        [slab clearText];
        [slab splitTextInString: [textInput text]];
        [slab setNeedsDisplay];
    }
}

// This is the visible text height
-(void)textBoundsDidChangeWithFrame:(CGRect)frame{
    NSLog(@"Changed View Size, {%.1f,%.1f}, {%.1fw x %.1fh}", frame.origin.x, frame.origin.y,frame.size.width, frame.size.height);
    self.boundsView.frame = frame;

    CGPoint handleCenter = CGPointMake(frame.origin.x + frame.size.width, 
                                       frame.origin.y + frame.size.height);
    self.eastHandle.center = handleCenter;
    
    
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(PAFlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

@end
