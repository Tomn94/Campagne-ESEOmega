//
//  TresorVC.m
//  ESEOmega
//
//  Created by Thomas Naudet on 10/02/2015.
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

#import "TresorVC.h"

@implementation TresorVC

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    
    UITableViewController *tv = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [tv setTitle:@"Chasse des 12 Travaux de Gaméon"];
    [tv.tableView setDataSource:self];
    [tv.tableView setDelegate:self];
    tv.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Règles"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:nil
                                                                          action:nil];
    [self setViewControllers:@[tv] animated:NO];
}

+ (NSComparisonResult) jeuDispo
{
    NSComparisonResult r = NSOrderedSame;
    NSDate     *auj      = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                                   fromDate:auj];
    [dateComponents setDay:30];
    [dateComponents setMonth:3];
    [dateComponents setYear:2015];
    NSDate *debut = [calendar dateFromComponents:dateComponents];
    [dateComponents setDay:2];
    [dateComponents setMonth:4];
    [dateComponents setYear:2015];
    NSDate *fin   = [calendar dateFromComponents:dateComponents];
    
    if ([auj compare:debut] == NSOrderedAscending)
        r = NSOrderedAscending;
    else if ([auj compare:fin] == NSOrderedDescending)
        r = NSOrderedDescending;
    
    if (r != NSOrderedSame)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Impossible de participer"
                                                        message:@"Dommage, le jeu est terminé !"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        if (r == NSOrderedAscending)
            [alert setMessage:@"Le jeu n'a pas encore commencé !"];
        [alert show];
    }
    
    return r;
}

- (void) newTeam
{
    if ([TresorVC jeuDispo] != NSOrderedSame)
        return;
    
    JoinTVC *new = [[JoinTVC alloc] initWithMode:1];
    [self pushViewController:new animated:YES];
}

- (void) joinTeam
{
    if ([TresorVC jeuDispo] != NSOrderedSame)
        return;
    
    JoinTVC *new = [[JoinTVC alloc] initWithMode:0];
    [self pushViewController:new animated:YES];
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)    tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
    if ([[UIScreen mainScreen] bounds].size.height == 480)
        return 350;
    else if ([[UIScreen mainScreen] bounds].size.width == 320)
        return 353;
    return 380;
}

- (UIView *) tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    UILabel *titre = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, self.view.frame.size.width, 40)];
    [titre setTextColor:[UIColor colorWithRed:0.259 green:0.383 blue:0.529 alpha:1.000]];
    [titre setFont:[UIFont fontWithName:@"elektra" size:35]];
    [titre setAttributedText:[[NSAttributedString alloc] initWithString:@"Presentation"
                                                             attributes:@{NSKernAttributeName: @2}]];
    [view addSubview:titre];
    
    UILabel *txt = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, self.view.frame.size.width - 30, 95)];
    [txt setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
    [txt setText:@"Sillonnez les terres, explorez les mers, partez à la recherche des QRcodes ESEOmega !\nUne ancienne légende raconte qu'ils sont éparpillés à l'ESEO et dans tout Angers…\nTel Ulysse, partez à l'aventure !"];
    [txt setFont:[UIFont systemFontOfSize:13]];
    [txt setTextAlignment:NSTextAlignmentJustified];
    [txt setNumberOfLines:0];
    [view addSubview:txt];
    
    UILabel *titre2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 155, self.view.frame.size.width, 40)];
    [titre2 setTextColor:[UIColor colorWithRed:0.259 green:0.383 blue:0.529 alpha:1.000]];
    [titre2 setFont:[UIFont fontWithName:@"elektra" size:35]];
    [titre2 setAttributedText:[[NSAttributedString alloc] initWithString:@"Regles"
                                                              attributes:@{NSKernAttributeName: @2}]];
    [view addSubview:titre2];
    
    UILabel *txt2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 200, self.view.frame.size.width - 30, 140)];
    [txt2 setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
    [txt2 setText:@"- Créez votre équipe de 4 membres maximum\n- Flashez les QRcodes avec cette app dès que vous en trouvez un\n- Un QRcode rapporte 2, 4 ou 6 points à l'équipe pour l'anim de 3 jours « Les 12 Travaux de Gaméon » (plus d'infos dans l'onglet Animations)\n- 2 points sont rajoutés si tous les QRcodes moyens sont trouvés, 4 pour tous les difficiles"];
    [txt2 setFont:[UIFont systemFontOfSize:13]];
    [txt2 setTextAlignment:NSTextAlignmentJustified];
    [txt2 setNumberOfLines:0];
    [view addSubview:txt2];
    
    return view;
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tresorAccueil"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"tresorAccueil"];
    
    if (indexPath.row)
        [[cell textLabel] setText:@"Rejoindre une équipe"];
    else
        [[cell textLabel] setText:@"Créer mon équipe"];
    [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
    [[cell textLabel] setTextColor:self.view.tintColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    
    return cell;
}

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section && !indexPath.row)
        [self newTeam];
    else if (!indexPath.section && indexPath.row == 1)
        [self joinTeam];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
