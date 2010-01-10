//
//  ShortenAppDelegate.m
//  Shorten
//
//  Created by Karl Hammar on 2010-01-05.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ShortenAppDelegate.h"
#import "MainViewController.h"

@implementation ShortenAppDelegate


@synthesize window;
@synthesize mainViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
	MainViewController *aController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = aController;
	[aController release];
	
    mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	
	[mainViewController restoreState];
	
	[window addSubview:[mainViewController view]];
    [window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[mainViewController saveState];
}


- (void)dealloc {
    [mainViewController release];
    [window release];
    [super dealloc];
}

@end
