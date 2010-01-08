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
	IBOutlet UIButton* shortenerButton;
	
	NSMutableData *receivedData;
	
	Boolean hasUrlBeenCopied;
}

- (IBAction)showInfo;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)doShortening:(id)sender;
- (IBAction)pasteFromPasteBoard:(id)sender;
- (IBAction)copyToPasteBoard:(id)sender;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
