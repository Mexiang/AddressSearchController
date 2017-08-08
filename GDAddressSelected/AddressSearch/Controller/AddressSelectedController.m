//
//  AddressSelectedController.m
//  GDAddressSelected
//
//  Created by Dry on 2017/8/2.
//  Copyright © 2017年 Dry. All rights reserved.
//

#import "AddressSelectedController.h"
#import "DDMapView.h"
#import "DDSearchManager.h"

@interface AddressSelectedController ()<DDMapViewDelegate,UITableViewDataSource,UITableViewDelegate>
// 地图
@property (nonatomic, strong) DDMapView *ddMapView;
// 显示数据列表
@property (nonatomic, strong) UITableView *tableView;
// 列表数据源
@property (nonatomic, strong) NSMutableArray<__kindof DDSearchPoi *> *dataSource;

@end

@implementation AddressSelectedController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self setUpUI];
}
#pragma mark UI
- (void)setUpUI {
    [self ddMapView];

    [self tableView];
}

#pragma mark delegate
#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"AddressSelectedController_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    DDSearchPoi *poi = self.dataSource[indexPath.row];
    
    NSLog(@"poi.name :%@     poi.address:%@ ",poi.name,poi.address);
    
    cell.textLabel.text = poi.name;
    cell.detailTextLabel.text = poi.address;

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.completeBlock) {
        DDSearchPoi *poi = self.dataSource[indexPath.row];
        DDLocationReGeocode *reGeocode = [[DDLocationReGeocode alloc] init];
        reGeocode.name       = poi.name;
        reGeocode.address    = poi.address;
        reGeocode.coordinate = poi.coordinate;
        reGeocode.city       = poi.city;
        reGeocode.cityCode   = poi.cityCode;
        
        self.completeBlock(reGeocode, nil);
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark DDMapViewDelegate
// 地图区域改变完成后会调用此接口
- (void)ddMapView:(DDMapView *)ddMapView regionDidChangeAnimated:(BOOL)animated {
    //发起逆地理编码请求
    [self reGeocode:ddMapView.centerCoordinate];
}

#pragma mark private
//发起逆地理编码
- (void)reGeocode:(CLLocationCoordinate2D)coordinate {
    //逆地理编码，请求附近兴趣点数据
    [[DDSearchManager sharedManager] poiReGeocode:coordinate returnBlock:^(NSArray<__kindof DDSearchPoi *> *pois) {
        
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:pois];
        [self.tableView reloadData];
    }];
}

#pragma mark set/get
- (void)setCurrentCoordinate:(CLLocationCoordinate2D)currentCoordinate {
    _currentCoordinate = currentCoordinate;
    //如果传入了经纬度
    if (_currentCoordinate.longitude > 0 && _currentCoordinate.latitude > 0)
    {   //将地图移动至指定位置
        [self.ddMapView setCenterCoordinate:_currentCoordinate animated:NO];
    }
}
- (DDMapView *)ddMapView {
    if (!_ddMapView) {
        _ddMapView = [[DDMapView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, (ScreenHeight-NavHeight)*0.5) delegate:self];
        [self.view addSubview:_ddMapView];
    }
    return _ddMapView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (ScreenHeight-NavHeight)*0.5, ScreenWidth, (ScreenHeight-NavHeight)*0.5) style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end
