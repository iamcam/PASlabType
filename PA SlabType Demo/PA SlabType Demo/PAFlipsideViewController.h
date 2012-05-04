//
//  PAFlipsideViewController.h
//  PA SlabType Demo
//
//  Created by Cameron Perry on 5/3/12.
//  Copyright (c) 2012 Pivotal Action, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PAFlipsideViewController;

@protocol PAFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(PAFlipsideViewController *)controller;
@end

@interface PAFlipsideViewController : UIViewController

@property (weak, nonatomic) IBOutlet id <PAFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
