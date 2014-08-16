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
    
    [self.mapView addMapLayer:tiledLayer withName:@"Park Data"];
    [self.mapView addMapLayer:parkLayer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
