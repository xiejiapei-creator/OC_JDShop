//
//  CreateDatabase.h
//  ucareshop
//
//  Created by liushuting on 2019/9/10.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import <Foundation/Foundation.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

NS_ASSUME_NONNULL_BEGIN

/**
 * <#类注释，说明类的功能#>
 * @note <#额外说明的注意项，说明一些需要注意的地方，没有可取消此项。#>
 */
@interface CreateDatabase : NSObject

- (BOOL) createTable;
- (NSString *) selectData : (NSString *) remoteUrl;
- (BOOL) deleteData : (NSString *) remoteUrl;
- (BOOL) addData : (NSString *) imageUrl remoteUrl : (NSString *) remoteUrl;

@end

NS_ASSUME_NONNULL_END
