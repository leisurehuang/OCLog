//
//  OCRichLog.h
//  OCRichLog
//
//  Created by Lei Huang on 15/12/2016.
//  Copyright © 2016 Lei Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

//日志等级
typedef enum {
    LOGLEVELV = 0,
    LOGLEVELD = 1,
    LOGLEVELI = 2,
    LOGLEVELW = 3,
    LOGLEVELE = 4,
} OCRichLogLevel;


#define OCRichLogV(...) [OCRichLog logV:@"Method:%s Line:%d: %@\n\n",__PRETTY_FUNCTION__ ,__LINE__, [NSString stringWithFormat:__VA_ARGS__]];

#define OCRichLogD(...) [OCRichLog logD:@"Method:%s Line:%d: %@\n\n",__PRETTY_FUNCTION__ ,__LINE__, [NSString stringWithFormat:__VA_ARGS__]];

#define OCRichLogI(...) [OCRichLog logI:@"Method:%s Line:%d: %@\n\n",__PRETTY_FUNCTION__ ,__LINE__, [NSString stringWithFormat:__VA_ARGS__]];

#define OCRichLogW(...) [OCRichLog logW:@"Method:%s Line:%d: %@\n\n",__PRETTY_FUNCTION__ ,__LINE__, [NSString stringWithFormat:__VA_ARGS__]];

#define OCRichLogE(...) [OCRichLog logE:@"Method:%s Line:%d: %@\n\n",__PRETTY_FUNCTION__ ,__LINE__, [NSString stringWithFormat:__VA_ARGS__]];


void uncaughtExceptionHandler(NSException *exception);


@interface OCRichLog : NSObject

/**
	@brief 初始化log模块并添加捕捉crash的callback
 */
+ (void)logInitial;

/**
	@brief 设置log模块模式，Debug or Release(默认debug模式)
 */
+ (void)setDebug:(BOOL)isDebug;

/**
	@brief 设置要记录的log级别(默认LOGLEVELD级别)
	@param level 要设置的log级别
 */
+ (void)setLogLevel:(OCRichLogLevel)level;

/**
	@brief 记录系统crash的Log函数
	@param exception 系统异常
 */
+ (void)logCrash:(NSException *)exception;

/**
	@brief LOGLEVELV级Log记录函数
	@param format 具体记录log的格式以及内容
 */
+ (void)logV:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

/**
	@brief LOGLEVELD级Log记录函数
	@param format 具体记录log的格式以及内容
 */
+ (void)logD:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

/**
	@brief LOGLEVELI级Log记录函数
	@param format 具体记录log的格式以及内容
 */
+ (void)logI:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

/**
	@brief LOGLEVELW级Log记录函数
	@param format 具体记录log的格式以及内容
 */
+ (void)logW:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

/**
	@brief LOGLEVELE级Log记录函数
	@param format 具体记录log的格式以及内容
 */
+ (void)logE:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

@end
