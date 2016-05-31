//
//  DefisTVC.m
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

#import "DefisTVC.h"

@implementation DefisTVC

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    UIView  *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 240)];
    UILabel *regles = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, [[UIScreen mainScreen] bounds].size.width - 32, 240)];
    [regles setText:@"- Inscrivez-vous et formez un groupe de 4 personnes dont 1 chef, et tentez de réaliser le plus de défis possibles !\n\
- Chaque défi, dans chaque thème, rapporte plus ou moins de points\n\
- Selon la mission, il est nécessaire d'envoyer une preuve par photo ou vidéo sur Facebook ou à bde@eseomega.fr)\n\
- Pour vous aider, vous pouvez cocher ici ce que vous avez déjà réalisé\n\
- L'équipe gagnante, celle qui aura le plus de points et de QRcodes flashés, sera bien récompensée !\n\
\n\
Bon courage !"];
    [regles setNumberOfLines:0];
    [regles setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
    [regles setFont:[UIFont systemFontOfSize:13]];
    [header addSubview:regles];
    [self.tableView setTableHeaderView:header];
    
    BOOL iPhone5 = [[UIScreen mainScreen] bounds].size.width == 320;
    [self setTitle:@"Défis anim’ de 3 jours"];
    
    defisCat = @[@"Les défis d'Athéna", @"Top Cronos", @"L'ambroisie des dieux", @"Artémis à la chasse", @"Les plaisirs d'Hermès", @"Les supplices d'Hadès", @"Les folies d'Apollon", @"Zeus à l'ESEO", @"Les caprices d'Hestia", @"La vengeance de Poséidon", @"Les délires de Cupidon"/*, @"Dionysos paie sa tournée"*/];
    
    defis    = @[@[QRC, @"Le snap/photo ressemblant le plus\nà un grec/dieu", @"Le plus de monde sur une chaise", DOWN, @"Liker la page Facebook de la liste", @"Ajouter la liste sur Snapchat"],
                 @[@"Lancer un aviron bayonnais (paquito) à Ralliement", @"Danser YMCA sur la fontaine du Ralliement : torse nu", @"Danser YMCA sur la fontaine du Ralliement : en soutif", @"Pyramide humaine à au moins 6 à Ralliement", @"Course contre le tram entre Ralliement et Molière"],
                 @[@"Manger un sandwich de pâté au chien/chat", @"Gober un œuf", @"Manger 5 biscuits pour chien", @"Gober 5 flans"],
                 @[@"Boire tout seul 33 cL de Coca cul sec", @"Boire un café/verre d’eau salé(e)", @"Tenir un glaçon dans sa main jusqu’à ce qu’il fonde"],
                 @[MCDO, @"Poser dans une vitrine de magasin avec une tenue de grec", @"Passer au Drive à pied en imitant la voiture", @"Aller chercher des échantillons gratuits dans un sex-shop"],
                 @[@"Se faire épiler les aisselles à la cire", @"Se laver les dents au tabasco", @"Snifer un rail de poivre"],
                 @[@"Chanter une chanson paillarde à la BU (St Serge ou Belle-Beille)", @"Réussir à refaire la chorégraphie de la liste", @"Chanter le Célestin dans le tram"],
                 @[@"Avoir un autographe d'une fille de la liste sur le derrière", @"Faire le lèche-cul auprès de Billy", @"Demander les numéros de la liste (50 %)", @"Venir en sandales/chaussettes à l’ESEO", @"Prendre un selfie avec le Directeur\nou M. Madeline"],
                 @[@"Embrasser (bouche, avec/sans langue) 3 inconnu(e)s dans la rue", @"« Je te tiens, tu me tiens »\navec un ASVP/policier", @"Arroser un inconnu"],
                 @[@"Se laver au lavage auto au Karcher : habillé(e)", @"Se laver au lavage auto au Karcher : en sous-vêtements", @"Se laver au lavage auto au Karcher : à 3", @"Se laver au lavage auto au Karcher : nu(e)", @"Se laver les cheveux à la farine", @"Laver le pare-brise de 3 voitures à un feu rouge"],
                 @[@"Lécher les aisselles d’un mec poilu", @"Se mettre une capote sur la tête jusqu’au nez et réussir à la gonfler", @"Réaliser une prise du Kâmasûtra"]/*,
                 @[@"Boire une girafe à 2", @"Réussir à se faire payer un Ricard par le président de la liste", @"Une pinte cul sec", @"Une bière micro-ondes (25 cL, chaude)"]*/];
    
    defisPts  = @[@[@"2, 4 ou 6 points selon la difficulté du QRcode", @"15 points", @"15 points", @"3 points", @"3 points", @"3 points"],
                 @[@"9 points · vidéo nécessaire", @"3 points · vidéo nécessaire", @"6 points · vidéo nécessaire", @"6 points · photo nécessaire", @"3 points · vidéo nécessaire"],
                 @[@"9 points · vidéo nécessaire", @"6 points · vidéo nécessaire", @"3 points · vidéo nécessaire", @"3 points · vidéo nécessaire"],
                 @[@"9 points · vidéo nécessaire", @"3 points · vidéo nécessaire", @"3 points · vidéo nécessaire"],
                 @[@"9 points · vidéo nécessaire", @"6 points · photo nécessaire", @"6 points · vidéo nécessaire", @"6 points · nous les apporter"],
                 @[@"12 points · vidéo nécessaire", @"9 points · vidéo nécessaire", @"6 points · vidéo nécessaire"],
                 @[@"12 points · vidéo nécessaire", @"6 points · vidéo nécessaire", @"3 points · vidéo nécessaire"],
                 @[@"12 points · photo avec la fille", @"3 à 12 points, à voir avec Billy", @"9 points · nous les apporter", @"6 points · photo nécessaire", @"6 points · photo nécessaire"],
                 @[@"9 points · vidéo nécessaire", @"9 points · photo nécessaire", @"3 points · vidéo nécessaire"],
                 @[@"6 points · vidéo nécessaire", @"9 points · vidéo nécessaire", @"9 points · vidéo nécessaire", @"12 points · vidéo nécessaire", @"6 points · photo nécessaire", @"6 points · vidéo nécessaire"],
                 @[@"9 points · photo nécessaire", @"6 points · photo nécessaire", @"3 points · photo nécessaire"]/*,
                 @[@"12 points · vidéo nécessaire", @"12 points · photo nécessaire", @"3 points · vidéo nécessaire", @"3 points · vidéo nécessaire"]*/];
    
    defaults = [NSUserDefaults standardUserDefaults];
    int i = 0;
    for (NSArray *theme in defis)
    {
        int c = (int)[theme count];
        for (int j = 0 ; j < c ; ++j)
            [defaults registerDefaults:@{[NSString stringWithFormat:@"defi%d-%d", i, j]: @0}];
        i++;
    }
}

- (void) video
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.youtube.com/watch?v=2CfJQAM3yXA"]];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    return [defisCat objectAtIndex:section];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [defisCat count];
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section
{
    return [[defis objectAtIndex:section] count];
}

- (CGFloat)   tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect labelSize = [[[defis objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]
                        boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 55, MAXFLOAT)
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.5]}
                        context:nil];
    
    return labelSize.size.height + 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    BOOL iPhone5 = [[UIScreen mainScreen] bounds].size.width == 320;
    if ([[[defis objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:MCDO])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"defisSpecial"];
        if (!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:@"defisSpecial"];
        UIButton *bouton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        [bouton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 82, -2.5, 48, 48)];
        [bouton addTarget:self action:@selector(video) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:bouton];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"defis"];
        if (!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:@"defis"];
    }
    
    [[cell textLabel] setText:[[defis objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    [[cell textLabel] setNumberOfLines:0];
    [[cell textLabel] setFont:[UIFont systemFontOfSize:15.5]];
    [[cell detailTextLabel] setText:[[defisPts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    [[cell detailTextLabel] setTextColor:[UIColor grayColor]];
    if ([cell.textLabel.text isEqualToString:DOWN])
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    else if ([cell.textLabel.text isEqualToString:QRC])
    {
        [cell setAccessoryType:UITableViewCellAccessoryDetailButton];
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    }
    else
    {
        if ([defaults boolForKey:[NSString stringWithFormat:@"defi%d-%d", (int)indexPath.section, (int)indexPath.row]])
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        else
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    }

    return cell;
}

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:DOWN])
        return;
    else if ([cell.textLabel.text isEqualToString:QRC])
    {
        [(UITabBarController *)(self.view.window.rootViewController) setSelectedIndex:4];
        return;
    }

    [cell setAccessoryType:([cell accessoryType] == UITableViewCellAccessoryCheckmark) ? UITableViewCellAccessoryNone
                                                                                       : UITableViewCellAccessoryCheckmark];
    [defaults setBool:([cell accessoryType] == UITableViewCellAccessoryCheckmark)
               forKey:[NSString stringWithFormat:@"defi%d-%d", (int)indexPath.section, (int)indexPath.row]];
    [defaults synchronize];
}

- (void)                       tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section && !indexPath.row)
        [(UITabBarController *)(self.view.window.rootViewController) setSelectedIndex:4];
}

@end
