//
//  ShortenAppDelegate.h
//  Shorten
//
//  Created by Karl Hammar on 2010-01-05.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

@class MainViewController;

@interface ShortenAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;

@end

