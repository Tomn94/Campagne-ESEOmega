//
//  AppDelegate.h
//  ESEOmega
//
//  Created by Tomn on 25/01/2015.
//  Copyright (c) 2015 Thomas Naudet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRVC.h"
#import "HomeVC.h"
#import "TeamTVC.h"
#import "ProgNVC.h"
#import "AnimTVC.h"
#import "TresorVC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>
{
    UITabBarController *mainVC;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) BOOL videoIsInFullscreen;

@end

