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
		hasUrlBeenCopied = false;
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

- (IBAction)hideKeyboard:(id)sender{
	[urlToShorten resignFirstResponder];
}

- (IBAction)pasteFromPasteBoard:(id)sender{
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	
	// Check if there are strings in pasteboard
	if ([pasteboard containsPasteboardTypes: [NSArray arrayWithObject:@"public.utf8-plain-text"]])
	{
		// If so, paste to url to shorten field
		[urlToShorten setText:[pasteboard string]];
	}
}

/* 
 This method gets the state of key aspects of the view controller that
 need to be stored for subsequent launches of the app.
 */
- (NSDictionary *)getState {
	NSArray *keys = [NSArray arrayWithObjects:@"urlToShorten", @"shortenedUrl", @"hasUrlBeenCopied", nil];
	NSArray *objects = [NSArray arrayWithObjects:[urlToShorten text], [shortenedURL text], hasUrlBeenCopied, nil];
	NSDictionary *stateDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	return stateDictionary;
}

/*
 This method reloads the state of the app based upon the state stored at
 previous app launches.
 */
- (void)setState:(NSDictionary *)stateDictionary {
	[urlToShorten setText:[stateDictionary objectForKey:@"urlToShorten"]];
	[shortenedURL setText:[stateDictionary objectForKey:@"shortenedUrl"]];
	if ([stateDictionary objectForKey:@"hasUrlBeenCopied"])
	{
		hasUrlBeenCopied = true;
		[shortenedURL setTextColor:[UIColor darkGrayColor]];
	}
}

// Method saves key variables for next launch.
- (void)saveState {
	[[NSUserDefaults standardUserDefaults] setObject:[urlToShorten text] forKey:@"urlToShorten"];
	[[NSUserDefaults standardUserDefaults] setObject:[shortenedURL text] forKey:@"shortenedURL"];
	[[NSUserDefaults standardUserDefaults] setBool:hasUrlBeenCopied forKey:@"hasUrlBeenCopied"];
}

// Method restores state from last time app was run.
- (void)restoreState {
	[urlToShorten setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"urlToShorten"]];
	[shortenedURL setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"shortenedURL"]];
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"hasUrlBeenCopied"])
	{
		hasUrlBeenCopied = true;
		[shortenedURL setTextColor:[UIColor darkGrayColor]];
	}
}

// Copies shortened URL to pasteboard.
- (IBAction)copyToPasteBoard:(id)sender {
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	if (!hasUrlBeenCopied)
	{
		// Copy to pasteboard
		pasteboard.string = [shortenedURL text];
		hasUrlBeenCopied = true;
		
		// Indicate successful copy in GUI
		[shortenedURL setText:@"Copied!"];
		shortenedURL.textColor = [UIColor darkGrayColor];
	}
}

// Catches touches to the view itself, i.e. background touches that hide the keyboard.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([urlToShorten isFirstResponder] && [touch view] != urlToShorten) {
        [urlToShorten resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)doShortening:(id)sender{
	// Trim incoming URL (to avoid the corner case of generating a valid zero length url)
	NSString *longURL = [[urlToShorten text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	// Check that longURL is greater than zero length and is not malformed
	NSURL *longUrlAsUrl = [NSURL URLWithString: longURL];
	if (longUrlAsUrl == nil || [longURL length]<=0)
	{
		// URL was malformed - abort shortening
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"URL entered was malformed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	NSInteger index = shortenerChooser.selectedSegmentIndex;
	
	NSString *queryBase = nil;
	switch(index) {
		case(0): queryBase=@"http://tinyurl.com/api-create.php?url="; break;
		case(1): queryBase=@"http://is.gd/api.php?longurl="; break;
		case(2): queryBase=@"http://api.tr.im/v1/trim_simple?url="; break;
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
	
	// Check so that the return code does not indicate an error
	if ([response respondsToSelector:@selector(statusCode)])
	{
		int statusCode = [((NSHTTPURLResponse *)response) statusCode];
		if (statusCode >= 400)
		{
			[connection cancel];  // stop connecting; no more delegate messages
			NSDictionary *errorInfo
			= [NSDictionary dictionaryWithObject:[NSString stringWithFormat:
												  NSLocalizedString(@"Server returned status code %d",@""),
												  statusCode]
										  forKey:NSLocalizedDescriptionKey];
			NSError *statusError
			= [NSError errorWithDomain:NSURLErrorDomain
								  code:statusCode
							  userInfo:errorInfo];
			[self connection:connection didFailWithError:statusError];
		}
	}
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
	
    // Construct error message
	NSString *errorMessage = [NSString stringWithFormat:@"Shortening failed! Error - %@ %@",
							  [error localizedDescription],
							  [[error userInfo] objectForKey:NSErrorFailingURLStringKey]];
	
	// Display error message
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Handle the data
	NSString *receivedDataAsString = [[NSString alloc] initWithData: receivedData  encoding: NSASCIIStringEncoding];
	
	// Trim the recieved string (as tr.im API returns a single whitespace if an error occurs)
	receivedDataAsString = [receivedDataAsString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	// If we have returned some value
	if (receivedDataAsString.length > 0)
	{
		// Set the shortened field
		[shortenedURL setText:receivedDataAsString];
		
		// Reset color of shortened URL field
		shortenedURL.textColor = [UIColor blackColor];
		
		// Reset URL has been copied variable
		hasUrlBeenCopied = false;
	}
	else {
		// Display error message if receieved data is of zero length after trimming.
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No URl returned from shortening service." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
    // release the connection, data object and string interpretation of data object
    [connection release];
    [receivedData release];
	[receivedDataAsString release];
}

@end
