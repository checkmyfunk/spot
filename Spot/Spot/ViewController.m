//
//  ViewController.m
//  Spot
//
//  Created by Vitali Potchekin on 8/16/14.
//  Copyright (c) 2014 Vitali Potchekin. All rights reserved.
//

#import "ViewController.h"
#import "ParkingData.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@end

@implementation ViewController

CLLocationManager *locationManager;

- (IBAction)parkOut:(UIButton *)sender {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}

- (IBAction)parkIn:(UIButton *)sender {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"didUpdateToLocation: %@", [locations lastObject]);
    CLLocation *currentLocation = [locations lastObject];
    
    if (currentLocation != nil) {
        ParkingData *parking = [[ParkingData alloc] init];
        
        parking.longitude = currentLocation.coordinate.longitude;
        parking.latitude = currentLocation.coordinate.latitude;
        
        NSLog(@"longtitude: %f", parking.longitude);
        NSLog(@"longtitude: %f", parking.latitude);
        
        self.longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        self.latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        [locationManager stopUpdatingLocation];
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
	
    //Add a basemap tiled layer
    NSURL* url = [NSURL URLWithString:@"http://services.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer"];
    NSURL* parkURL = [NSURL URLWithString:@"http://services.arcgis.com/N2GXMYZXEr0aZccy/arcgis/rest/services/Parking_Regulation_Shapefile/FeatureServer/0"];
    
    AGSTiledMapServiceLayer *tiledLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:url];
    AGSFeatureLayer *signsLayer = [AGSFeatureLayer featureServiceLayerWithURL:parkURL mode:AGSFeatureLayerModeOnDemand];
    
    //expose layer fields to be accssible by callouts
    signsLayer.outFields = [NSArray arrayWithObject:@"*"];
    
    //allow to display callouts on taping the feature
    signsLayer.allowCallout = YES;
    
    [self.mapView addMapLayer:tiledLayer withName:@"Park Data"];
    [self.mapView addMapLayer:signsLayer];
    
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
