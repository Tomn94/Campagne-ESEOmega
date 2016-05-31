//
//  AppDelegate.m
//  ESEOmega
//
//  Created by Tomn on 25/01/2015.
//  Copyright (c) 2015 Thomas Naudet. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)          application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"notifsOK": @NO,
                                                              @"teamQR"  : @"",
                                                              @"nomQR"   : @"",
                                                              @"prenomQR": @""}];

    // Accueil
    HomeVC *vc = [[HomeVC alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [navVC setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"ESEOmega"
                                                       image:[UIImage imageNamed:@"tab"]
                                                         tag:0]];
    
    // Équipe
    TeamTVC *navVC2 = [[TeamTVC alloc] init];
    [navVC2 setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Équipe"
                                                        image:[UIImage imageNamed:@"equipe"]
                                                selectedImage:[UIImage imageNamed:@"equipeSel"]]];
    
    // Programme
    ProgNVC *vc3 = [[ProgNVC alloc] init];
    UINavigationController *navVC3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    [navVC3 setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Programme"
                                                        image:[UIImage imageNamed:@"programme"]
                                                selectedImage:[UIImage imageNamed:@"programmeSel"]]];
    
    // Animations
    AnimTVC *vc4 = [[AnimTVC alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navVC4 = [[UINavigationController alloc] initWithRootViewController:vc4];
    [navVC4 setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Animations"
                                                        image:[UIImage imageNamed:@"animations"]
                                                selectedImage:[UIImage imageNamed:@"animationsSel"]]];
    
    NSMutableArray *tabs = [NSMutableArray arrayWithObjects:navVC, navVC2, navVC3, navVC4, nil];
    
    // Trésor
    if (![[[NSUserDefaults standardUserDefaults] stringForKey:@"teamQR"]   isEqualToString:@""] &&
        ![[[NSUserDefaults standardUserDefaults] stringForKey:@"nomQR"]    isEqualToString:@""] &&
        ![[[NSUserDefaults standardUserDefaults] stringForKey:@"prenomQR"] isEqualToString:@""])
    {
        QRVC *qrcode = [[QRVC alloc] init];
        [qrcode setTitle:@"Chasse"];
        [qrcode.tabBarItem setImage:[UIImage imageNamed:@"tresor"]];
        UINavigationController *navVC5 = [[UINavigationController alloc] initWithRootViewController:qrcode];
        [tabs addObject:navVC5];
    }
    else
    {
        TresorVC *navVC5 = [[TresorVC alloc] init];
        [navVC5 setTitle:@"Chasse"];
        [navVC5.tabBarItem setImage:[UIImage imageNamed:@"tresor"]];
        [tabs addObject:navVC5];
    }
    
    // Global
    mainVC = [[UITabBarController alloc] init];
    [mainVC setViewControllers:tabs];
    [_window addSubview:[mainVC view]];
    [_window setTintColor:[UIColor colorWithRed:0.08 green:0.6 blue:0.85 alpha:1]];
    [_window setRootViewController:mainVC];
    [_window makeKeyAndVisible];

    return YES;
}

- (void) applicationWillResignActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"flashOff" object:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void) applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadAnims" object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger)              application:(UIApplication *)application
supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (self.videoIsInFullscreen == YES)
        return UIInterfaceOrientationMaskAllButUpsideDown;
    return UIInterfaceOrientationMaskPortrait;
}

/*
 Inutile maintenant
- (void)        application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification
{
    BOOL rallye = [notification.alertBody rangeOfString:@"appart"].location != NSNotFound;
    if (application.applicationState != UIApplicationStateInactive)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notification.alertTitle
                                                        message:notification.alertBody
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        if (rallye)
            [alert addButtonWithTitle:@"Voir"];
        [alert show];
    }
    else if (rallye)
    {
        [mainVC setSelectedIndex:3];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollAppart" object:nil];
    }
}

- (void)   alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        [mainVC setSelectedIndex:3];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollAppart" object:nil];
    }
}

- (void)                application:(UIApplication *)application
didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    if (notificationSettings.types == UIUserNotificationTypeNone)
        return;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"notifsOK"])
        return;
    
    NSDate     *auj      = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                                   fromDate:auj];
    
    //!!!: setAlertTitle pour iOS >= 8.2
 
    // Lundi matin anim+bouffe
    UILocalNotification *n1 = [[UILocalNotification alloc] init];
    [n1 setAlertTitle:@"Campagne BDE"];
    [n1 setAlertBody:@"Une petite faim ? N'oubliez pas qu'ESEOmega vous régale pendant les pauses ! Et rendez-vous ce midi pour l'open bouffe 💪⚡️"];
    [n1 setSoundName:UILocalNotificationDefaultSoundName];
    [dateComponents setDay:30];
    [dateComponents setMonth:3];
    [dateComponents setYear:2015];
    [dateComponents setHour:9];
    [dateComponents setMinute:30];
    [dateComponents setSecond:0];
    [n1 setFireDate:[calendar dateFromComponents:dateComponents]];
    [[UIApplication sharedApplication] scheduleLocalNotification:n1];
    
    // Mardi matin anim+bouffe
    UILocalNotification *n2 = [[UILocalNotification alloc] init];
    [n2 setAlertTitle:@"Campagne BDE"];
    [n2 setAlertBody:@"Journée ESEOmega ! Repas offert ce midi 💪⚡️ Retrouvez-nous toute la journée à la Cafet’ & en Dirac, et participez aux animations"];
    [n2 setSoundName:UILocalNotificationDefaultSoundName];
    [dateComponents setDay:31];
    [dateComponents setMonth:3];
    [dateComponents setYear:2015];
    [dateComponents setHour:9];
    [dateComponents setMinute:30];
    [dateComponents setSecond:0];
    [n2 setFireDate:[calendar dateFromComponents:dateComponents]];
    [[UIApplication sharedApplication] scheduleLocalNotification:n2];
    
    // Dévoilement des rallyes appart
    UILocalNotification *n3 = [[UILocalNotification alloc] init];
    [n3 setAlertTitle:@"Campagne BDE"];
    [n3 setAlertBody:@"Après l'effort, le réconfort : ce soir c'est rallye appart ! Retrouvez les adresses en tapant ici. Venez nombreux !"];
    [n3 setAlertAction:@"Voir"];
    [n3 setSoundName:UILocalNotificationDefaultSoundName];
    [dateComponents setDay:31];
    [dateComponents setMonth:3];
    [dateComponents setYear:2015];
    [dateComponents setHour:16];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    [n3 setFireDate:[calendar dateFromComponents:dateComponents]];
    [[UIApplication sharedApplication] scheduleLocalNotification:n3];
    
    // Votez ESEOmega
    UILocalNotification *n4 = [[UILocalNotification alloc] init];
    [n4 setAlertTitle:@"Campagne BDE"];
    [n4 setAlertBody:@"N'oubliez pas, tout le monde vote ESEOmega ! 💪⚡️"];
    [n4 setUserInfo:nil];
    [n4 setSoundName:UILocalNotificationDefaultSoundName];
    [dateComponents setDay:31];
    [dateComponents setMonth:3];
    [dateComponents setYear:2015];
    [dateComponents setHour:23];
    [dateComponents setMinute:42];
    [dateComponents setSecond:0];
    [n4 setFireDate:[calendar dateFromComponents:dateComponents]];
    [[UIApplication sharedApplication] scheduleLocalNotification:n4];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"notifsOK"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}*/

@end
