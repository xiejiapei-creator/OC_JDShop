//
//  MessageModel.h
//  ucareshop
//
//  Created by 谢佳培 on 2019/9/20.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageModel : NSObject
@property (nonatomic, assign) NSInteger messageId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) NSInteger readStatus;
@end

NS_ASSUME_NONNULL_END
