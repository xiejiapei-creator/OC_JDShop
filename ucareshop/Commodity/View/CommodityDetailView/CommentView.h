//
//  CommentView.h
//  ucareshop
//
//  Created by liushuting on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import <UIKit/UIKit.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

#pragma mark - block传值

typedef void (^ passMaskStatus)(BOOL maskStatus);
typedef void (^ passStarNumber)(int starNumber);

NS_ASSUME_NONNULL_BEGIN

/**
 * <#类注释，说明类的功能#>
 * @note <#额外说明的注意项，说明一些需要注意的地方，没有可取消此项。#>
 */
@interface CommentView : UIView

@property (nonatomic, copy) passMaskStatus status;
@property (nonatomic, copy) passStarNumber starNumber;
@property (nonatomic, assign, readwrite) BOOL isHidden;
@property (nonatomic, strong, readonly) UITableView *commentContentTable;
@property (nonatomic, strong, readwrite) NSDictionary *starArray;
@property (nonatomic, strong, readonly) UILabel *commentScore;
@property (nonatomic, strong, readonly) UILabel *commentNumber;
@property (nonatomic, strong, readwrite) NSString *totalNumber;
@property (nonatomic, strong, readwrite) NSString *scoreNumber;

- (void) createCommentContentData : (NSString *) commodityId;
- (void) drawLine;

@end

NS_ASSUME_NONNULL_END
