//
//  DieuxTVC.m
//  ESEOmega
//
//  Created by Tomn on 11/03/2015.
//  Copyright (c) 2015 Thomas Naudet. All rights reserved.
//

#import "DieuxTVC.h"

@implementation DieuxTVC

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Qui Est-Ce ?"];
    indexPick = -1;
    
    UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                           target:self action:@selector(send)];
    [[self navigationItem] setRightBarButtonItem:share];
    
    dieux = @[@"Achille", @"Ajax", @"Aphrodite", @"Apollon", @"Arès", @"Ariane", @"Artémis", @"Asclépios", @"Athéna", @"Atlas", @"Charon", @"Cronos", @"Dédale", @"Déméter", @"Dionysos", @"Éole", @"Éos", @"Éros", @"Europe", @"Gaïa", @"Hadès", @"Hébé", @"Hélios", @"Héphaïstos", @"Héra", @"Héraclès", @"Hermès", @"Hestia", @"Jason", @"Léto", @"Méduse", @"Métis", @"Minos", @"Morphée", @"Narcisse", @"Océan", @"Oedipe", @"Ouranos ", @"Pan", @"Persée", @"Persephone", @"Poséidon", @"Prométhée", @"Rhadamanthe", @"Rhéa", @"Séléné", @"Tartare", @"Thalassa ", @"Thanatos", @"Thésée", @"Triton", @"Ulysse", @"Zeus"];
    noms  = @[@"", @"Alexandre Cosneau", @"Baudouin de Miniac", @"Inès Deliaire", @"Arnaud Billy", @"Alexis Coupechoux", @"Marie Quervarec", @"Ludivine Leal", @"Alexis Demay", @"Marine Icard", @"Romain Mesnil", @"Aurélien Clause", @"Antoine Bretécher", @"Margaux Blanchard", @"Joseph Hien", @"Marwan Boughammoura", @"Isabelle Baudvin", @"Yoann Beuché", @"Thomas Naudet", @"Élodie Boiteux", @"Loïck Planchenault", @"Samia Charaa", @"François Leparoux", @"Victoria Louboutin", @"Flavien Reynaud", @"Guillaume Roineau", @"Élise Habib", @"Nicolas Basily", @"Cécile Delage", @"Julie Frichet", @"Sonasi Katoa", @"Anaïs Crosnier", @"Axel Rollo", @"Clémence Njamfa", @"Victor Voirand", @"Antoine Regnier", @"Valentin Poirier", @"Pierre Flouvat-Cavier", @"Alexis Louis", @"Romain Kermorvant", @"Clément Letailleur", @"Perrine Blaudet", @"Rodolphe Dubant", @"Nicolas Lignée", @"Baptiste Reungoat", @"Eva Legrand", @"Baptiste Gouesbet", @"Antoine de Pouilly", @"Eric O'Neill", @"Timé Kadel", @"Jean Hardy", @"Clément Royer", @"Axel Cahier", @"Jérémy Brée"];
    noms  = [noms sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    rep   = [[NSMutableArray alloc] init];
    NSUInteger c = [dieux count];
    for (int i = 0 ; i < c ; i++)
        [rep addObject:@""];
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:@{@"jeuDieux": rep, @"lastMail": [NSDate dateWithTimeIntervalSinceNow:-45000]}];
    rep   = [NSMutableArray arrayWithArray:[defaults objectForKey:@"jeuDieux"]];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (credits)
        return;
    
    credits = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableView.contentSize.height, [UIScreen mainScreen].bounds.size.width, 21)];
    [credits setText:@"⚡️ Thomas Naudet · François Leparoux 💪"];
    [credits setFont:[UIFont systemFontOfSize:12.0]];
    [credits setTextAlignment:NSTextAlignmentCenter];
    [credits setTextColor:[UIColor colorWithWhite:0.6 alpha:1]];
    [self.view addSubview:credits];
}

#pragma mark - Mail

- (void) send
{
    if ([TresorVC jeuDispo] != NSOrderedSame)
        return;
    
    NSDate *lastMail = [defaults objectForKey:@"lastMail"];
    if ([lastMail timeIntervalSinceNow] > -42000)
    {
        UIAlertView *alerte = [[UIAlertView alloc] initWithTitle:@"Vous nous avez déjà envoyé vos réponses il y a peu de temps"
                                                         message:@"Réessayez dans quelques heures ou venez nous voir !"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alerte show];
        return;
    }
    
    if ([MFMailComposeViewController canSendMail])
    {
        NSUInteger i = 0;
        NSString *reponses = @"";
        for (NSString *dieu in dieux)
        {
            reponses = [reponses stringByAppendingString:[NSString stringWithFormat:@"%@ : %@\n",
                                                          dieu, [rep objectAtIndex:i]]];
            ++i;
        }
        
        NSString *nom    = @"VOTRE NOM ICI";
        NSString *prenom = @"VOTRE PRÉNOM LÀ";
        if (![[[NSUserDefaults standardUserDefaults] stringForKey:@"nomQR"]    isEqualToString:@""] &&
            ![[[NSUserDefaults standardUserDefaults] stringForKey:@"prenomQR"] isEqualToString:@""])
        {
            nom    = [[NSUserDefaults standardUserDefaults] stringForKey:@"nomQR"];
            prenom = [[NSUserDefaults standardUserDefaults] stringForKey:@"prenomQR"];
        }
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        [[controller navigationBar] setTintColor:self.view.tintColor];
        [controller setToRecipients:@[MAIL_ADDR]];
        [controller setSubject:@"Réponses Qui Est-ce ? ESEOmega"];
        [controller setMailComposeDelegate:self];
        [controller setMessageBody:[NSString stringWithFormat:@"Voici mes réponses pour le jeu ESEOmega 💪⚡️\n\nNom : %@\nPrénom : %@\nPromotion : COMPLÉTER\n\n%@", nom, prenom, reponses] isHTML:NO];
        
        [self presentViewController:controller animated:YES completion:^(void){
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    }
    else
    {
        UIAlertView *alerte = [[UIAlertView alloc] initWithTitle:@"Oh non ! Vous ne pouvez pas nous envoyer vos réponses par mail !"
                                                         message:@"Aucun compte de messagerie n'a été renseigné sur votre appareil.\n\nDemandez une fiche papier à remplir ou imprimez celle sur notre site."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:@"ESEOmega.fr", nil];
        [alerte show];
    }
}

- (void)   alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.eseomega.fr/anim"]];
}

- (void) mailComposeController:(MFMailComposeViewController*)controller
           didFinishWithResult:(MFMailComposeResult)result
                         error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MFMailComposeResultFailed)
    {
        UIAlertView *alerte = [[UIAlertView alloc] initWithTitle:@"Vos résultats n'ont pas pu être envoyés"
                                                         message:@"Oh non, une erreur s'est produite lors de l'envoi du message !"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alerte show];
    }
    else if (result == MFMailComposeResultSent)
    {
        UIAlertView *alerte = [[UIAlertView alloc] initWithTitle:@"Merci, nous avons bien reçu vos réponses"
                                                         message:@"En espérant que tout soit bon !\n\nVotez pour nous 💪⚡️"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [defaults setObject:[NSDate date] forKey:@"lastMail"];
        [defaults synchronize];
        [alerte show];
    }
    else if (result == MFMailComposeResultSaved)
    {
        UIAlertView *alerte = [[UIAlertView alloc] initWithTitle:@"Merci pour vos réponses"
                                                         message:@"Le mail a été rajouté aux brouillons.\nN'hésitez pas à nous l'envoyer le plus rapidement possible !\n\nVotez pour nous 💪⚡️"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [defaults setObject:[NSDate date] forKey:@"lastMail"];
        [defaults synchronize];
        [alerte show];
    }
}

#pragma mark - Table view data source

- (CGFloat)   tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPick == indexPath.row)
        return 160;
    return 44;
}

- (UIView *) tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section
{
    UIView  *view = [[UIView alloc] init];
    UILabel *aide = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, [UIScreen mainScreen].bounds.size.width - 32, 160)];
    [aide setText:@"Trouvez en qui sont déguisés les membres !\n\n– Voici la liste de tous les dieux et héros grecs, remplissez-la et rendez-la avant la fin de la semaine sur papier ou par mail avec le bouton ci-dessus\n– Le gagnant est celui qui a le plus de bonnes réponses et qui a été le plus rapide\n– Cherchez bien, chaque membre porte un indice !"];
    [aide setNumberOfLines:0];
    [aide setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
    [aide setFont:[UIFont systemFontOfSize:13]];
    [view addSubview:aide];
    return view;
}

- (CGFloat)    tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
    return 160;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section
{
    return [dieux count] + ((indexPick != -1) ? 1 : 0);
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPick == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"dieuPick"];
        if (!cell)
            cell = [[CellPick alloc] initWithStyle:UITableViewCellStyleDefault
                               reuseIdentifier:@"dieuPick"];
        [[(CellPick *)cell picker] setDataSource:self];
        [[(CellPick *)cell picker] setDelegate:self];
        [[(CellPick *)cell picker] selectRow:[noms indexOfObject:[rep objectAtIndex:indexPick-1]]
                                 inComponent:0 animated:NO];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"dieu"];
        if (!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:@"dieu"];
        NSUInteger index = indexPath.row - ((indexPath.row > indexPick && indexPick != -1) ? 1 : 0);
        [[cell       textLabel] setText:[dieux objectAtIndex:index]];
        [[cell detailTextLabel] setText:[rep objectAtIndex:index]];
    }
    
    return cell;
}

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPick != -1)
    {
        NSIndexPath *ip = [NSIndexPath indexPathForRow:indexPick inSection:indexPath.section];
        indexPick = -1;
        [self.tableView deleteRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationTop];
        
        if (indexPath.row != ip.row && indexPath.row != ip.row - 1)
        {
            indexPick = indexPath.row + ((ip.row > indexPath.row) ? 1 : 0);
            NSIndexPath *ip = [NSIndexPath indexPathForRow:indexPick inSection:indexPath.section];
            [self.tableView insertRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
    else
    {
        indexPick = indexPath.row + 1;
        NSIndexPath *ip = [NSIndexPath indexPathForRow:indexPick inSection:indexPath.section];
        [self.tableView insertRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationTop];
    }
    [credits setAlpha:indexPick == -1];
}

#pragma mark - Picker

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView
 numberOfRowsInComponent:(NSInteger)component
{
    return [noms count];
}

- (NSString *) pickerView:(UIPickerView *)pickerView
              titleForRow:(NSInteger)row
             forComponent:(NSInteger)component
{
    return [noms objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *)pickerView
       didSelectRow:(NSInteger)row
        inComponent:(NSInteger)component
{
    if (indexPick < 0)
        return;
    
    [rep replaceObjectAtIndex:indexPick - 1 withObject:[self pickerView:pickerView
                                                            titleForRow:row
                                                           forComponent:component]];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPick - 1 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
    
    [defaults setObject:rep forKey:@"jeuDieux"];
    [defaults synchronize];
}

@end

@implementation CellPick

- (instancetype) initWithStyle:(UITableViewCellStyle)style
               reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, -10, [UIScreen mainScreen].bounds.size.width, 190)];
        [self addSubview:_picker];
    }
    return self;
}

@end
