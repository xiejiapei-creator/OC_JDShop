//
//  MainTableViewCell.h
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.

#import "BaseTableViewCell.h"
#import "MessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MainTableViewCell : BaseTableViewCell

@property (nonatomic) NSMutableArray *content;

@property (nonatomic, strong, readwrite) UILabel *newsLabel;
@property (nonatomic, strong, readwrite) UILabel *topTimeLabel;
@property (nonatomic, strong, readwrite) UILabel *bottomTimeLabel;

@property (nonatomic, copy) void (^onUpdateCellHeight)(CGFloat height);
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) void (^onSelectCell)(NSIndexPath *indexPath);
@property (nonatomic, strong,nullable) MessageModel *messageModel;
@property (nonatomic) NSString *seletedContent;
@property (nonatomic, copy) void (^seletedMessageContent)(NSString *seletedContent);

@property (nonatomic) BOOL isSeletedRow;

@property (nonatomic, strong, readwrite) CAShapeLayer *maskLayer;
@property (nonatomic, strong) UIButton *buttonOpen;


- (void)setupSubViews;

@end

NS_ASSUME_NONNULL_END
