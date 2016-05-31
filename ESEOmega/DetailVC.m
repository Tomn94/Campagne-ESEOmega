//
//  DetailVC.m
//  ESEOmega
//
//  Created by Tomn on 11/03/2015.
//  Copyright (c) 2015 Thomas Naudet. All rights reserved.
//

#import "DetailVC.h"

@implementation Annotation

@end

@implementation DetailVC

- (instancetype) init
{
    self = [super init];
    if (self) {
        [self setTitle:@"Apparts"];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Ouvrir Plans"
                                                                                    style:UIBarButtonItemStylePlain
                                                                                   target:self
                                                                                   action:@selector(openMaps)]];
        
        MKMapView *map = [[MKMapView alloc] init];
        [map setDelegate:self];
        [self setView:map];
        
        items = [[NSMutableArray alloc] init];
        CLLocationCoordinate2D points[3];
        CLLocationCoordinate2D point0 = { 47.475871, -0.537441 };
        points[0] = point0;
        CLLocationCoordinate2D point1 = { 47.477589, -0.552974 };
        points[1] = point1;
        CLLocationCoordinate2D point2 = { 47.474619, -0.551705 };
        points[2] = point2;
        
        noms = @[@"Le Palais de Midas", @"Les Abysses de Poséidon", @"L'Antre d'Hadès"];
        NSArray *addr = @[@"25 rue Marcheteau", @"69 Quai Félix Faure", @"17 bis rue Maillé"];
        
        for (int i = 0 ; i < 3 ; ++i)
        {
            Annotation *popUp = [[Annotation alloc] init];
            [popUp setTitle:[noms objectAtIndex:i]];
            [popUp setSubtitle:[addr objectAtIndex:i]];
            [popUp setCoordinate:points[i]];
            [map   addAnnotation:popUp];
            
            
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:points[i]
                                                           addressDictionary:nil];
            MKMapItem *mapItem     = [[MKMapItem alloc]   initWithPlacemark:placemark];
            [mapItem setName:[noms objectAtIndex:i]];
            [items addObject:mapItem];
        }
        
        MKCoordinateSpan span = { 0.02, 0.02 };
        CLLocationCoordinate2D centre = { 47.475036, -0.545961 };
        [map setRegion:MKCoordinateRegionMake(centre, span)];
    }
    return self;
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView
             viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *a = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    a.canShowCallout = YES;
    a.animatesDrop = YES;
    switch ([noms indexOfObject:[(Annotation *)annotation title]])
    {
        case 0:
            a.pinColor = MKPinAnnotationColorGreen;
            break;
        case 1:
            a.pinColor = MKPinAnnotationColorPurple;
            break;
        default:
            a.pinColor = MKPinAnnotationColorRed;
            break;
    }
    return a;
}

- (void) openMaps
{
    [MKMapItem openMapsWithItems:items
                   launchOptions:nil];
}

@end
