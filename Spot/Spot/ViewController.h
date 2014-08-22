//
//  ViewController.h
//  Spot
//
//  Created by Vitali Potchekin on 8/16/14.
//  Copyright (c) 2014 Vitali Potchekin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>

@interface ViewController : UIViewController <AGSCalloutDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet AGSMapView *mapView;


//adding esri tools to add park in and park out info to the map layer
@property (nonatomic,strong) AGSGDBFeatureServiceTable *featureServiceTable;

@property (strong) AGSGDBFeatureTable *localFeatureTable;
@property (strong) AGSFeatureTableLayer *featureTableLayer;

@end
