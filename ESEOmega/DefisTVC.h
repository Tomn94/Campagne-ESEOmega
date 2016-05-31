//
//  DefisTVC.h
//  ESEOmega
//
//  Created by Tomn on 10/03/2015.
//  Copyright (c) 2015 Thomas Naudet. All rights reserved.
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
