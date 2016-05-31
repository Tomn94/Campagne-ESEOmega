//
//  TeamTVC.h
//  ESEOmega
//
//  Created by Tomn on 10/02/2015.
//  Copyright (c) 2015 Thomas Naudet. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SDWebImage/UIImageView+WebCache.h"
#define HEIGHT_MEMBRES 100
#define PARALLAX_DIFF  40
//#define URL_PHOTO_GROUPE @"http://176.32.230.7/eseomega.com/img/groupe.jpg"

@interface CellParallax : UITableViewCell

@property (nonatomic, strong) UILabel *nom;
@property (nonatomic, strong) UILabel *detail;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, assign) BOOL parallax;

- (void) cellOnTableView:(UITableView *)tableView
         didScrollOnView:(UIView *)view;

@end

@interface TeamTVC : UITableViewController
{
    NSMutableArray *modules;
    NSMutableArray *noms, *post;
}

@end
