//
//  UIViewConroller+PCLExtensions.h
//  PublicCodeLibrary
//
//  Created by Stefan Herold on 13.12.2012.
//  Copyright © 2015 Stefan Herold. All rights reserved.
//

#import "UIViewConroller+PCLExtensions.h"

@implementation UIViewController (PCLExtensions)

#pragma mark - Enabling and Disabling Controls

- (void)pcl_setControlsEnabled:(BOOL)shouldEnable {
	
	[self.navigationItem setHidesBackButton:!shouldEnable animated:YES];
	
	NSArray * const toolbarItems = self.toolbarItems;
    
    // iOS 5 Compatibility Checks
    if( [self.navigationItem respondsToSelector:@selector(leftBarButtonItems)] ) {
        NSArray * leftBarButtonItems = self.navigationItem.leftBarButtonItems;

		for (UIBarButtonItem * item in leftBarButtonItems) {
			[item setEnabled:shouldEnable];
		}
    }

    // iOS 5 Compatibility Checks
    if( [self.navigationItem respondsToSelector:@selector(rightBarButtonItems)] ) {
        NSArray * rightBarButtonItems = self.navigationItem.rightBarButtonItems;

		for (UIBarButtonItem * item in rightBarButtonItems) {
			[item setEnabled:shouldEnable];
		}
    }

	// Toolbar buttons
	for (UIBarButtonItem * item in toolbarItems) {
		[item setEnabled:shouldEnable];
	}
    
	[self.navigationItem.leftBarButtonItem setEnabled:shouldEnable];
    [self.navigationItem.rightBarButtonItem setEnabled:shouldEnable];
}

@end
