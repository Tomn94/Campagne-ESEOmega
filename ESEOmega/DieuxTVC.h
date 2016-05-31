//
//  DieuxTVC.h
//  ESEOmega
//
//  Created by Thomas Naudet on 11/03/2015.
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
#import <MessageUI/MessageUI.h>
#import "TresorVC.h"

#define MAIL_ADDR @"bde@eseomega.fr"

@interface DieuxTVC : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate>
{
    NSArray *dieux, *noms;
    NSMutableArray *rep;
    NSInteger indexPick;
    UILabel *credits;
    NSUserDefaults *defaults;
}

- (void) send;

@end

@interface CellPick : UITableViewCell
@property (strong, nonatomic) UIPickerView *picker;
@end
