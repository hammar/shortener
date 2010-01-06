//
//  MainViewController.m
//  Shorten
//
//  Created by Karl Hammar on 2010-01-05.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"


@implementation MainViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

 /*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */
 


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}



/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (IBAction)textFieldDoneEditing:(id)sender{
	[sender resignFirstResponder];
}

- (IBAction)doShortening:(id)sender{
	NSString *longURL = [urlToShorten text];
	NSInteger index = shortenerChooser.selectedSegmentIndex;
	
	NSString *queryBase = nil;
	switch(index) {
		case(0): queryBase=@"http://tinyurl.com/api-create.php?url="; break;
		case(1): queryBase=@"http://is.gd/api.php?longurl="; break;
		case(2): queryBase=@"http://api.tr.im/api/trim_url.xml?url="; break;
	}
	
	NSString *queryUrlAsString = [queryBase stringByAppendingString:longURL];
    NSURL *queryUrl = [NSURL URLWithString: queryUrlAsString];
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:queryUrl 
												cachePolicy:NSURLRequestUseProtocolCachePolicy 
											timeoutInterval:10.0];
	
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) {
		// Create the NSMutableData that will hold
		// the received data
		// receivedData is declared as a method instance elsewhere
		receivedData=[[NSMutableData data] retain];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // this method is called when the server has determined that it
    // has enough information to create the NSURLResponse
	
    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is declared as a method instance elsewhere
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // append the new data to the receivedData
    // receivedData is declared as a method instance elsewhere
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
	
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Handle the data
	NSString *receivedDataAsString = [[NSString alloc] initWithData: receivedData  encoding: NSASCIIStringEncoding];
	
	// Check whether it's a tr.im style response
	NSRange trimTextRange;
	trimTextRange =[receivedDataAsString rangeOfString:@"<trim>"];
	if(trimTextRange.location != NSNotFound)
	{
		// TODO: This is a tr.im response, it needs to be parsed
	}
	else {
		// This is a straight up response, no funky business
		[shortenedURL setText:receivedDataAsString];
	}
	
    // release the connection, and the data object
    [connection release];
    [receivedData release];
}

@end
