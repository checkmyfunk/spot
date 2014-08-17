//
//  ParkingData.h
//  Spot
//
//  Created by Vitali Potchekin on 8/16/14.
//  Copyright (c) 2014 Vitali Potchekin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParkingData : NSObject

@property (nonatomic)float latitude;
@property (nonatomic)float longitude;
@property (strong, nonatomic) NSString *parkType;

@end
