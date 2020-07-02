//
//  ClassifyViewController.m
//  ucareshop
//
//  Created by liushuting on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "ClassifyViewController.h"
#import "ViewController.h"
#import "ClassifyTableViewCell.h"
#import "classifyTableModel.h"
#import "LoginViewController.h"
#import "classifyCollectionModel.h"
#import "ClassifyCollectionViewCell.h"
#import "CommodityDetailViewController.h"
#import "SearchHotContentViewController.h"
#import <UIImageView+WebCache.h>
#import <ChameleonFramework/Chameleon.h>
#import "URLRequest.h"
#import "CreateDatabase.h"
#import "Masonry.h"

#pragma mark - @class

#pragma mark - 常量

static NSString *tableIdentifier = @"classifyTable";
static NSString *collectionIdentifier = @"classifyCollection";

#pragma mark - 枚举

@interface ClassifyViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

#pragma mark - 私有属性

@property (nonatomic, strong, readwrite) UITableView *classifyTable;
@property (nonatomic, strong, readwrite) UICollectionView *classifyCollection;
@property (nonatomic, assign, readwrite) NSInteger index;
@property (nonatomic, strong, readwrite) NSString *typeId;
@property (nonatomic, strong, readwrite) UIView *rightBorderOfTable;
@property (nonatomic, strong, readwrite) UIView *topBorderOfTable;
@property (nonatomic, strong, readwrite) URLRequest *urlRequest;
@property (nonatomic, strong, readwrite) URLRequest *commodityRequest;
@property (nonatomic, strong, readwrite) CreateDatabase *dataBase;
@property (nonatomic, strong, readwrite) NSArray <classifyTableModel *> *classifyData;
@property (nonatomic, strong, readwrite) NSArray <classifyCollectionModel *> *collectionData;
@property (nonatomic, strong, readwrite) NSURLSession *URLSession;
@property (nonatomic, strong, readwrite) NSMutableDictionary *imageCacheDict;
@end

@implementation ClassifyViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationbar];
    [self createSubViews];
    [self createSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createData];
    self.dataBase = [[CreateDatabase alloc]init];
    [self.dataBase createTable];
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

- (void)message {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"uid.plist"];
    NSDictionary *plistDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    NSInteger statusCode = [plistDict[@"statusCode"] integerValue];
    
    if (statusCode == 1) {
        ViewController *notificationViewController = [[ViewController alloc] init];
        notificationViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:notificationViewController animated:YES];
    } else {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        loginViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}
- (void)search {
    SearchHotContentViewController *searchHotContentViewController = [[SearchHotContentViewController alloc] init];
    searchHotContentViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchHotContentViewController animated:YES];
}

- (void) jumpCommodityDetail : (NSString *) commodityId {
    CommodityDetailViewController *commodityDetail = [CommodityDetailViewController new];
    commodityDetail.hidesBottomBarWhenPushed = YES;
    commodityDetail.commodityID = commodityId;
    [self.navigationController pushViewController:commodityDetail animated:YES];
}

#pragma mark - UITextFieldDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.classifyData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassifyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier forIndexPath:indexPath];
    classifyTableModel *data = self.classifyData[indexPath.row];
    cell.classifyName.text = data.typeName;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    //id
    cell.typeId = data.typeId;
    cell.cellIndex = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell.cellIndex == 0) {
        cell.topBorder.alpha = 1.0;
        cell.rightBorder.alpha = 0.0;
        cell.selected = YES;
        cell.leftBorder.hidden = NO;
        cell.classifyName.textColor = [UIColor colorWithHexString:@"#000000"];
        cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    } else {
        //第零个重置
        cell.topBorder.alpha = 0.0;
        cell.rightBorder.alpha = 1.0;
        cell.selected = NO;
        cell.leftBorder.hidden = YES;
        cell.classifyName.textColor = [UIColor colorWithHexString:@"#9a9a9a"];
        cell.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassifyTableViewCell *cell = [self.classifyTable cellForRowAtIndexPath:indexPath];
    //获取到当前可见范围内的所有cell
    NSArray <ClassifyTableViewCell *> *cellArray = [self.classifyTable visibleCells];
    for (ClassifyTableViewCell *cell in cellArray) {
        cell.classifyName.textColor = [UIColor colorWithHexString:@"#9d9d9d"];
        cell.rightBorder.alpha = 1.0;
        cell.leftBorder.hidden = YES;
        cell.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
    }
    cell.classifyName.textColor = [UIColor colorWithHexString:@"#000000"];
    cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    cell.rightBorder.alpha = 0.0;
    cell.leftBorder.hidden = NO;
    self.index = cell.cellIndex;
    self.typeId = cell.typeId;
    [self createDataById];
    [self.classifyCollection reloadData];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0) {
    ClassifyTableViewCell *cell = [self.classifyTable cellForRowAtIndexPath:indexPath];
    cell.classifyName.textColor = [UIColor colorWithHexString:@"#9a9a9a"];
    cell.leftBorder.hidden = YES;
    cell.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
    cell.rightBorder.alpha = 1.0;
}

#pragma mark - UIOtherComponentDelegate

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionData.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ClassifyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionIdentifier forIndexPath:indexPath];
    classifyCollectionModel *data = self.collectionData[indexPath.item];
    cell.commodityName.text = [NSString stringWithFormat:@"%@", data.commodityName];
    cell.commodityId = data.commodityId;
    cell.commodityImage.image = [UIImage imageNamed:@"占位"];
    NSArray *arr = [data.commodityImageName componentsSeparatedByString:@";"];
//    [cell.commodityImage sd_setImageWithURL:arr[0]];
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970]*1000;
    NSInteger t = time;
    NSString *imageURL = arr[0];
    self.imageCacheDict[imageURL] = [NSURL URLWithString:[self.dataBase selectData:[imageURL lastPathComponent]]];
    NSURL *cachedImageURL = self.imageCacheDict[imageURL];
    NSArray *timeArr = [[cachedImageURL.path lastPathComponent] componentsSeparatedByString:@"+"];
    NSLog(@"%ld", [timeArr[1] integerValue]);
    BOOL isVal = (t - [timeArr[1] integerValue]) < 24 *3600;
    if (cachedImageURL && isVal) {
        //hit命中
        NSLog(@"hit");
        cell.commodityImage.image = [self imageForURL:cachedImageURL];
    } else if (isVal == NO && [timeArr[1] integerValue] != 0) {
        //无效
        NSLog(@"invalide");
        [self.imageCacheDict removeObjectForKey:imageURL];
        [self.dataBase deleteData:[imageURL lastPathComponent]];
        [self downloadImage:imageURL forCell:cell];
    } else {
        //miss缺失
        NSLog(@"miss");
        [self downloadImage:imageURL forCell:cell];
    }
    cell.primePrice.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%d",@"¥" , data.primePrice] attributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle), NSStrikethroughColorAttributeName: [UIColor redColor]}];
    cell.commodityPrice.text = [NSString stringWithFormat:@"%@%d",@"¥" , data.commodityPrice];
    cell.layer.borderColor = [UIColor colorWithHexString:@"#f9f9f9"].CGColor;
    cell.layer.borderWidth = 1.0;
    cell.layer.cornerRadius = 8;
    [cell updateCommodityname];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize viewSize = self.view.bounds.size;
    CGFloat width = viewSize.width - 200;
    return CGSizeMake(width/2, 150);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    classifyCollectionModel *data = self.collectionData[indexPath.item];
    [self jumpCommodityDetail:data.commodityId];
}

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods
// 配置导航栏
- (void)configureNavigationbar {
    self.title = @"分类";
    
    self.view.backgroundColor = UIColor.whiteColor;
    UIImage *message = [UIImage imageNamed:@"home_homeViewController_rightBarButtonItem_enable"];
    UIImage *search = [UIImage imageNamed:@"home_homeViewController_leftBarButtonItem_enable"];
    
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithImage:search style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    UIBarButtonItem *cartButtonItem = [[UIBarButtonItem alloc] initWithImage:message style:UIBarButtonItemStylePlain target:self action:@selector(message)];
    self.navigationItem.rightBarButtonItem = cartButtonItem;
    self.navigationItem.leftBarButtonItem = searchButtonItem;
}

// 添加子视图
- (void)createSubViews {
    self.URLSession = [NSURLSession sharedSession];
    self.imageCacheDict = [NSMutableDictionary dictionary];
    self.urlRequest = [URLRequest new];
    self.commodityRequest = [URLRequest new];
    self.classifyTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.classifyTable.delegate = self;
    self.classifyTable.dataSource = self;
    self.classifyTable.scrollEnabled = NO;
    self.classifyTable.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
    self.classifyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.classifyTable registerClass:[ClassifyTableViewCell class] forCellReuseIdentifier:tableIdentifier];
    [self.view addSubview:self.classifyTable];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(300,300);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.classifyCollection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.classifyCollection registerClass:[ClassifyCollectionViewCell class] forCellWithReuseIdentifier:collectionIdentifier];
    self.classifyCollection.dataSource = self;
    self.classifyCollection.delegate = self;
    self.classifyCollection.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.classifyCollection];
    
    self.topBorderOfTable = [[UIView alloc]initWithFrame:CGRectZero];
    self.topBorderOfTable.backgroundColor = UIColor.lightGrayColor;
    [self.classifyTable addSubview:self.topBorderOfTable];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.classifyTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.left.equalTo(self.view.mas_left).mas_offset(5);
        make.width.equalTo(@150);
    }];
    [self.classifyCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(5);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.left.equalTo(self.classifyTable.mas_right).mas_offset(10);
        make.right.equalTo(self.view).mas_offset(-10);
    }];
}

- (void) createData {
    //品类信息
    __weak ClassifyViewController *weakself = self;
    NSMutableArray <classifyTableModel *> * mutableData = [NSMutableArray array];
    NSMutableArray <classifyCollectionModel *> * mutableCollectionData = [NSMutableArray array];
    self.urlRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
            if ([content[@"code"] intValue] == 1) {
                for (NSDictionary *dict in content[@"content"][@"re"][@"category"]) {
                    classifyTableModel *data = [classifyTableModel new];
                    data.typeName = dict[@"name"];
                    data.typeId = dict[@"id"];
                    [mutableData addObject:data];
                }
                for (NSDictionary *dict in content[@"content"][@"re"][@"goodsDTOList"]) {
                    classifyCollectionModel *collectionData = [classifyCollectionModel new];
                    collectionData.commodityName = dict[@"goodsName"];
                    collectionData.commodityId = dict[@"goodsId"];
                    if ([dict[@"discountPrice"] isKindOfClass:[NSNull class]]) {
                        collectionData.commodityPrice = 0;
                    } else {
                        collectionData.commodityPrice = [dict[@"discountPrice"] intValue];
                    }
                    if ([dict[@"salePrice"] isKindOfClass:[NSNull class]]) {
                        collectionData.primePrice = 0;
                    } else {
                        collectionData.primePrice = [dict[@"salePrice"] intValue];
                    }
                    collectionData.commodityImageName = dict[@"picUrl"];
                    [mutableCollectionData addObject:collectionData];
                }
                weakself.classifyData = mutableData;
                [weakself drawLeftLine:weakself.classifyData.count];
                weakself.collectionData = mutableCollectionData;
                [weakself.classifyCollection reloadData];
                [weakself.classifyTable reloadData];
            }
    };
    [self.urlRequest startRequest:nil pathUrl:@"/getGoodsCategory"];
}

- (void) createDataById {
    __weak ClassifyViewController *weakself = self;
    NSMutableArray <classifyCollectionModel *> * mutableCollectionData = [NSMutableArray array];
    NSMutableDictionary *temp = [NSMutableDictionary dictionary];
    [temp setObject:[NSString stringWithFormat:@"%@", self.typeId] forKey:@"id"];
    self.commodityRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
        if ([content[@"code"] intValue] == 1) {
            for (NSDictionary *dict in content[@"content"][@"re"]) {
                classifyCollectionModel *collectionData = [classifyCollectionModel new];
                collectionData.commodityName = dict[@"goodsName"];
                collectionData.commodityId = dict[@"goodsId"];
                if ([dict[@"salePrice"] isKindOfClass:[NSNull class]]) {
                    collectionData.commodityPrice = 0;
                } else {
                    collectionData.commodityPrice = [dict[@"discountPrice"] intValue];
                }
                if ([dict[@"salePrice"] isKindOfClass:[NSNull class]]) {
                    collectionData.primePrice = 0;
                } else {
                    collectionData.primePrice = [dict[@"salePrice"] intValue];
                }
                collectionData.commodityImageName = dict[@"picUrl"];
                [mutableCollectionData addObject:collectionData];
            }
            weakself.collectionData = mutableCollectionData;
            [weakself.classifyCollection reloadData];
        }
    };
    [self.commodityRequest startRequest:temp pathUrl:@"/getGoodsByCategory"];
}

- (void) drawLeftLine : (NSInteger) length {
    CGSize size = self.view.bounds.size;
    CGFloat height = size.height - length * 50;
    if (size.height <= 50 * length) {
        self.classifyTable.scrollEnabled = YES;
        height = 0;
    } else {
        self.classifyTable.scrollEnabled = NO;
    }
    //table的右边框
    self.rightBorderOfTable = [[UIView alloc]initWithFrame:CGRectMake(149, length * 50, 1, height)];
    self.rightBorderOfTable.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
    self.rightBorderOfTable.alpha = 1.0;
    [self.classifyTable addSubview:self.rightBorderOfTable];
}

//下载（异步加载）
- (void)downloadImage:(NSString *)imageURL forCell:(ClassifyCollectionViewCell *)cell {
    //下载远端图片数据
    __weak ClassifyViewController *weakself = self;
    NSURL *downloadURL = [NSURL URLWithString:imageURL];
    NSURLSessionDownloadTask *task = [self.URLSession downloadTaskWithURL:downloadURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    NSURL *cachedImageURL = [self writeImageToCacheFromLocation:location forDownloadURL:downloadURL];
    dispatch_async(dispatch_get_main_queue(), ^{
            //沙盒的路径暂存
            weakself.imageCacheDict[imageURL] = cachedImageURL;
            //下载到数据库中的路径
            [weakself.dataBase addData:[NSString stringWithFormat:@"%@", cachedImageURL] remoteUrl:[NSString stringWithFormat:@"%@", [imageURL lastPathComponent]]];
            cell.commodityImage.image = [self imageForURL:cachedImageURL];
        });
    }];
    [task resume];
}
//从URL中读取图片
- (UIImage *)imageForURL:(NSURL *)imageURL {
    NSData *data = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}
//写缓存（存储到沙盒中，数据库中之存放路径）
- (NSURL *)writeImageToCacheFromLocation:(NSURL *)location forDownloadURL:(NSURL *)downloadURL {
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970]*1000;
    NSInteger t = time;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applocationSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *imageDirPath = [applocationSupportURL.path stringByAppendingPathComponent:@"image"];
    if (![fileManager fileExistsAtPath:imageDirPath]) {
        [fileManager createDirectoryAtPath:imageDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fileName = [downloadURL.path lastPathComponent];
    NSString *imagePath = [imageDirPath stringByAppendingPathComponent:fileName];
    //给路径传一个有效时间
    NSString *imagePathWithTime = [imagePath stringByAppendingString:[NSString stringWithFormat:@"%@%ld",@"+" , t]];
    
    NSURL *imageURL = [NSURL fileURLWithPath:imagePathWithTime];
    [fileManager copyItemAtURL:location toURL:imageURL error:nil];
    return imageURL;
}


#pragma mark - Getters and Setters

@end
