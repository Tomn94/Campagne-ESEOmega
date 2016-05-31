//
//  ProgNVC.m
//  ESEOmega
//
//  Created by Thomas Naudet on 18/03/2015.
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

#import "ProgNVC.h"

@implementation ProgNVC

- (instancetype) init
{
    self = [super init];
    if (self) {
        urlVideo = @"";
        NSURL    *prog = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"programme" ofType:@"html"]];
        NSString *code = [NSString stringWithContentsOfURL:prog encoding:NSUTF8StringEncoding error:nil];
        
        seg = [[UISegmentedControl alloc] initWithItems:@[@"Notre programme", @"Vidéo & liens"]];
        [seg setSelectedSegmentIndex:0];
        [seg addTarget:self action:@selector(changeTab) forControlEvents:UIControlEventValueChanged];
        
        wv = [[UIWebView alloc] init];
        [wv setBackgroundColor:[UIColor colorWithRed:0.808 green:0.906 blue:1.000 alpha:1.000]];
        [wv setDelegate:self];
        [wv setScalesPageToFit:NO];
        [wv setMultipleTouchEnabled:NO];
        [wv loadHTMLString:code baseURL:prog];
        
        [self setView:wv];
        [self.navigationItem setTitleView:seg];
        
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
                                                  {
                                                      urlVideo = source;
                                                      if ([seg selectedSegmentIndex])
                                                          [wv loadHTMLString:[code stringByReplacingOccurrencesOfString:@"<div id=\"video\"><p>Connectez-vous à Internet<br/>pour voir la vidéo de campagne</p></div>"
                                                                                                             withString:[NSString stringWithFormat:@"<div id=\"video\"><iframe width=\"301\" height=\"170\" src=\"https://www.youtube-nocookie.com/embed/%@?rel=0\" frameborder=\"0\" allowfullscreen></iframe></div>", source]]
                                                                     baseURL:prog];
                                                  }
                                              }
                                          }];
        [dataTask resume];
    }
    return self;
}

- (void) changeTab
{
    if (![seg selectedSegmentIndex])
    {
        NSURL *prog = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"programme" ofType:@"html"]];
        [wv loadRequest:[NSURLRequest requestWithURL:prog]];
    }
    else
    {
        NSURL *prog = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video"     ofType:@"html"]];
        NSString *code = [NSString stringWithContentsOfURL:prog encoding:NSUTF8StringEncoding error:nil];
        if (![urlVideo isEqualToString:@""])
            code = [code stringByReplacingOccurrencesOfString:@"<div id=\"video\"><p>Connectez-vous à Internet<br/>pour voir la vidéo de campagne</p></div>"
                                                   withString:[NSString stringWithFormat:@"<div id=\"video\"><iframe width=\"301\" height=\"170\" src=\"https://www.youtube-nocookie.com/embed/%@?rel=0\" frameborder=\"0\" allowfullscreen></iframe></div>", urlVideo]];
        [wv loadHTMLString:code baseURL:prog];
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
