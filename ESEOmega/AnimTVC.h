//
//  AnimTVC.h
//  ESEOmega
//
//  Created by Tomn on 13/02/2015.
//  Copyright (c) 2015 Thomas Naudet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailVC.h"
#import "DefisTVC.h"
#import "DieuxTVC.h"
#import "CustomIOS7AlertView.h"

#define ROW_RALLYE 10
#define TXT_RALLYE  @"18h30 Midas · 19h30 Poséidon & Hadès"
#define TXT_RALLYE2 @"À partir de 18h30"
#define TEXT_AFTER @"L'Entrepôt · 23 Rue Boisnet"

@interface CellAnim : UITableViewCell
{
    UIView *colorView;
}

- (void) setColor:(int)type;

@end

@interface AnimTVC : UITableViewController
<CustomIOS7AlertViewDelegate>
{
    NSArray *semaine,
            *animsNoms,
            *animsDate,
            *animsLieu,
            *animsType,
            *animsDesc;
}

- (BOOL) heureRallye;
- (void) afficherAfter;
- (void) scrollAppart;

@end
