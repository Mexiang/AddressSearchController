//
//  DDMapView.h
//  GDAddressSelected
//
//  Created by Dry on 2017/8/4.
//  Copyright © 2017年 Dry. All rights reserved.
//
//
//
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
@class DDMapView;

@protocol DDMapViewDelegate <NSObject>

//滑动地图先执行1，再执行2

@optional
/**
 1、地图区域改变完成后会调用此接口(多次调用)

 @param ddMapView self
 @param animated 是否动画
 */
- (void)ddMapView:(DDMapView *)ddMapView regionDidChangeAnimated:(BOOL)animated;

/**
 2、地图移动结束调用此接口（多次调用）

 @param ddMapView self
 @param wasUserAction 是否用户操作的滑动行为
 */
- (void)ddMapView:(DDMapView *)ddMapView mapDidMoveByUser:(BOOL)wasUserAction;

@end


@interface DDMapView : UIView
{
    CLLocationCoordinate2D _centerCoordinate;//当前地图的中心点经纬度
}

@property (nonatomic, weak) id <DDMapViewDelegate> delegate;
//高德地图
@property (nonatomic, strong) MAMapView *mapView;
//用户当前位置
@property (nonatomic) CLLocationCoordinate2D userCoordinate;


- (instancetype)initWithFrame:(CGRect)frame delegate:(id<DDMapViewDelegate>)delegate;

/**
 设置地图中心点的坐标

 @param centerCoordinate 经纬度坐标
 @param animated 是否有动画
 */
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate animated:(BOOL)animated;
/**
 获取地图中心点的坐标

 @return 经纬度坐标
 */
- (CLLocationCoordinate2D)centerCoordinate;

@end
