//
//  ViewController.m
//  GDAddressSelected
//
//  Created by Dry on 2017/8/2.
//  Copyright © 2017年 Dry. All rights reserved.
//


#import "ViewController.h"
#import "AddressSelectedController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    AddressSelectedController *addressSearchController = [[AddressSelectedController alloc] init];
    addressSearchController.completeBlock = ^(DDLocationReGeocode *reGeocode, NSError *error) {
        
        
        NSLog(@"%@,%@,%f,%f",reGeocode.name,reGeocode.address,reGeocode.coordinate.latitude,reGeocode.coordinate.longitude);
    };
    addressSearchController.currentCoordinate = CLLocationCoordinate2DMake(39.9087569028,116.3973784447);
    [self.navigationController pushViewController:addressSearchController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
