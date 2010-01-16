//
//  SettingsViewController.h
//  Shortener
//
//  Created by Karl Hammar on 2010-01-16.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@protocol SettingsViewControllerDelegate;

@interface SettingsViewController : UIViewController {
	id <SettingsViewControllerDelegate> delegate;
}

@property (nonatomic, assign) id <SettingsViewControllerDelegate> delegate;
- (IBAction)done;

@end


@protocol SettingsViewControllerDelegate
- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller;
@end
