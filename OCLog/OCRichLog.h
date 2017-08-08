//
//  OCRichLog.h
//  OCRichLog
//
//  Created by Lei Huang on 15/12/2016.
//  Copyright © 2016 Lei Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

//log level
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
	@brief  init log and try to catch crash callback
 */
+ (void)logInitial;

/**
	@brief set log model to Debug or Release(default is debug model)
 */
+ (void)setDebug:(BOOL)isDebug;

/**
	@brief set log level (default is LOGLEVELD)
	@param level level
 */
+ (void)setLogLevel:(OCRichLogLevel)level;

/**
	@brief catch App crash
	@param exception app exceptions
 */
+ (void)logCrash:(NSException *)exception;

/**
	@brief verbose log
	@param format log content
 */
+ (void)logV:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

/**
	@brief debug log
	@param format log content
 */
+ (void)logD:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

/**
	@brief info log
	@param format log content
 */
+ (void)logI:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

/**
	@brief warning log
	@param format log content
 */
+ (void)logW:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

/**
	@brief error log
	@param format log content
 */
+ (void)logE:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

@end
