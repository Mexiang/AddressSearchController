//
//  AddressSelectedController.h
//  GDAddressSelected
//
//  Created by Dry on 2017/8/2.
//  Copyright © 2017年 Dry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DDLocationReGeocode.h"

/**
 回调选则的位置信息

 @param reGeocode 位置信息
 @param error 错误码
 */
typedef void(^DDLocationCompleteBlock)(DDLocationReGeocode *reGeocode, NSError *error);

@interface AddressSelectedController : UIViewController

//回调选中地址信息的block
@property (nonatomic, copy) DDLocationCompleteBlock completeBlock;

/*
 传入经纬度度，进行反地理编码
 */
@property (nonatomic) CLLocationCoordinate2D currentCoordinate;

@end
