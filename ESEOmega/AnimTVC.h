//
//  AnimTVC.h
//  ESEOmega
//
//  Created by Thomas Naudet on 13/02/2015.
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
