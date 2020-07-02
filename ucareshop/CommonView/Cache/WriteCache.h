//
//  WriteCache.h
//  ucareshop
//
//  Created by liushuting on 2019/9/29.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WriteCache : NSObject
@property (nonatomic, strong, readonly) NSMutableDictionary *imageCacheDict;
@end

NS_ASSUME_NONNULL_END
