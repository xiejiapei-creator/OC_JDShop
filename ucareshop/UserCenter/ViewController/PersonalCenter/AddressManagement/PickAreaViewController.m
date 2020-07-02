//
//  PickAreaViewController.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/9/3.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "PickAreaViewController.h"
#import "URLRequest.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface PickAreaViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

#pragma mark - 私有属性

@end

@implementation PickAreaViewController

#pragma mark - Life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pickerView = [[PickerView alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationbar];
    [self createSubViews];
    [self createSubViewsConstraints];
    
    [self requestProvince];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    NSLog(@"%@ - dealloc", NSStringFromClass([self class]));
}

#pragma mark - Events

- (void)onclick:(id)sender {
    
    self.provinceName = self.seletedProvinceName;
    self.cityName = self.seletedCityName;
    self.districtName = self.seletedDistrictName;
    
    NSArray *keysArr = [[NSArray alloc] initWithObjects:@"provinceName",@"cityName",@"districtName",nil];
    NSArray *valuesArr = [[NSArray alloc] initWithObjects:self.provinceName,self.cityName,self.districtName,nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:valuesArr forKeys:keysArr];

    if (self.transBlock) {
        self.transBlock(dict);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

#pragma mark - UIOtherComponentDelegate


#pragma mark --实现协议UIPickerViewDataSource方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return (self.provinceInfoList.count);
        case 1:
            return (self.cityInfoList.count);
        case 2:
            return (self.districtInfoList.count);
        default:
            return 0;
    }
}
#pragma mark --实现协议UIPickerViewDelegate方法
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
            self.seletedProvinceName = [self.provinceInfoList objectAtIndex:row];
            return [self.provinceInfoList objectAtIndex:row];
        case 1:
            self.seletedCityName = [self.cityInfoList objectAtIndex:row];
            return [self.cityInfoList objectAtIndex:row];
        case 2:
            self.seletedDistrictName = [self.districtInfoList objectAtIndex:row];
            return [self.districtInfoList objectAtIndex:row];
        default:
            return @"";
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.seletedProvinceName = [self.provinceInfoList objectAtIndex:row];
        self.seletedProvinceCode = [self.provinceCodeList objectAtIndex:row];
        [self requestCityWithProvince:self.seletedProvinceCode];

    }
    if (component == 1) {
        self.seletedCityName = [self.cityInfoList objectAtIndex:row];
        self.seletedCityCode = [self.cityCodeList objectAtIndex:row];
        [self requestCountryWithCity:self.seletedCityCode];
    }
    if (component == 2) {
        self.seletedDistrictName = [self.districtInfoList objectAtIndex:row];
    }
}


#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods
// 配置导航栏
- (void)configureNavigationbar {
    self.title = @"选择地区";
    
    self.view.backgroundColor = [UIColor whiteColor];
}

// 添加子视图
- (void)createSubViews {
    //初始化
    self.provinceCodeList = [[NSMutableArray alloc] init];
    self.cityCodeList = [[NSMutableArray alloc] init];
    self.districtCodeList = [[NSMutableArray alloc] init];
    self.provinceInfoList = [[NSMutableArray alloc] init];
    self.cityInfoList = [[NSMutableArray alloc] init];
    self.districtInfoList = [[NSMutableArray alloc] init];
    [self.view addSubview:self.pickerView];
    [self.pickerView.pickButton addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
   
    self.pickerView.systemPickerView.delegate = self;
    self.pickerView.systemPickerView.dataSource = self;
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)requestProvince {
    URLRequest *urlRequestForProvince = [[URLRequest alloc] init];
    NSMutableDictionary *provinceDict = [[NSMutableDictionary alloc] init];
    __weak PickAreaViewController *weakSelf = self;
    [provinceDict setValue:@"0" forKey:@"superId"];
    
    urlRequestForProvince.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSInteger errorStatusCode = [content[@"code"] integerValue];
        if (errorStatusCode == 1) {
            NSDictionary *dict = content[@"content"];
            weakSelf.provinceList = [NSMutableArray arrayWithArray:dict[@"re"]];
            //获取名称
            for(NSDictionary *dict in self.provinceList) {
                [self.provinceInfoList addObject:dict[@"cityName"]];
                [self.provinceCodeList addObject:dict[@"id"]];
            }
            if (self.provinceList.count > 0) {
                [self requestCityWithProvince:self.provinceCodeList[0]];
            }
            [self.pickerView.systemPickerView reloadAllComponents];
        } else {
            NSLog(@"%@",content[@"msg"]);
        }
    };
    
    [urlRequestForProvince startRequest:provinceDict pathUrl:@"/city/getCity"];
}

//市
- (void)requestCityWithProvince:(NSString *)provinceID {
    URLRequest *urlRequestForCity = [[URLRequest alloc] init];
    NSMutableDictionary *cityDict = [[NSMutableDictionary alloc] init];
    NSString *provinceIDString = [NSString stringWithFormat:@"%@",provinceID];
    [cityDict setObject:provinceIDString forKey:@"superId"];
    __weak PickAreaViewController *weakSelf = self;
    urlRequestForCity.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSInteger errorStatusCode = [content[@"code"] integerValue];
        if (errorStatusCode == 1) {
            NSDictionary *dict = content[@"content"];
            weakSelf.cityList = [NSMutableArray arrayWithArray:dict[@"re"]];
            [self.cityInfoList removeAllObjects];
            [self.cityCodeList removeAllObjects];
            for(NSDictionary *dict in self.cityList) {
            
                [self.cityInfoList addObject:dict[@"cityName"]];
                [self.cityCodeList addObject:dict[@"id"]];
            }
            [self.pickerView.systemPickerView reloadComponent:1];
            if (self.cityCodeList.count > 0) {
                [self requestCountryWithCity:self.cityCodeList[0]];
            }
        } else {
            NSLog(@"%@",content[@"msg"]);
        }
    };
    [urlRequestForCity startRequest:cityDict pathUrl:@"/city/getCity"];
}

//县
- (void)requestCountryWithCity:(NSString *)cityID {
        URLRequest *urlRequestForDistrict = [[URLRequest alloc] init];
        NSMutableDictionary *districtDict = [[NSMutableDictionary alloc] init];
        NSString *cityIDString = [NSString stringWithFormat:@"%@",cityID];
        [districtDict setObject:cityIDString forKey:@"superId"];
        __weak PickAreaViewController *weakSelf = self;
        urlRequestForDistrict.transDataBlock = ^(NSDictionary * _Nonnull content) {
            NSInteger errorStatusCode = [content[@"code"] integerValue];
            if (errorStatusCode == 1) {
                NSDictionary *dict = content[@"content"];
                weakSelf.districtList = [NSMutableArray arrayWithArray:dict[@"re"]];
                [self.districtInfoList removeAllObjects];
                [self.districtCodeList removeAllObjects];
                for(NSDictionary *dict in self.districtList) {
                    [self.districtInfoList addObject:dict[@"cityName"]];
                    [self.districtCodeList addObject:dict[@"id"]];
                }
                [self.pickerView.systemPickerView reloadComponent:2];
            } else {
                NSLog(@"%@",content[@"msg"]);
            }
        };
        [urlRequestForDistrict startRequest:districtDict pathUrl:@"/city/getCity"];
}

#pragma mark - Getters and Setters

@end
