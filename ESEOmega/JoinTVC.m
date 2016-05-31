//
//  JoinTVC.m
//  ESEOmega
//
//  Created by Tomn on 14/02/2015.
//  Copyright (c) 2015 Thomas Naudet. All rights reserved.
//

#import "JoinTVC.h"

#pragma mark - Table View Cell

@implementation CellForm

- (instancetype) initWithStyle:(UITableViewCellStyle)style
               reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titre = [[UILabel alloc] initWithFrame:CGRectMake(17, 0, 125, 44)];
        [_titre setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_titre];
        
        CGFloat w = [UIScreen mainScreen].bounds.size.width - 160;
        _contenu = [[UITextField alloc] initWithFrame:CGRectMake(160, 0, w, 46)];
        [_contenu setTextColor:[UIColor grayColor]];
        [_contenu setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_contenu setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        [_contenu setDelegate:self];
        [self addSubview:_contenu];
    }
    return self;
}

- (BOOL)            textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
            replacementString:(NSString *)string
{
    NSString  *proposedNewString = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    NSString  *result = [proposedNewString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSUInteger length = [result length];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"activBouton"
                                                        object:nil
                                                      userInfo:@{@"plein": [NSNumber numberWithUnsignedInteger:length],
                                                                 @"tag": [NSNumber numberWithInteger:textField.tag]}];
    
    return length <= 30;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    UIView *vue = [self.superview viewWithTag:[textField tag] + 1];
    if (vue)
        [vue becomeFirstResponder];
    else
        [textField resignFirstResponder];
    
    return NO;
}

@end

#pragma mark - Table View

@implementation JoinTVC

- (instancetype) initWithMode:(int)creerJoindre
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        mode       = creerJoindre;
        plein0     = NO;
        plein1     = NO;
        plein2     = NO;
        tapValider = NO;
        [self.navigationItem setTitle:@"Mon équipe"];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(activationBouton:)
                                                     name:@"activBouton"
                                                   object:nil];
    }
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Met le curseur dans la première zone vide
    for (int i = 1; i < 4; ++i)
    {
        UITextField *view = (UITextField *)[self.tableView viewWithTag:i];
        if (!view.text.length)
        {
            [view becomeFirstResponder];
            break;
        }
    }
}

- (void) activationBouton:(NSNotification *)notif
{
    BOOL     prev = plein0 && plein1 && plein2;
    BOOL      val = [[notif.userInfo valueForKey:@"plein"] boolValue];
    NSInteger tag = [[notif.userInfo valueForKey:@"tag"] integerValue];
    if (tag == 1)
        plein0 = val;
    else if (tag == 2)
        plein1 = val;
    else
        plein2 = val;
    
    if (prev != (plein0 && plein1 && plein2))
    {
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2]
                      withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

- (void) valider
{
    if ([TresorVC jeuDispo] != NSOrderedSame)
        return;
    if (tapValider)
        return;
    
    tapValider = YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:(mode) ? @"Voulez-vous vraiment créer une équipe ?"
                                                                   : @"Voulez-vous vraiment rejoindre l'équipe ?"
                                                    message:@"Une fois validé, vous ne pourrez plus changer d'équipe."
                                                   delegate:self
                                          cancelButtonTitle:@"Annuler"
                                          otherButtonTitles:@"Oui !", nil];
    [alert show];
}

- (void)        alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex])
    {
        tapValider = NO;
        return;
    }
    
    
    NSString *e = [[(CellForm *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] contenu] text];
    NSString *n = [[(CellForm *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]] contenu] text];
    NSString *p = [[(CellForm *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] contenu] text];
    
    e = [e stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    n = [n stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    p = [p stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    e = [e stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    n = [n stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    p = [p stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://176.32.230.7/eseomega.com/qr/%@.php?e=%@&n=%@&p=%@",
                                       (mode) ? @"createteam" : @"jointeam", e, n, p]];
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
                                              if ([source isEqualToString:@"0"] || (!mode && [source isEqualToString:@"2"]))
                                              {
                                                  NSCharacterSet *charToRemove = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
                                                  NSString *nomSimple = [[[[e stringByRemovingPercentEncoding] componentsSeparatedByCharactersInSet:charToRemove] componentsJoinedByString:@""] lowercaseString];
                                                  
                                                  NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"http://176.32.230.7/eseomega.com/qr/getmyteam.php?e=%@", nomSimple]];
                                                  NSURLSession *defaultSession2 = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                                                                               delegate:nil
                                                                                                          delegateQueue:[NSOperationQueue mainQueue]];
                                                  NSURLSessionDataTask *dataTask2 = [defaultSession2 dataTaskWithURL:url2
                                                                                                 completionHandler:^(NSData *data2, NSURLResponse *response2, NSError *error2)
                                                                                    {
                                                                                        if (error2 == nil)
                                                                                        {
                                                                                            NSString *source2 = [[NSString alloc] initWithData:data2 encoding:NSISOLatin1StringEncoding];
                                                                                            [[NSUserDefaults standardUserDefaults] setObject:source2 forKey:@"teamQR"];
                                                                                        }
                                                                                        else
                                                                                        {
                                                                                            [[NSUserDefaults standardUserDefaults] setObject:[e stringByRemovingPercentEncoding] forKey:@"teamQR"];
                                                                                        }
                                                                                        [[NSUserDefaults standardUserDefaults] setObject:[n stringByRemovingPercentEncoding] forKey:@"nomQR"];
                                                                                        [[NSUserDefaults standardUserDefaults] setObject:[p stringByRemovingPercentEncoding] forKey:@"prenomQR"];
                                                                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                        [self commencer];
                                                                                        tapValider = NO;
                                                                                    }];
                                                  [dataTask2 resume];
                                                  return;
                                              }
                                              
                                              NSString *titre = @"Erreur inconnue";;
                                              if (mode && [source isEqualToString:@"1"])
                                                  titre = @"Une équipe portant ce nom existe déjà.";
                                              else if (mode && [source isEqualToString:@"2"])
                                                  titre = @"Vous appartenez déjà à une autre équipe.";
                                              else if (mode && [source isEqualToString:@"3"])
                                                  titre = @"Une équipe portant ce nom existe déjà.\nDe plus vous appartenez déjà à une autre équipe.";
                                              else if (!mode && ([source isEqualToString:@"1"] || [source isEqualToString:@"3"]))
                                                  titre = @"Aucune équipe portant ce nom n'a déjà été créée.";
                                              else if (!mode && [source isEqualToString:@"4"])
                                                  titre = @"L'équipe que vous voulez rejoindre est pleine (4 joueurs).";
                                              else if (!mode && [source isEqualToString:@"8"])
                                                  titre = @"Vous appartenez déjà à une autre équipe.";
                                              else if (!mode && [source isEqualToString:@"9"])
                                                  titre = @"Aucune équipe portant ce nom n'a déjà été créée.\nDe plus, vous appartenez déjà à une autre équipe.";
                                              
                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:(mode) ? @"Impossible de créer l'équipe" : @"Impossible de rejoindre l'équipe"
                                                                                              message:titre
                                                                                             delegate:self
                                                                                    cancelButtonTitle:@"OK"
                                                                                    otherButtonTitles:nil];
                                              [alert show];
                                          }
                                          else
                                          {
                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:(mode) ? @"Impossible de créer l'équipe" : @"Impossible de rejoindre l'équipe"
                                                                                              message:@"Vérifiez que vous avez accès à Internet"
                                                                                             delegate:self
                                                                                    cancelButtonTitle:@"OK"
                                                                                    otherButtonTitles:nil];
                                              [alert show];
                                          }
                                          tapValider = NO;
                                      }];
    [dataTask resume];
}

- (void) commencer
{
    QRVC *qrcode = [[QRVC alloc] init];
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.4f];
    [animation setType:kCATransitionFade];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.navigationController.view.layer addAnimation:animation forKey:NULL];
    
    [self.navigationController setViewControllers:@[qrcode] animated:NO];
    
    NSString *team = [[NSUserDefaults standardUserDefaults] objectForKey:@"teamQR"];
    if (mode)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"C'est parti !"
                                                        message:[NSString stringWithFormat:@"Votre équipe :\n%@\na été créée.\nVous débutez à 0 point,\nbonne chance 💪⚡️", team]
                                                       delegate:self
                                              cancelButtonTitle:@"À la chasse !"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://176.32.230.7/eseomega.com/qr/scoreteam.php?e=%@",
                                           [team stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
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
                                                  BOOL pluriel = [source integerValue] > 1;
                                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"C'est parti !"
                                                                                                  message:[NSString stringWithFormat:@"Vous avez rejoint votre équipe :\n%@\nVous avez %@ point%@,\nbonne chance 💪⚡️", [[NSUserDefaults standardUserDefaults] objectForKey:@"teamQR"], source, (pluriel) ? @"s" : @""]
                                                                                                 delegate:self
                                                                                        cancelButtonTitle:@"À la chasse !"
                                                                                        otherButtonTitles:nil];
                                                  [alert show];
                                              }
                                              else
                                              {
                                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Impossible de récupérer votre nombre de points"
                                                                                                  message:@"Vérifiez que vous avez accès à Internet"
                                                                                                 delegate:self
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                                  [alert show];
                                              }
                                          }];
        [dataTask resume];
    }
}


#pragma mark Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
        return 2;
    return 1;
}

- (NSString *) tableView:(UITableView *)tableView
 titleForHeaderInSection:(NSInteger)section
{
    if (!section)
        return (mode) ? @"Créer une équipe" : @"Rejoindre une équipe";
    else if (section == 1)
        return @"Votre identité";
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *result;
    
    if (indexPath.section == 2)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tresorEquipeBouton"];
        if (!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:@"tresorEquipeBouton"];
        
        [[cell textLabel] setText:(mode) ? @"Créer mon équipe" : @"Rejoindre mon équipe"];
        [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
        if (plein0 && plein1 && plein2)
        {
            [[cell textLabel] setTextColor:tableView.tintColor];
            [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        }
        else
        {
            [[cell textLabel] setTextColor:[UIColor lightGrayColor]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        result = cell;
    }
    else
    {
        CellForm *cell = [tableView dequeueReusableCellWithIdentifier:@"tresorEquipe"];
        if (!cell)
            cell = [[CellForm alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:@"tresorEquipe"];
        
        [[cell contenu] setReturnKeyType:UIReturnKeyNext];
        if (indexPath.section == 1)
        {
            if (!indexPath.row)
            {
                [[cell titre] setText:(mode) ? @"Prénom du chef" : @"Prénom"];
                [[cell contenu] setPlaceholder:@"Jean"];
                [[cell contenu] setTag:2];
            }
            else
            {
                [[cell titre] setText:(mode) ? @"Nom du chef" : @"Nom"];
                [[cell contenu] setPlaceholder:@"Jeanneteau"];
                [[cell contenu] setTag:3];
                [[cell contenu] setReturnKeyType:UIReturnKeyDone];
            }
        }
        else
        {
            [[cell titre] setText:@"Nom d'équipe"];
            [[cell contenu] setPlaceholder:(mode) ? @"Un nom stylé ici" : @"Ma super équipe"];
            [[cell contenu] setTag:1];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        result = cell;
    }
    
    return result;
}

- (void)     tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 2)
        return;
    
    [[self.tableView viewWithTag:1] resignFirstResponder];
    [[self.tableView viewWithTag:2] resignFirstResponder];
    [[self.tableView viewWithTag:3] resignFirstResponder];
    
    if (plein0 && plein1 && plein2)
        [self valider];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
