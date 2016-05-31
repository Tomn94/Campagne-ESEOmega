//
//  ProgNVC.m
//  ESEOmega
//
//  Created by Tomn on 18/03/2015.
//  Copyright (c) 2015 Thomas Naudet. All rights reserved.
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
