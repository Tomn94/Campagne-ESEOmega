//
//  HomeVC.h
//  ESEOmega
//
//  Created by Tomn on 10/03/2015.
//  Copyright (c) 2015 Thomas Naudet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define URL_VIDEO @"http://176.32.230.7/eseomega.com/video.txt"

@interface HomeVC : UIViewController <UIWebViewDelegate>

- (void) playerStarted;
- (void) playerEnded;

@end
