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
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) ParkingData *parking;

@end

@implementation ViewController

- (CLLocationManager *)locationManager{
    if(!_locationManager){
        _locationManager = [[CLLocationManager alloc] init];
    }
    
    return _locationManager;
}
//CLLocationManager *locationManager;

- (IBAction)parkOut:(UIButton *)sender {
    [self setUpViewControllerToStartUpdatingLocation];
}

- (IBAction)parkIn:(UIButton *)sender {
    [self setUpViewControllerToStartUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)setUpViewControllerToStartUpdatingLocation{
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"didUpdateToLocation: %@", [locations lastObject]);
    CLLocation *currentLocation = [locations lastObject];
    
    if (currentLocation) {
        self.parking = [[ParkingData alloc] init];
        self.parking.longitude = currentLocation.coordinate.longitude;
        self.parking.latitude = currentLocation.coordinate.latitude;
        
        NSLog(@"longtitude: %f", self.parking.longitude);
        NSLog(@"longtitude: %f", self.parking.latitude);
        
        self.longitudeLabel.text = [NSString stringWithFormat:@"%.8f", self.parking.longitude];
        self.latitudeLabel.text = [NSString stringWithFormat:@"%.8f", self.parking.latitude];
        
        NSURL* parkURL = [NSURL URLWithString:@"http://services.arcgis.com/N2GXMYZXEr0aZccy/arcgis/rest/services/Parking_Regulation_Shapefile/FeatureServer/0"];
        
        self.featureServiceTable = [[AGSGDBFeatureServiceTable alloc]
                                    initWithServiceURL:parkURL
                                    credential:nil
                                    spatialReference:[AGSSpatialReference webMercatorSpatialReference]];
        
        //from the feature service table (online)
        self.featureTableLayer = [[AGSFeatureTableLayer alloc]
                                  initWithFeatureTable:self.featureServiceTable];
        //add the layer to the map
        self.featureTableLayer.delegate = self;
        [self.mapView addMapLayer:self.featureTableLayer withName:@"Feature Layer"];
        
        [self stopUpdatingLocation];
    }
}

- (void)stopUpdatingLocation {
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
}

- (void)layerDidLoad:(AGSLayer *)layer {
    
    if (self.parking) {
        //Create a geometry
        AGSPoint *point = [[AGSPoint alloc]initWithX:self.parking.longitude y: self.parking.latitude spatialReference:[AGSSpatialReference wgs84SpatialReference]];
        
        //Instantiate a new feature
        AGSGDBFeature *feature = [[AGSGDBFeature alloc]initWithTable:self.featureServiceTable];
        
        //Set the geometry
        [feature setGeometry:point];
        
        //Add the feature to the AGSGDBFeatureTable
        NSError* err;
        BOOL success = [self.featureServiceTable saveFeature:feature error:&err];
        
        if (success){
            NSLog(@"Success adding this objectId");
        }
        else {
            NSLog(@"Fail. Investigate this error : %@", [err localizedDescription]);
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
	
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
    
    //Get current location and zoom into it
    [self.mapView.locationDisplay startDataSource];
    self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeCompassNavigation;
    //amount of map visible space is left untill map starts shifting to follows the location
    self.mapView.locationDisplay.wanderExtentFactor = 0.5;
    
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
