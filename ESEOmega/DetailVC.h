//
//  DetailVC.h
//  ESEOmega
//
//  Created by Tomn on 11/03/2015.
//  Copyright (c) 2015 Thomas Naudet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *subtitle;

@end

@interface DetailVC : UIViewController <MKMapViewDelegate>
{
    NSArray *noms;
    NSMutableArray *items;
}

- (void) openMaps;

@end
