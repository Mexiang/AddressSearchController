//
//  DDLocationReGeocode.h
//  GDAddressSelected
//
//  Created by Dry on 2017/8/2.
//  Copyright © 2017年 Dry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface DDLocationReGeocode : NSObject

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *cityCode;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *address;

@property (nonatomic      ) CLLocationCoordinate2D coordinate;


@end
