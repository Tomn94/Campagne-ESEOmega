//
//  TeamTVC.h
//  ESEOmega
//
//  Created by Thomas Naudet on 10/02/2015.
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
