//
//  DefisTVC.h
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

#import <UIKit/UIKit.h>

#define MCDO [NSString stringWithFormat:@"Faire une commande parfaite%@à McDo", (iPhone5) ? @"\n" : @" "]
#define DOWN @"Télécharger l'app ESEOmega"
#define QRC  @"Chasse aux QRcodes"

@interface DefisTVC : UITableViewController
{
    NSArray *defisCat, *defis, *defisPts;
    NSUserDefaults *defaults;
}

- (void) video;

@end
