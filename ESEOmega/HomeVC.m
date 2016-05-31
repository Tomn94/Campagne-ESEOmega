//
//  HomeVC.m
//  ESEOmega
//
//  Created by Thomas Naudet on 10/03/2015.
//  Copyright © 2015 Thomas Naudet

//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.

//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.

//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see http://www.gnu.org/licenses/
//

#import "HomeVC.h"

@implementation HomeVC

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    BOOL iPhone5 = [[UIScreen mainScreen] bounds].size.width == 320;
    [[self navigationItem] setTitle:[NSString stringWithFormat:@"%@'Olympe débarque sur Terre",
                                     (iPhone5) ? @"L" : @"ESEOmega, l"]];
    
    NSURL     *home = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index"
                                                                             ofType:@"html"]];
    NSString  *code = [NSString stringWithContentsOfURL:home encoding:NSUTF8StringEncoding error:nil];
    if (iPhone5)
        code = [code stringByReplacingOccurrencesOfString:@"td style=\"font-size:14px;\"" withString:@"td style=\"font-size:11px;\""];
    
    UIWebView *wv   = [[UIWebView alloc] init];
    [wv setDelegate:self];
    [wv loadHTMLString:code baseURL:home];
    [wv setBackgroundColor:[UIColor colorWithRed:0.808 green:0.906 blue:1.000 alpha:1.000]];
    [self setView:wv];
    
    
    NSURL *url = [NSURL URLWithString:URL_VIDEO];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                                 delegate:nil
                                                            delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          if (error == nil)
                                          {
                                              NSString *source = [[NSString alloc] initWithData:data
                                                                                       encoding:NSISOLatin1StringEncoding];
                                              if (![source isEqualToString:@""])
                                                  [wv loadHTMLString:[code stringByReplacingOccurrencesOfString:@"<div id=\"video\"><p>Connectez-vous à Internet<br/>pour voir la vidéo de campagne</p></div>"
                                                                                                     withString:[NSString stringWithFormat:@"<div id=\"video\"><iframe width=\"301\" height=\"170\" src=\"https://www.youtube-nocookie.com/embed/%@?rel=0\" frameborder=\"0\" allowfullscreen></iframe></div>", source]]
                                                             baseURL:home];
                                           }
                                      }];
    [dataTask resume];
    
    if(IS_OS_6_OR_LATER){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStarted) name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerEnded) name:@"UIMoviePlayerControllerWillExitFullscreenNotification" object:nil];
    }
    if (IS_OS_8_OR_LATER) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStarted) name:UIWindowDidBecomeVisibleNotification object:self.view.window];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerEnded) name:UIWindowDidBecomeHiddenNotification object:self.view.window];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self playerEnded];
}

- (BOOL)           webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
            navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = [request.URL absoluteString];
    if (![[UIApplication sharedApplication] canOpenURL:request.URL])
    {
        if ([[url substringToIndex:10] isEqualToString:@"twitter://"])
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/bde_eseomega"]];
        else if ([[url substringToIndex:5] isEqualToString:@"fb://"])
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://facebook.com/ESEOmega"]];
    }
    else if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) playerStarted
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.videoIsInFullscreen = YES;
}

- (void) playerEnded
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.videoIsInFullscreen = NO;
}

@end
