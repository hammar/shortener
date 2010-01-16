//
//  FlipsideViewController.h
//  Shorten
//
//  Created by Karl Hammar on 2010-01-05.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

@protocol AboutViewControllerDelegate;


@interface AboutViewController : UIViewController {
	id <AboutViewControllerDelegate> delegate;
}

@property (nonatomic, assign) id <AboutViewControllerDelegate> delegate;
- (IBAction)done;

@end


@protocol AboutViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(AboutViewController *)controller;
@end

