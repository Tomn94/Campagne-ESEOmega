//
//  DieuxTVC.h
//  ESEOmega
//
//  Created by Tomn on 11/03/2015.
//  Copyright (c) 2015 Thomas Naudet. All rights reserved.
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
