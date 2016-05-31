//
//  TresorVC.h
//  ESEOmega
//
//  Created by Tomn on 13/02/2015.
//  Copyright (c) 2015 Thomas Naudet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JoinTVC.h"

@interface TresorVC : UINavigationController <UITableViewDataSource, UITableViewDelegate>

+ (NSComparisonResult) jeuDispo;
- (void) newTeam;
- (void) joinTeam;

@end