//
//  JoinTVC.h
//  ESEOmega
//
//  Created by Thomas Naudet on 14/02/2015.
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
#import "QRVC.h"
#import "TresorVC.h"

#pragma mark - Table View Cell

@interface CellForm : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titre;
@property (nonatomic, strong) UITextField *contenu;

@end


#pragma mark - Table View

@interface JoinTVC : UITableViewController <UIAlertViewDelegate>
{
    int mode;
    BOOL plein0, plein1, plein2, tapValider;

}
- (instancetype) initWithMode:(int)mode;
- (void) activationBouton:(NSNotification *)notif;
- (void) valider;
- (void) commencer;

@end
