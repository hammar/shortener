//
//  MainViewController.h
//  Shorten
//
//  Created by Karl Hammar on 2010-01-05.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "AboutViewController.h"
#import "SettingsViewController.h"

@interface MainViewController : UIViewController <AboutViewControllerDelegate,SettingsViewControllerDelegate> {
	IBOutlet UITextField* shortenedURL;
	IBOutlet UITextField* urlToShorten;
	IBOutlet UISegmentedControl* shortenerChooser;
	IBOutlet UIButton* shortenerButton;
	IBOutlet UIActivityIndicatorView* shortenerSpinner;
	
	NSMutableData *receivedData;
	
	Boolean hasUrlBeenCopied;
}

- (IBAction)showSettings;
- (IBAction)showInfo;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)doShortening:(id)sender;
- (IBAction)pasteFromPasteBoard:(id)sender;
- (IBAction)copyToPasteBoard:(id)sender;

- (void)saveState;
- (void)restoreState;
- (void)resetShorteningButton;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

- (BOOL)doesStringContainSubstring:(NSString *)firstString :(NSString *)secondString;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
