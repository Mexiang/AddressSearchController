//
//  DDMapView.m
//  GDAddressSelected
//
//  Created by Dry on 2017/8/4.
//  Copyright © 2017年 Dry. All rights reserved.
//

#import "DDMapView.h"

@interface DDMapView ()<MAMapViewDelegate>

@end

@implementation DDMapView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<DDMapViewDelegate>)delegate {
    if (self = [super initWithFrame:frame]) {
        
        self.delegate = delegate;
        
        [self setUpUI];
    }
    return self;
}
#pragma mark setUpUI
- (void)setUpUI {
    
    [self mapView];
    
    [self setUpCenterView];
}

- (void)setUpCenterView {
    UIImage *centerImg         = [UIImage imageNamed:@"centerAnnotation"];
    UIImageView *centerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*0.5-centerImg.size.width*0.5, self.frame.size.height*0.5 - centerImg.size.height, centerImg.size.width, centerImg.size.height)];
    [centerImgView setImage:centerImg];
    [self addSubview:centerImgView];
}

#pragma mark delegate
#pragma MAMapViewDelegate
//地图区域改变完成后会调用此接口(多次调用)
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if ([self.delegate respondsToSelector:@selector(ddMapView:regionDidChangeAnimated:)]) {
        [self.delegate ddMapView:self regionDidChangeAnimated:animated];
    }
    NSLog(@"地图区域改变完");
}
//地图移动结束(多次调用)
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    if ([self.delegate respondsToSelector:@selector(ddMapView:mapDidMoveByUser:)]) {
        [self.delegate ddMapView:self mapDidMoveByUser:wasUserAction];
    }
    NSLog(@"地图移动结束");
}

//添加大头针代理
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userLocationStyleReusedId = @"userLocationStyleReusedId";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReusedId];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:userLocationStyleReusedId];
        }
        
        annotationView.canShowCallout = NO;
        annotationView.image = [UIImage imageNamed:@"heardImg"];
        annotationView.frame = CGRectMake(0, 0, 26, 26);
        annotationView.contentMode = UIViewContentModeScaleToFill;
        annotationView.layer.masksToBounds = YES;
        
        return annotationView;
    }
    
    return nil;
}
//位置或者设备方向更新后，会调用此函数
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (userLocation && userLocation.coordinate.latitude > 0) {
        if (_centerCoordinate.latitude <= 0 || _centerCoordinate.longitude <=0) {
            //地图默认滑动至用户当前位置
            [mapView setCenterCoordinate:userLocation.coordinate animated:YES];
        }
        //保存用户当前位置
        _userCoordinate = userLocation.coordinate;
    }
}

#pragma mark private


#pragma mark set/get
- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:self.bounds];
        [_mapView setShowsScale:NO];
        [_mapView setShowsCompass:NO];
        [_mapView setRotateEnabled:NO];
        [_mapView setDelegate:self];
        [_mapView setShowsUserLocation:YES];
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        [_mapView setZoomLevel:15];
        [_mapView setCustomizeUserLocationAccuracyCircleRepresentation:YES];//自定义用户精度圈
        [self addSubview:_mapView];
    }
    return _mapView;
}

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate animated:(BOOL)animated {
    _centerCoordinate = centerCoordinate;
    [self.mapView setCenterCoordinate:_centerCoordinate animated:animated];
}
- (CLLocationCoordinate2D)centerCoordinate {
    return self.mapView.centerCoordinate;
}

@end
