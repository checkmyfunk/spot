//
//  ViewController.m
//  Spot
//
//  Created by Vitali Potchekin on 8/16/14.
//  Copyright (c) 2014 Vitali Potchekin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //Add a basemap tiled layer
    NSURL* url = [NSURL URLWithString:@"http://services.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer"];
    NSURL* parkURL = [NSURL URLWithString:@"http://services.arcgis.com/N2GXMYZXEr0aZccy/arcgis/rest/services/Parking_Regulation_Shapefile/FeatureServer/0"];
    
    AGSTiledMapServiceLayer *tiledLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:url];
    AGSFeatureLayer *parkLayer = [AGSFeatureLayer featureServiceLayerWithURL:parkURL mode:AGSFeatureLayerModeOnDemand];
    
    //expose layer fields to be accssible by callouts
    parkLayer.outFields = [NSArray arrayWithObject:@"*"];
    
    //allow to display callouts on taping the feature
    parkLayer.allowCallout = YES;
    
    [self.mapView addMapLayer:tiledLayer withName:@"Park Data"];
    [self.mapView addMapLayer:parkLayer];
    
    self.mapView.callout.delegate = self;
    
}

- (BOOL) callout:(AGSCallout *)callout willShowForFeature:(id<AGSFeature>)feature layer:(AGSLayer<AGSHitTestable> *)layer mapPoint:(AGSPoint *)mapPoint {
    
    self.mapView.callout.title = (NSString*)[feature attributeForKey:@"x"];
	self.mapView.callout.detail = (NSString*)[feature attributeForKey:@"SIGNDESC1"];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
