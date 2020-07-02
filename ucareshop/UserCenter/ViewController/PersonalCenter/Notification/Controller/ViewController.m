//
//  ViewController.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.

#import "ViewController.h"

#import "MainView.h"

#import "MainViewModel.h"

#import <Masonry.h>

@interface ViewController ()<MainViewDelegate>

@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) MainViewModel *mainViewModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSubViews];
    [self.mainView getDataList];
    [self.mainViewModel loadTableDatas];
}

#pragma mark - MainViewDelegate
- (void)tableView:(UITableView *)tableView checkCell:(NSInteger)index {
    
}

- (void)setupSubViews {
    
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

#pragma mark - Setter & Getter
- (MainView *)mainView {
    if (!_mainView) {
        _mainView = [[MainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _mainView;
}

- (MainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[MainViewModel alloc] init];
    }
    return _mainViewModel;
}

@end
