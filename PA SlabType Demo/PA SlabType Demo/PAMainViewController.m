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
@synthesize slab, textInput;
@synthesize charCountSlider, boxWidthSlider;

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

    if(!slab){
    slab = [[PASlabText alloc] initWithFrame:CGRectMake(10.0, 10.0, 300, 400)];
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
//    [string setString:[@"Leadership has nothing to do with a person's title, but it has everything to do with a person's example" capitalizedString]];
    [string setString:@"Leadership has nothing to do w\nsomethingorother"];
    [string setString:@"THIS COULD BE THE\nGOLDEN\nTICKET THAT GETS US TO WONKA"];

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
