//
//  MainViewController.h
//  Shorten
//
//  Created by Karl Hammar on 2010-01-05.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
	IBOutlet UITextField* shortenedURL;
	IBOutlet UITextField* urlToShorten;
	IBOutlet UISegmentedControl* shortenerChooser;
	IBOutlet UIActivityIndicatorView* shortenerSpinner;
	IBOutlet UIButton* shortenerButton;
}

- (IBAction)showInfo;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)doShortening:(id)sender;

@end
