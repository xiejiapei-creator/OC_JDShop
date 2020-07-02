//
//  SettingViewController.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/26.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "SettingViewController.h"
#import "HeadTableViewCell.h"
#import "IdTableViewCell.h"
#import "NameTableViewCell.h"
#import "EmailTableViewCell.h"
#import "SexTableViewCell.h"
#import "ChangePasswordTableViewCell.h"
#import "ChangePasswordViewController.h"
#import "CancellationTableViewCell.h"
#import "HomeViewController.h"
#import "UITextField+LXDValidate.h"
#import "ShowAlertInfoTool.h"
#import "URLRequest.h"
#import "HomeViewController.h"
#import <AFNetworking.h>
#import <UIKit+AFNetworking.h>
#import <MBProgressHUD.h>
#import "MBProgressHUD+PD.h"
#import <Masonry/Masonry.h>
#import "AppDelegate.h"

#pragma mark - @class

#pragma mark - 常量

#define boundary @"AaB03x" //设置边界 参数可以随便设置

#pragma mark - 枚举

@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

#pragma mark - 私有属性

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImagePickerController *pickerController;
@property (nonatomic, strong) HeadTableViewCell *headTableViewCell;
@property (nonatomic, strong) NameTableViewCell *nameCell;
@property (nonatomic, strong) EmailTableViewCell *emailCell;
@property (nonatomic, strong) SexTableViewCell *sexCell;

//默认值
@property (nonatomic, strong) URLRequest *urlRequest;
@property (nonatomic, strong) NSDictionary *userDetailInfo;
@property (nonatomic) NSInteger telephone;
@property (nonatomic, readwrite) NSString *nickname;
@property (nonatomic, readwrite) NSString *email;
//更新值
@property (nonatomic, strong) URLRequest *updateURLRequest;
@property (nonatomic, strong) NSDictionary *updateUserDetailInfo;
@property (nonatomic) NSString *updateTelephone;
@property (nonatomic, readwrite) NSString *updateNickname;
@property (nonatomic, readwrite) NSString *updateEmail;


//相册
@property (nonatomic) NSOperationQueue *queue;
@property (nonatomic) HeadTableViewCell *headCell;
@property (nonatomic) NSString *headPath;
@property (nonatomic) NSString *iconImageStr;

@end

@implementation SettingViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationbar];
    [self createSubViews];
    [self createSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.nameCell.nameTextField.delegate = self;
    self.emailCell.emailTextField.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.nameCell.nameTextField.delegate = nil;
    self.emailCell.emailTextField.delegate = nil;
    [self.view endEditing:YES];
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

//上传头像
- (void)tapImageHead:(id)sender{
    //初始化pickerController
    self.pickerController = [[UIImagePickerController alloc] init];
    self.pickerController.view.backgroundColor = [UIColor orangeColor];
    self.pickerController.delegate = self;
    self.pickerController.allowsEditing = YES;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"alert controller cancel");
    }];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.pickerController animated:YES completion:nil];//让相机页面出来
        } else {
            [self alertInfo];
        }
    }];
    UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            self.pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.pickerController animated:YES completion:nil];//让相机页面出来
        } else {
            [self alertInfo];
        }
    }];
    [alertController addAction:takePhotoAction];
    [alertController addAction:photoLibraryAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
//保存设置
- (void)save:(id)sender {
    
    if (self.updateEmail && self.updateNickname && ![self.updateNickname  isEqual: @""] && ![self.updateEmail  isEqual: @""]) {
        
        if ([self.nameCell.nameTextField validateTextCount] && [self.emailCell.emailTextField validateEmail] ) {
            NSInteger sexIndex = [self.sexCell.sexSegmentedControl selectedSegmentIndex] + 1;
            NSString *sexString = [NSString stringWithFormat:@"%ld",(long)sexIndex];
            
            //更新数据到数据库
            NSArray *keysArr = [[NSArray alloc] initWithObjects:@"nickname",@"sex",@"email", nil];
            NSArray *valuesArr = [[NSArray alloc] initWithObjects: self.updateNickname,sexString,self.updateEmail, nil];
            NSDictionary *dict = [NSDictionary dictionaryWithObjects:valuesArr forKeys:keysArr];
            
            self.updateURLRequest = [[URLRequest alloc] init];//对象一定要初始化
            __weak SettingViewController *weakSelf = self;
            self.updateURLRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
                    NSInteger errorStatusCode = [content[@"code"] integerValue];
                    if (errorStatusCode == 1) {
                        NSDictionary *dict = content[@"content"];
                        NSInteger statusCode = [dict[@"code"] integerValue];
                        if (statusCode == 1) {
                            //上传头像
                            [weakSelf postIconImage];
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }
                        if (statusCode == 2) {
                            [ShowAlertInfoTool alertSpecialInfo:NameUsedErrorInfo viewController:weakSelf];
                        }
                        if (statusCode == 3) {
                            [ShowAlertInfoTool alertSpecialInfo:EmailUsedErrorInfo viewController:weakSelf];
                        }
                    } else {
                        [ShowAlertInfoTool alertSpecialInfo:FailLogin viewController:weakSelf];
                        NSLog(@"%@",content[@"msg"]);
                    }
            };
            [self.updateURLRequest startRequest:dict pathUrl:@"/member/updateMemberInfo"];
        } else {
            [ShowAlertInfoTool alertSpecialInfo:InputErrorInfo viewController:self];
        }
    } else {
        [ShowAlertInfoTool alertSpecialInfo:EmptyInfo viewController:self];
    }
}
//注销
- (void)cancellation {
    
    [self cancel];
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"uid.plist"];
    NSMutableDictionary *plistDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    [plistDict setObject:@(0) forKey:@"statusCode"];
    [plistDict setObject:@"" forKey:@"uid"];
    [plistDict writeToFile:filePath atomically:YES];
   
    
    
    [self.navigationController popViewControllerAnimated:NO];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UITabBarController *tab = (UITabBarController *)delegate.window.rootViewController;
    tab.selectedIndex = 0;
    delegate.shoppingCartNavigationController.tabBarItem.badgeValue = @"0";
}

#pragma mark - UITableViewDataSource

//节数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 5;
    } else {
        return 2;
    }
}
//每一个分组下对应的tableview高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 130;
        }
    }
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;//设置为0不起作用
}
//设置每行对应的cell（展示的内容）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                self.headCell = [tableView dequeueReusableCellWithIdentifier:@"userinfo"];
                if (!self.headCell) {
                    self.headCell = [[HeadTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userinfo"];
                }
                if (self.headPath.length > 0) {
                    self.headCell.profileimageView.image = [self getImage:self.headPath];
                } else {
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.userDetailInfo[@"imageUrl"]]];
                    self.headCell.profileimageView.image = [UIImage imageWithData:data];
                }
                [self.headCell.changeImageButton addTarget:self action:@selector(tapImageHead:) forControlEvents:UIControlEventTouchUpInside];
                self.headCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return self.headCell;
            }
            case 1: {
                IdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
                if (!cell) {
                    cell = [[IdTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
                }
                cell.phoneNumberLabel.text = self.userDetailInfo[@"telephone"];//15600009999
                return cell;
            }
            case 2: {
               self.nameCell = [tableView dequeueReusableCellWithIdentifier:@"name"];
                if (!self.nameCell) {
                    self.nameCell = [[NameTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"name"];
                }
                self.nameCell.nameTextField.text = self.userDetailInfo[@"nickname"];//呵呵
                self.nameCell.nameTextField.delegate = self;
                self.nameCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return self.nameCell;
            }
            case 3: {
                self.emailCell = [tableView dequeueReusableCellWithIdentifier:@"email"];
                if (!self.emailCell) {
                    self.emailCell = [[EmailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"email"];
                }
                self.emailCell.emailTextField.text = self.userDetailInfo[@"email"];//1234567@qq.com
                self.emailCell.emailTextField.delegate = self;
                self.emailCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return self.emailCell;
            }
            case 4: {
                self.sexCell = [tableView dequeueReusableCellWithIdentifier:@"sex"];
                if (!self.sexCell) {
                    self.sexCell = [[SexTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sex"];
                }
                return self.sexCell;
            }
            default:
                return nil;
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0: {
                ChangePasswordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"changePassword"];
                if (!cell) {
                    cell = [[ChangePasswordTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"changePassword"];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//右指示器
                return cell;
            }
            case 1: {
                CancellationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cancellation"];
                if (!cell) {
                    cell = [[CancellationTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cancellation"];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//右指示器
                return cell;
            }
            default:
                return nil;
                break;
        }
    }    
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        ChangePasswordViewController *changePasswordViewController = [[ChangePasswordViewController alloc] init];
        changePasswordViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:changePasswordViewController animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self cancellation];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertController *failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要退出登录状态吗？" preferredStyle:UIAlertControllerStyleAlert];
        [failController addAction:okAction];
        [failController addAction:cancelAction];
        [self presentViewController:failController animated:YES completion:nil];
    }
}

#pragma mark - UIOtherComponentDelegate

#pragma mark - UIImagePickerControllerDelegate

//用户点击取消退出picker时候调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%@",picker);
    }];
}
//用户选中图片时调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    //获得可编辑图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //给头像赋予图片
    self.headCell.profileimageView.image = image;
    //压缩图片
    UIImage *iconImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(200, 200)];
    //保存图片至本地,应该在提交成功后再保存到沙盒，下次进来直接去沙盒路径取
    [self saveImage:iconImage withName:@"seticonImage.jpg"];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // 创建：graphics image context
    UIGraphicsBeginImageContext(newSize);
    // 在context中用新size来进行绘图
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // 获取绘制后的新图片
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束绘制
    UIGraphicsEndImageContext();
    // 返回新图片
    return newImage;
}

//图片质量压缩到某一范围内，这里压缩递减比二分的运行时间长，二分可以限制下限。
- (UIImage *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength{
    //首先判断原图大小是否在要求内，如果满足要求则不进行压缩，over
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    //原图大小超过范围，先进行“压处理”，这里 压缩比 采用二分法进行处理，6次二分后的最小压缩比是0.015625，已经够小了
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //判断“压处理”的结果是否符合要求，符合要求就over
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    //缩处理，直接用大小的比例作为缩处理的比例进行处理，因为有取整处理，所以一般是需要两次处理
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        //获取处理后的尺寸
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        //通过图片上下文进行处理图片
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //获取处理后图片的大小
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (self.nameCell.nameTextField == textField) {
        self.updateNickname = @"";
    }
    if (self.emailCell.emailTextField == textField) {
        self.updateEmail = @"";
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (self.nameCell.nameTextField == textField) {
        self.updateNickname = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    if (self.emailCell.emailTextField == textField) {
        self.updateEmail = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    return YES;
}

//获取编辑完成后的内容
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.nameCell.nameTextField == textField) {
        if (textField.validateTextCount) {
            self.updateNickname = textField.text;
        } else {
            [ShowAlertInfoTool alertSpecialInfo:NameWordNumberErrorInfo viewController:self];
        }
    }
    if (self.emailCell.emailTextField == textField) {
        if (textField.validateEmail) {
            self.updateEmail = textField.text;
        } else {
            [ShowAlertInfoTool alertValidate:EmailFormatErrorInfo viewController:self];
        }
    }
}

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods
// 配置导航栏
- (void)configureNavigationbar {
    self.title = @"个人信息";
    
    self.view.backgroundColor = [UIColor whiteColor];
}

// 添加子视图
- (void)createSubViews {
    //建表
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.bounces = NO;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.showsVerticalScrollIndicator = NO;//不显示右侧滑块
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//分割线
    self.tableView.sectionHeaderHeight = 0.1;
    self.tableView.sectionFooterHeight = 20;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *saveBarButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = saveBarButton;
    
    //获取个人详细信息
    self.urlRequest = [[URLRequest alloc] init];
    self.userDetailInfo = [[NSDictionary alloc] init];
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setValue:@"3" forKey:@"memberId"];
    __weak SettingViewController *weakSelf = self;
    self.urlRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSInteger errorStatusCode = [content[@"code"] integerValue];
        if (errorStatusCode == 1) {
            NSDictionary *dict = content[@"content"];
            weakSelf.userDetailInfo = dict[@"re"];
            weakSelf.updateEmail = weakSelf.userDetailInfo[@"email"];
            weakSelf.updateNickname = weakSelf.userDetailInfo[@"nickname"];
            weakSelf.sexCell.sexSegmentedControl.selectedSegmentIndex = [self.userDetailInfo[@"sex"] integerValue] - 1;//1
            [weakSelf.tableView reloadData];
        } else {
            NSLog(@"%@",content[@"msg"]);
        }
    };
    [self.urlRequest startRequest:tempDict pathUrl:@"/member/getMemberInfo"];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}







// 相册警告信息
- (void)alertInfo {
    UIAlertController *failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置-->隐私-->照片,中开启本应用的相机访问权限" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"alert controller cancel");
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"alert controller ok");
    }];
    [failController addAction:okAction];
    [failController addAction:cancelAction];
    [self presentViewController:failController animated:YES completion:nil];
}
//- 保存图片至沙盒（应该是提交后再保存到沙盒,下次直接去沙盒取）
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    //在本地资源的情况下，优先使用 PNG格式文件，如果资源来源于网络，最好采用JPEG 格式文件
    NSData *imageData = UIImagePNGRepresentation(currentImage);
    // 获取沙盒目录
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullPath = [documentPath stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    // 获得图片路径
    self.headPath = fullPath;
}
//从本地沙盒取得图片
- (UIImage *)getImage:(NSString *)urlStr {
    return [UIImage imageWithContentsOfFile:urlStr];
}
//上传头像
- (void)postIconImage {
    
    URLRequest *requestForPostIcon = [[URLRequest alloc] init];
    //一、构建URL,作为头像的上传地址
    NSString *urlStr = [requestForPostIcon requestForProfileImage:nil pathUrl:@"/member/updateImage"];
    //二、将图片转化为NSData
    //在本地资源的情况下，优先使用 PNG格式文件，如果资源来源于网络，最好采用JPEG 格式文件
    NSData *imageData = UIImageJPEGRepresentation([self getImage:self.headPath], 0.5);
    //三、POST
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //@"file"字段非常关键，需要设置为需要上传参数的字段
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"iconImage.jpg" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:error.localizedDescription];
    }];
}
- (void)cancel {
    URLRequest *urlRequestForCancel = [[URLRequest alloc] init];
    urlRequestForCancel.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSInteger errorStatusCode = [content[@"code"] integerValue];
        if (errorStatusCode == 1) {
            NSLog(@"注销成功");
        } else {
            NSLog(@"%@",content[@"msg"]);
        }
    };
    [urlRequestForCancel startRequest:nil pathUrl:@"/home/logout"];
}

#pragma mark - Getters and Setters


@end
