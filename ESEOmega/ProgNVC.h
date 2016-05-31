//
//  ProgNVC.h
//  ESEOmega
//
//  Created by Tomn on 18/03/2015.
//  Copyright (c) 2015 Thomas Naudet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ProgNVC : UIViewController <UIWebViewDelegate>
{
    UIWebView *wv;
    UISegmentedControl *seg;
    NSString *urlVideo;
}

- (void) changeTab;
- (void) playerStarted;
- (void) playerEnded;

@end
