//
//  CreateDatabase.m
//  ucareshop
//
//  Created by liushuting on 2019/9/10.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "CreateDatabase.h"
#import <fmdb/FMDB.h>

#pragma mark - @class 

#pragma mark - 常量

#pragma mark - 枚举

@interface CreateDatabase ()

#pragma mark - 私有属性

@property (nonatomic, strong, readwrite) FMDatabase *db;
@property (nonatomic, strong, readwrite) FMDatabaseQueue *queue;

@end

@implementation CreateDatabase

//方法列表使用pragma分组，并遵守如下次序, 且# pragma mark - 与上下各添加一个空行
#pragma mark - Life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
      NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
      NSString *path = [docPath stringByAppendingString:@"/ucareshop.db"];
      NSURL *url = [NSURL URLWithString:path];
        NSLog(@"%@", url);
      _queue = [FMDatabaseQueue databaseQueueWithURL:url];
      _db = [FMDatabase databaseWithURL:url];
      if (![_db open]) {
          NSLog(@"fail to open database");
      }
    }
    return self;
}

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods

#pragma mark - Getters and Setters

- (BOOL) createTable {
    [_db open];
    NSString *sql = @"CREATE TABLE IF NOT EXISTS Image (remote_url text PRIMARY KEY NOT NULL, image_url text NOT NULL)";
    BOOL success = [_db executeUpdate:sql];
    if (!success || [_db hadError]) {
        [_db close];
        return NO;
    } else {
        [_db close];
        return YES;
    }
}

- (NSString *) selectData : (NSString *) remoteUrl {
    [_db open];
    NSString *imageUrl = [[NSString alloc]init];
    FMResultSet *userResult = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM image where remote_url = '%@';", remoteUrl]];
    while ([userResult next]) {
        imageUrl = [userResult stringForColumn:@"image_url"];
    }
    [_db close];
    return imageUrl;
}

- (BOOL) deleteData : (NSString *) remoteUrl {
    [_db open];
    BOOL success = [_db executeUpdate:@"delete from image where image_url = ?", remoteUrl];
    if (!success || [_db hadError]) {
        [_db close];
        return NO;
    } else {
        [_db close];
        return YES;
    }
}

- (BOOL) addData  : (NSString *) imageUrl remoteUrl : (NSString *) remoteUrl {
    [_db open];
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        [_db executeUpdate:@"INSERT INTO image ('image_url','remote_url') VALUES (?,?);", imageUrl ,remoteUrl];
    }];
    if ([_db hadError]) {
        [_db close];
        return NO;
    } else {
        [_db close];
        return YES;
    }
}

@end
