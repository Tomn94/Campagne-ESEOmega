//
//  AnimTVC.m
//  ESEOmega
//
//  Created by Tomn on 13/02/2015.
//  Copyright (c) 2015 Thomas Naudet. All rights reserved.
//

#import "AnimTVC.h"

@implementation CellAnim

- (instancetype) initWithStyle:(UITableViewCellStyle)style
               reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 44)];
        [self addSubview:colorView];
    }
    return self;
}

- (void) setColor:(int)type
{
    UIColor *color;
    switch (type) {
        case 0: // Animations
            color = [UIColor colorWithRed:0.3 green:0.8 blue:0.3 alpha:1];
            break;
        case 2: // Bouffe
            color = [UIColor colorWithRed:1 green:0.9 blue:0 alpha:1];
            break;
        case 4: // Soirées
            color = [UIColor colorWithRed:1 green:0 blue:0.2 alpha:1];
            break;
        case 6: // Nous
            color = self.tintColor;
            break;
        case 8: // Eux
            color = [UIColor colorWithWhite:0.5 alpha:1];
            break;
        default:
            color = [UIColor clearColor];
            break;
    }
    [colorView setBackgroundColor:color];
}

@end

@implementation AnimTVC

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Animations & Events"];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Animations"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil action:nil];
    
    semaine = @[@"Lundi 30 mars", @"Mardi 31 mars", @"Mercredi 1er avril", @"Jeudi 2 avril", @"Vendredi 3 avril"];
    
    animsNoms = @[@[@"Petit déjeuner", @"Pauses grignotage", @"L’Énigme de Métis", @"Open Bouffe", @"Cerbère", @"La dégustation d’Hadès", @"Aphrodite", @"Cronos", @"Athéna", @"Attrapez-les tous ! Poulémon"],
                  @[@"Petit déjeuner", @"Pauses grignotage", @"L’Énigme de Métis", @"Mega Bouffe", @"Cerbère", @"Apollon", @"Arès", @"Zeus", @"Poséidon", @"Dionysos", @"Rallye apparts", @"After"],
                  @[@"Tout le monde dort…"],
                  @[@"Débat", @"Remise des lots"],
                  @[@"Votez ESEOmega ! 💪⚡️"]];
    animsDate = @[@[@"7h-8h", @"Toute la journée", @"Toute la journée", @"12h-13h20", @"12h-13h20 et pendant les pauses", @"12h-13h20 et pendant les pauses", @"12h-13h20 et pendant les pauses", @"12h-13h20", @"12h-13h20", @"12h-13h20"],
                  @[@"7h-8h", @"Toute la journée", @"Toute la journée", @"12h-13h20", @"12h-13h20 et pendant les pauses", @"12h-13h20 et pendant les pauses", @"12h-13h20", @"12h-13h20", @"12h-13h", @"12h-13h", TXT_RALLYE, @"À partir de 23h"],
                  @[@"Toute la journée"], // Si changement d'ordre, modifier ROW_RALLYE
                  @[@"À partir de 12h", @"Midi"],
                  @[@"Toute la journée"]];
    animsLieu = @[@[@"Tram Jean-Moulin et devant l'ESEO", @"B009 Dirac", @"Facebook", @"B009 Dirac", @"Intérieur", @"Intérieur", @"Intérieur", @"B009 Dirac", @"Parking Nord ESEO", @"Parking Nord ESEO"],
                  @[@"Tram Jean-Moulin et devant l'ESEO", @"Facebook", @"Cafet’", @"Cafet’", @"Intérieur", @"B009 Dirac", @"Parking Nord ESEO", @"Parking Nord ESEO", @"Parking Nord ESEO", @"Cafet’", @"Lieux secrets", TEXT_AFTER],
                  @[@"En cours le jour, sous ta couette le soir"],
                  @[@"Amphi Jeanneteau", @"ESEO"],
                  @[@"Hall"]];
    animsType = @[@[@2, @2, @0, @2, @0, @0, @0, @0, @0, @0],
                  @[@2, @2, @0, @2, @0, @0, @0, @0, @0, @0, @4, @4],
                  @[@8],
                  @[@6, @0],
                  @[@6]];
    animsDesc = @[@[@"Crêpes à volonté !", @"Travailler dur à l'ESEO, ça creuse !", @"Répondez le 1er à l'énigme Facebook", @"Bon appétit !", @"Atelier photo", @"Attention les olives", @"Fléchettes sur nos têtes", @"Plus vite que le chronomètre", @"Combattez à 2 dans l'arène !", @"À l'ESEO, on chasse les poules… 🐔"],
                  @[@"Crêpes à volonté !", @"Travailler dur à l'ESEO, ça creuse !", @"Répondez le 1er à l'énigme Facebook", @"Bon appétit !", @"Atelier photo", @"Just Dance !", @"Airsoft, à l'assaut !", @"Concours de lancer", @"Mouillez-nous !", @"Troubles de la vision…", @"3 apparts, 3 ambiances de folie !", @"Finissez la soirée en beauté !"],
                  @[@"Grosse blague"],
                  @[@"Notre programme pour vous !", @"Récupérez ce que vous avez gagné !"],
                  @[@"Nous sommes là pour vous !"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView
                                             selector:@selector(reloadData)
                                                 name:@"reloadAnims"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scrollAppart)
                                                 name:@"scrollAppart"
                                               object:nil];
}

/*
 Plus besoin de notifications
 
- (void) viewDidAppear:(BOOL)animated
{
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
}*/

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL) heureRallye
{
    NSDate     *auj      = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                                   fromDate:auj];
    [dateComponents setDay:31];
    [dateComponents setMonth:3];
    [dateComponents setYear:2015];
    [dateComponents setHour:11];
    [dateComponents setMinute:50];
    [dateComponents setSecond:0];
    NSDate *debut = [calendar dateFromComponents:dateComponents];
    [dateComponents setDay:1];
    [dateComponents setMonth:4];
    [dateComponents setYear:2015];
    [dateComponents setHour:2];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    NSDate *fin   = [calendar dateFromComponents:dateComponents];
    
    if ([auj compare:debut] == NSOrderedAscending)
        return NO;
    else if ([auj compare:fin] == NSOrderedDescending)
        return NO;
    
    return YES;
}

- (void) afficherAfter
{
    CLLocationCoordinate2D point = { 47.474445, -0.551603 };
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:point
                                                   addressDictionary:nil];
    MKMapItem *mapItem     = [[MKMapItem alloc]   initWithPlacemark:placemark];
    [mapItem setName:TEXT_AFTER];
    [MKMapItem openMapsWithItems:@[mapItem]
                   launchOptions:nil];
}

- (void) scrollAppart
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:ROW_RALLYE inSection:3]
                          atScrollPosition:UITableViewScrollPositionMiddle
                                  animated:YES];
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [semaine count] + 2;
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section
{
    if (section < 2)
        return 1;
    else if (section == 3)
        return [[animsNoms objectAtIndex:section - 2] count] + 1;
    return [[animsNoms objectAtIndex:section - 2] count];
}

- (NSString *) tableView:(UITableView *)tableView
 titleForHeaderInSection:(NSInteger)section
{
    if (!section)
        //        return @"Ajoutez les anims à votre calendrier\npour ne rien manquer !";
        return @"Participez à l'anim’ de 3 jours !";
    else if (section == 1)
        return @"Jouez à Qui Est-Ce avec nous !";
    return [semaine objectAtIndex:section - 2];
}

- (NSString *) tableView:(UITableView *)tableView
 titleForFooterInSection:(NSInteger)section
{
    if (section == 1)
        return @"\nTouchez les anims & évents pour plus d'infos";
    return nil;
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section < 2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"animHeader"];
        if (!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"animHeader"];
        //        [[cell textLabel] setText:@"Ajouter à mon calendrier"];
        if (!indexPath.section)
            [[cell textLabel] setText:@"Les 12 Travaux de Gaméon"];
        else
        {
            BOOL iPhone5 = [[UIScreen mainScreen] bounds].size.width == 320;
            [[cell textLabel] setText:(iPhone5) ? @"Associez divinités et membres" : @"Associez chaque divinité à un membre"];
        }
        
        //        [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
        //        [[cell textLabel] setTextColor:tableView.tintColor];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else
    {
        if (indexPath.row == ROW_RALLYE + 1)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"animApparts"];
            if (!cell)
                cell = [[CellAnim alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:@"animApparts"];
            
            [[cell textLabel] setText:@"Voir les apparts !"];
            [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
            if ([self heureRallye])
            {
                [[cell textLabel] setTextColor:[UIColor colorWithRed:1 green:0 blue:0.2 alpha:1]];
                [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
            }
            else
            {
                [[cell textLabel] setTextColor:[UIColor lightGrayColor]];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            [[cell detailTextLabel] setText:@""];
            [(CellAnim *)cell setColor:[[[animsType objectAtIndex:indexPath.section - 2] objectAtIndex:ROW_RALLYE] intValue]];
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"anim"];
            if (!cell)
                cell = [[CellAnim alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:@"anim"];
            
            NSUInteger index = (indexPath.row >= ROW_RALLYE + 2) ? indexPath.row - 1 : indexPath.row;
            NSString *description = [[animsDate objectAtIndex:indexPath.section - 2] objectAtIndex:index];
            if ([description isEqualToString:TXT_RALLYE] && ![self heureRallye])
                description = TXT_RALLYE2;
            [[cell textLabel] setText:[[animsNoms objectAtIndex:indexPath.section - 2] objectAtIndex:index]];
            [[cell detailTextLabel] setText:description];
            [[cell detailTextLabel] setTextColor:[UIColor grayColor]];
            [(CellAnim *)cell setColor:[[[animsType objectAtIndex:indexPath.section - 2] objectAtIndex:index] intValue]];
        }
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section && !indexPath.row)
    {
        DefisTVC *defisTVC = [[DefisTVC alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:defisTVC animated:YES];
    }
    else if (indexPath.section == 1 && !indexPath.row)
    {
        DieuxTVC *dieuxTVC = [[DieuxTVC alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:dieuxTVC animated:YES];
    }
    else if (indexPath.section == 3 && indexPath.row == ROW_RALLYE + 1)
    {
        if ([self heureRallye])
        {
            DetailVC *detailVC = [[DetailVC alloc] init];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
    else
    {
        NSUInteger index = (indexPath.row >= ROW_RALLYE + 2) ? indexPath.row - 1 : indexPath.row;
        
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
        NSMutableArray *boutons = [NSMutableArray arrayWithObjects:@"OK", nil];
        if (indexPath.section == 3 && indexPath.row == ROW_RALLYE)
            [boutons insertObject:@"Voir les lieux" atIndex:0];
        [alertView setButtonTitles:boutons];
        [alertView setUseMotionEffects:TRUE];
        [alertView setDelegate:self];
        
        BOOL iPhone5  = [[UIScreen mainScreen] bounds].size.width == 320;
        CGFloat w = [UIScreen mainScreen].bounds.size.width - 70;
        if (iPhone5)
            w += 44;
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 250)];
        
        BOOL longAnim = iPhone5 && ([[[animsNoms objectAtIndex:indexPath.section - 2] objectAtIndex:index] rangeOfString:@"Poulémon"].location != NSNotFound || [[[animsNoms objectAtIndex:indexPath.section - 2] objectAtIndex:index] rangeOfString:@"Votez"].location != NSNotFound);
        UILabel *titre = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, w - 20, 25)];
        [titre setText:[[animsNoms objectAtIndex:indexPath.section - 2] objectAtIndex:index]];
        [titre setTextColor:self.view.tintColor];
        [titre setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:(longAnim) ? 17 : 21]];
        [titre setTextAlignment:NSTextAlignmentCenter];
        [customView addSubview:titre];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, w, 100)];
        int section = (int)indexPath.section - 2;
        if (section == 1 && indexPath.row < 5)
            section--;
        [image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d%d.jpg", section, (int)indexPath.row]]];
        [image setContentMode:UIViewContentModeScaleAspectFill];
        [image setClipsToBounds:YES];
        [customView addSubview:image];
        
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(42, 146, w - 40, 22)];
        [desc setText:[[animsDesc objectAtIndex:indexPath.section - 2] objectAtIndex:index]];
        [desc setTextColor:[UIColor darkGrayColor]];
        [desc setFont:[UIFont systemFontOfSize:14]];
        [customView addSubview:desc];
        UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(13, 148.5, 19, 19)];
        [image1 setImage:[UIImage imageNamed:@"animDesc"]];
        [customView addSubview:image1];
        
        NSString *txtLieu = [[animsLieu objectAtIndex:indexPath.section - 2] objectAtIndex:index];
        if (iPhone5)
            txtLieu = [txtLieu stringByReplacingOccurrencesOfString:@"Tram " withString:@""];
        if ([txtLieu isEqualToString:TEXT_AFTER])
            [boutons insertObject:@"Ouvrir Plans" atIndex:0];
        UILabel *lieu = [[UILabel alloc] initWithFrame:CGRectMake(42, 180, w - 40, 22)];
        [lieu setText:txtLieu];
        [lieu setTextColor:[UIColor darkGrayColor]];
        [lieu setFont:[UIFont systemFontOfSize:14]];
        [customView addSubview:lieu];
        UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(13, 181, 20, 20)];
        [image2 setImage:[UIImage imageNamed:@"animLoc"]];
        [customView addSubview:image2];
        
        UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(42, 213, w - 40, 22)];
        if ([[[animsDate objectAtIndex:indexPath.section - 2] objectAtIndex:index] rangeOfString:TXT_RALLYE].location != NSNotFound)
        {
            if ([self heureRallye])
                [date setText:[[NSString stringWithFormat:@"%@", TXT_RALLYE] stringByReplacingOccurrencesOfString:@" & "
                                                                                                       withString:@"/"]];
            else
                [date setText:TXT_RALLYE2];
        }
        else
            [date setText:[[NSString stringWithFormat:@"%@ %@",
                            [[[semaine   objectAtIndex:indexPath.section - 2] componentsSeparatedByString:@" "] firstObject],
                            [[[animsDate objectAtIndex:indexPath.section - 2] objectAtIndex:index] lowercaseString]] stringByReplacingOccurrencesOfString:@"pendant les" withString:@"aux"]];
        [date setTextColor:[UIColor darkGrayColor]];
        [date setFont:[UIFont systemFontOfSize:14]];
        [customView addSubview:date];
        UIImageView *image3 = [[UIImageView alloc] initWithFrame:CGRectMake(13, 214.5, 19, 19)];
        [image3 setImage:[UIImage imageNamed:@"animTmp"]];
        [customView addSubview:image3];
        
        [alertView setContainerView:customView];
        [alertView show];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) customIOS7dialogButtonTouchUpInside:(id)alertView
                        clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[[alertView buttonTitles] objectAtIndex:buttonIndex] isEqualToString:@"Voir les lieux"])
    {
        if ([self heureRallye])
        {
            DetailVC *detailVC = [[DetailVC alloc] init];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Surprise !"
                                                            message:@"Les apparts restent secrets pour le moment"
                                                           delegate:self
                                                  cancelButtonTitle:@"Je reviendrai…"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else if ([[[alertView buttonTitles] objectAtIndex:buttonIndex] isEqualToString:@"Ouvrir Plans"])
        [self afficherAfter];
    [alertView close];
}

@end
