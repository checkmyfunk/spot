//
//  ViewController.h
//  Spot
//
//  Created by Vitali Potchekin on 8/16/14.
//  Copyright (c) 2014 Vitali Potchekin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>

@interface ViewController : UIViewController <AGSCalloutDelegate>
@property (strong, nonatomic) IBOutlet AGSMapView *mapView;

@end
