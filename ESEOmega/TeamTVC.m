//
//  TeamTVC.m
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

#import "TeamTVC.h"

@implementation CellParallax

- (instancetype) initWithStyle:(UITableViewCellStyle)style
               reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _parallax = YES;
        CGFloat w = [[UIScreen mainScreen] bounds].size.width;
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setSeparatorInset:UIEdgeInsetsMake(0, 118, 0, 0)];
        
        _nom = [[UILabel alloc] initWithFrame:CGRectMake(130, 32.5, w - 130, 21)];
        [self addSubview:_nom];
         
         _detail = [[UILabel alloc] initWithFrame:CGRectMake(130, 50, w - 130, 21)];
        [_detail setFont:[UIFont systemFontOfSize:12]];
        [_detail setTextColor:[UIColor colorWithWhite:0.4 alpha:1]];
        [self addSubview:_detail];
        
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(0, -(PARALLAX_DIFF/2), HEIGHT_MEMBRES, HEIGHT_MEMBRES + PARALLAX_DIFF)];
        [_image setContentMode:UIViewContentModeScaleAspectFill];
        [_image.layer setMasksToBounds:YES];
        [self.layer setMasksToBounds:YES];
        [self addSubview:_image];
    }
    return self;
}

- (void) cellOnTableView:(UITableView *)tableView
         didScrollOnView:(UIView *)view
{
    if (!_parallax)
    {
        [_image setFrame:CGRectMake(0, -(PARALLAX_DIFF/4), HEIGHT_MEMBRES, HEIGHT_MEMBRES + (PARALLAX_DIFF / 2))];
        return;
    }
    
    CGRect rectInSuperview = [tableView convertRect:self.frame toView:view];
    
    float distanceFromCenter = CGRectGetHeight(view.frame)/2 - CGRectGetMinY(rectInSuperview);
    float move = (distanceFromCenter / CGRectGetHeight(view.frame)) * PARALLAX_DIFF;
    
    CGRect imageRect = _image.frame;
    imageRect.origin.y = -(PARALLAX_DIFF/2)+move;
    _image.frame = imageRect;
}

@end

@implementation TeamTVC

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Si modif, changer aussi dans membres.xcassets
    modules = [NSMutableArray arrayWithObjects:@"Bureau", @"Event", @"Anim", @"Club", @"Com", @"REX/Interpole", @"Log", @"RCII", @"Voyage", @"Sponsors", nil];
    
    noms = [NSMutableArray arrayWithObjects:@[@"Jérémy Brée", @"Marine Icard", @"Rodolphe Dubant", @"Joseph Hien", @"Romain Kermorvant", @"Cécile Delage"],
                                            @[@"Romain Mesnil", @"Marwan Boughammoura", @"Samia Charaa", @"Alexis Demay", @"Pierre Flouvat-Cavier", @"Julie Frichet", @"Eva Legrand", @"Flavien Reynaud"],
                                            @[@"Yoann Beuché", @"Arnaud Billy", @"Antoine Bretécher", @"Aurélien Clause", @"Clément Letailleur", @"Loïck Planchenault"],
                                            @[@"Ludivine Leal", @"Nicolas Basily", @"Inès Deliaire", @"Marie Quervarec"],
                                            @[@"Axel Cahier", @"Timé Kadel", @"Sonasi Katoa", @"François Leparoux", @"Alexis Louis", @"Thomas Naudet", @"Axel Rollo"],
                                            @[@"Victor Voirand", @"Perrine Blaudet", @"Victoria Louboutin"],
                                            @[@"Baudouin de Miniac", @"Baptiste Gouesbet", @"Antoine de Pouilly"],
                                            @[@"Alexandre Cosneau", @"Margaux Blanchard", @"Anaïs Crosnier"],
                                            @[@"Élodie Boiteux", @"Isabelle Baudvin"],
                                            @[@"Élise Habib", @"Jean Hardy", @"Nicolas Lignée"], nil];
    
    post = [NSMutableArray arrayWithObjects:@[@"Président", @"Vice-présidente", @"Vice-président", @"Trésorier",@"Trésorier", @"Secrétaire"],
                                            @[@"Responsable", @"Staff", @"Staff", @"Staff", @"Staff", @"Staff", @"Staff", @"Staff"],
                                            @[@"Responsable", @"Staff", @"Staff", @"Staff", @"Staff", @"Staff"],
                                            @[@"Responsable", @"Staff", @"Staff", @"Staff"],
                                            @[@"Responsable", @"Staff", @"Staff", @"Staff", @"Staff", @"Staff", @"Staff"],
                                            @[@"Responsable", @"Staff", @"Staff"],
                                            @[@"Responsable", @"Staff", @"Staff"],
                                            @[@"Responsable", @"Staff", @"Staff"],
                                            @[@"Responsable", @"Staff"],
                                            @[@"Responsable", @"Staff", @"Staff"], nil];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 48.5f, 0.0f);
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self scrollViewDidScroll:nil];
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Table view data source

- (CGFloat)    tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
    if (!section)
        return 2 * HEIGHT_MEMBRES;
    return 1.33 * HEIGHT_MEMBRES;
}

- (CGFloat)   tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_MEMBRES;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 + [modules count];
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section
{
    if (!section)
        return 0;
    return [[noms objectAtIndex:section - 1] count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellParallax *cell = [tableView dequeueReusableCellWithIdentifier:@"membre"];
    if (!cell)
        cell = [[CellParallax alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:@"membre"];
    
    NSString *nom = [[noms objectAtIndex:[indexPath section] - 1] objectAtIndex:[indexPath row]];
    [[cell nom]    setText:nom];
    [[cell detail] setText:[[post objectAtIndex:[indexPath section] - 1] objectAtIndex:[indexPath row]]];
    [nom enumerateSubstringsInRange:NSMakeRange(0, [nom length])
                            options:NSStringEnumerationByWords | NSStringEnumerationReverse
                         usingBlock:^(NSString *substring, NSRange subrange, NSRange enclosingRange, BOOL *stop)
    {
        [[cell image] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_%@.jpg",
                             [[[modules objectAtIndex:indexPath.section - 1] lowercaseString] stringByReplacingOccurrencesOfString:@"/"
                                                                                                                        withString:@""],
                                                                 [[substring lowercaseString] stringByReplacingOccurrencesOfString:@"é"
                                                                                                                         withString:@"e"]]]];
        *stop = YES;
    }];
    [cell setParallax:!(indexPath.section == 10 && indexPath.row)];
    [cell.image setFrame:CGRectMake(0, -(PARALLAX_DIFF/2), HEIGHT_MEMBRES, HEIGHT_MEMBRES + PARALLAX_DIFF)];
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section
{
    int w = [UIScreen mainScreen].bounds.size.width;
    CGRect frame = CGRectMake(0, 0, w, HEIGHT_MEMBRES * ((!section) ? 2 : 1.33));
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:frame];
    [image setContentMode:UIViewContentModeScaleAspectFill];
    if (!section)
        [image setImage:[UIImage imageNamed:@"groupe.jpg"]];
    /*{
        [image sd_setImageWithURL:[NSURL URLWithString:URL_PHOTO_GROUPE]
                 placeholderImage:[UIImage imageNamed:@"logo"]
                        completed:^(UIImage *imageDown, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            if (error == nil)
                            {
                                [image setImage:imageDown];
                                [image setContentMode:UIViewContentModeScaleAspectFill];
                            }
                        }];
    }*/
    else
        [image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", [[modules objectAtIndex:section - 1] stringByReplacingOccurrencesOfString:@"/" withString:@""]]]];
    [image.layer setMasksToBounds:YES];
    [view addSubview:image];
    
    BOOL iPhone4 = [[UIScreen mainScreen] bounds].size.height == 480;
    
    if (section)
    {
        UILabel *titre = [[UILabel alloc] initWithFrame:frame];
        [titre setAttributedText:[[NSAttributedString alloc] initWithString:[modules objectAtIndex:section-1]
                                                                 attributes:@{NSKernAttributeName: @2}]];
        [titre setTextAlignment:NSTextAlignmentCenter];
        [titre setFont:[UIFont fontWithName:@"elektra" size:34]];
        [titre setTextColor:[UIColor whiteColor]];
        if (!iPhone4)
        {
            [titre.layer setShadowRadius:7];
            [titre.layer setShadowColor:[UIColor blackColor].CGColor];
            [titre.layer setShadowOpacity:1];
            [titre.layer setShadowOffset:CGSizeMake(0, 0)];
        }
        [view addSubview:titre];
    }
    
    if (!iPhone4)
    {
        [view.layer setShadowRadius:3];
        [view.layer setShadowColor:[UIColor blackColor].CGColor];
        [view.layer setShadowOpacity:1];
        [view.layer setShadowOffset:CGSizeMake(0, 0)];
        [view setAlpha:0.94];
    }
    
    return view;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray *visibleCells = [self.tableView visibleCells];
    
    for (CellParallax *cell in visibleCells)
        [cell cellOnTableView:self.tableView didScrollOnView:self.view.superview];
}

@end
