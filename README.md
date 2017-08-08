# HELLO

## 实现效果

如图：
![image.png](http://upload-images.jianshu.io/upload_images/2056220-1a5c46d42135d7f8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

需要引入 高德3D地图SDK，高德搜索SDK，高德地图基础SDK，需配置自己的高德地图AppKey和对应的Boundle id。

项目demo是用pod集成的，demo组织架构使用了MVC设计模式。自己封装了高德地图搜索管理类，拿去直接能用，用法也很简单，关于这个搜索的封装，说明在<http://www.jianshu.com/p/d5a2ace2252d>，里面含gitHub地址。

## 框架结构

![image.png](http://upload-images.jianshu.io/upload_images/2056220-f006690c0f0521db.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

AddressSelectedController是地址搜索的界面，DDLocationReGeocode作为其Model模型，DDMapView是对地图进行的一个抽离，整体采用MVC设计模式。其中DDSearchManager文件中是封装好的搜索管理类。

各个部分的职能很明确，这样子写代码你会发现很简单，看起来也不复杂，当然你如果非要在一个Controller里面即地图又有搜索等等，也行Who cares。

## 实现过程
###### AddressSelectedController.h
```
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
```
这个界面可以从外传入初始经纬度，如果传入了初始经纬度则，地图会直接移动到传入的位置处并进行附近的兴趣点搜索，如果未传入初始经纬度，则地图默认定位到用户当前位置处。

DDLocationCompleteBlock是回调你选中地址信息的block，block里面回调了DDLocationReGeocode的对象reGeocode和NSError的错误码，这里错误码没有定义，如有需要自己添加。

当然也可以使用代理进行数据回调也是可以的，都很好。

###### AddressSelectedController.m

实现文件中添加了地图，tableView，实现了各自的代理方法。移动地图时进行逆地理编码查询POI点，取到兴趣点后刷新列表。

###### DDLocationReGeocode.h

这个model里很简单就是一些数据，在MVC中Model的作用还是挺大的，这里没能全部体现出来，只是淡单纯的储存了一下数据，作为数据传输的主体。

```
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface DDLocationReGeocode : NSObject

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *cityCode;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *address;

@property (nonatomic      ) CLLocationCoordinate2D coordinate;

@end
```
###### DDMapView.h

这个DDMapView里面也很简单就一个地图，中间放了一个图片。对于地图的封装有些人用一个Manager作为地图的管理类来管理地图，我这里直接用了一个View，上面加载了一个地图来处理的，都能实现，不知道哪个方式好，大家可以自己去试试。

```
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
```
这里特别说明一下为什么我将_centerCoordinate写成一个实例变量，又写了他的set、get方法，用一个@property不就搞定了吗，当然不是这样的，之所以这样写的原因是为了扩展它的set方法，添加一个参数animated，原来费这么大惊就为了这个啊，那还有其他什么的简便方法吗，知道的告诉我吧，我们互相学习。

###### DDMapView.m

实现文件里添加了一个地图，一个中间的图片，中间图片没做什么动画之类的，项目需要的话可以自己做，我看好多地图会做一个地图一滑动，这个图片跳动一下，当然这个也是可以的，做个简单的也还是可以的，然后下面再加个什么雷达效果什么的。

代码在最后说明里面，下载自己看看，欢迎提出意见，别忘了用之前配置你的AppKey。

## 最后说明

这只是一个小demo而已，根据自己项目的实际情况可以自己进行封装更多功能。我将这个小demo放在这里，如果有一起学习的可以交流<>。


