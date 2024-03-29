//
//  MainViewController.m
//  Shorten
//
//  Created by Karl Hammar on 2010-01-05.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		hasUrlBeenCopied = false;
    }
    return self;
}

 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
	 [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
 }
 


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


- (void)aboutViewControllerDidFinish:(AboutViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo {    
	
	AboutViewController *controller = [[AboutViewController alloc] initWithNibName:@"AboutView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}


- (IBAction)showSettings {    
	
	SettingsViewController *controller = [[SettingsViewController alloc] initWithNibName:@"SettingsView" bundle:nil];
	
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

// Convenience method to check if one string contains another string
- (BOOL)doesStringContainSubstring:(NSString *)firstString :(NSString *)secondString {
	NSRange range = [firstString rangeOfString:secondString options:NSCaseInsensitiveSearch];
	if (range.location != NSNotFound) {
		return TRUE;
	}
	else {
		return FALSE;
	}

}

- (IBAction)doShortening:(id)sender{
	// Trim incoming URL (to avoid the corner case of generating a valid zero length url)
	NSString *longURL = [[urlToShorten text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

	// Escape non valid characters in URL
	NSString * encodedUrlString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																					  NULL,
																					  (CFStringRef)longURL,
																					  NULL,
																					  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																					  kCFStringEncodingUTF8 );

	
	// Check that escaped and trimmed URL string is greater than zero length
	if ([encodedUrlString length]<=0)
	{
		// If not - URL was malformed - abort shortening
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"A malformed URL was entered. Please check your spelling." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	
	// Check that long URL is not already shortened using one of the services.
	NSURL *longUrlAsUrl = [NSURL URLWithString:longURL];
	NSString *longUrlHost = [longUrlAsUrl host];
	if ([self doesStringContainSubstring:longUrlHost:@"is.gd"] || [self doesStringContainSubstring:longUrlHost:@"tinyurl.com"] || [self doesStringContainSubstring:longUrlHost:@"tr.im"])
	{
		// Long URL has already been shortened. Abort.
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The URL you have entered has already been shortened and cannot be shortened further." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
		
	
	// Start the progress indicator spinner
	[shortenerButton setTitle:@"" forState:UIControlStateNormal];
	[shortenerButton setTitle:@"" forState:UIControlStateHighlighted];
	[shortenerButton setTitle:@"" forState:UIControlStateSelected];
	[shortenerSpinner startAnimating];
	
	// Generate shortening service query URL based on selected shortening service
	NSInteger index = shortenerChooser.selectedSegmentIndex;
	NSString *queryBase = nil;
	switch(index) {
		case(0): queryBase=@"http://tinyurl.com/api-create.php?url="; break;
		case(1): queryBase=@"http://is.gd/api.php?longurl="; break;
		case(2): queryBase=@"http://api.tr.im/v1/trim_simple?url="; break;
	}
	NSString *queryUrlAsString = [queryBase stringByAppendingString:encodedUrlString];
    NSURL *queryUrl = [NSURL URLWithString: queryUrlAsString];

	// Check that generated query URL is not malformed
	if (queryUrl == nil)
	{
		// URL was malformed - abort shortening
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"A malformed URL was entered. Please check your spelling." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
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
			
			NSError *statusError
			= [NSError errorWithDomain:NSURLErrorDomain
								  code:statusCode
							  userInfo:nil];
			
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
	NSString *errorMessage;
	NSInteger errorCode = [error code];
	if (errorCode >= 500)
	{
		errorMessage = [NSString stringWithFormat:@"The shortening service returned status code %d indicating a server side error.",errorCode];
	}
	else {
		errorMessage = [NSString stringWithFormat:@"The shortening service returned status code %d indicating a client side error.",errorCode];
	}
	
	// Display error message
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	// Reset shortening button (hiding spinner)
	[self resetShorteningButton];
}

- (void)resetShorteningButton {
	[shortenerSpinner stopAnimating];
	[shortenerButton setTitle:@"Shorten" forState:UIControlStateNormal];
	[shortenerButton setTitle:@"Shorten" forState:UIControlStateHighlighted];
	[shortenerButton setTitle:@"Shorten" forState:UIControlStateSelected];
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
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No URL was returned from shortening service. This may indicate a server side error, or an incorrectly entered URL. Please check your spelling and if this does not help, try another shortening service." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
    // release the connection, data object and string interpretation of data object
    [connection release];
    [receivedData release];
	[receivedDataAsString release];
	
	// Reset shortening button (hiding spinner)
	[self resetShorteningButton];
}

@end
