//
//  BaseTableViewCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.

#import "BaseTableViewCell.h"
#import <Masonry/Masonry.h>

@implementation BaseTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    NSString *reuseId = NSStringFromClass([self class]);
    id cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseId];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupCell];
        [self setupSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

// 子类重写该方法，设置Cell样式
- (void)setupCell
{
    
}

// 子类重写该方法，设置View
- (void)setupSubViews
{
    
}


// 子类重写该方法，设置View数据
- (void)setViewWithModel:(id)model
{
    
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
}
@end
