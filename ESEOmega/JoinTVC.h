//
//  JoinTVC.h
//  ESEOmega
//
//  Created by Tomn on 14/02/2015.
//  Copyright (c) 2015 Thomas Naudet. All rights reserved.
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
