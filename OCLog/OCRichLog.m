//
//  OCRichLog.m
//  OCRichLog
//
//  Created by Lei Huang on 15/12/2016.
//  Copyright © 2016 Lei Huang. All rights reserved.
//

#import "OCRichLog.h"
#import "OCDevice.h"

// 默认记录的日志等级为LOGLEVELD。
static OCRichLogLevel LogLevel = LOGLEVELD;



void uncaughtExceptionHandler(NSException *exception) {
    [OCRichLog logCrash:exception];
}


static NSString *logFilePath = nil;
static NSString *crateFileDay = nil;
static NSString *logDic = nil;
static NSString *crashDic = nil;
static BOOL isDebugModel = YES;

//定义删除几天前的日志
const int k_preDaysToDelLog = 3;

@interface OCRichLog ()

+ (void)logvLevel:(OCRichLogLevel)level Format:(NSString *)format VaList:(va_list)args;

+ (NSString *)stringFromLogLevel:(OCRichLogLevel)logLevel;

+ (NSString *)logFormatPrefix:(OCRichLogLevel)logLevel;

@end

@implementation OCRichLog

+ (NSString *)stringFromLogLevel:(OCRichLogLevel)logLevel {
    switch (logLevel) {
        case LOGLEVELV:
            return @"VEND";
        case LOGLEVELD:
            return @"DEBUG";
        case LOGLEVELI:
            return @"INFO";
        case LOGLEVELW:
            return @"WARNING";
        case LOGLEVELE:
            return @"ERROR";
    }
    return @"";
}

+ (NSString *)logFormatPrefix:(OCRichLogLevel)logLevel {
    return [NSString stringWithFormat:@"[%@] ", [OCRichLog stringFromLogLevel:logLevel]];
}

+ (void)logIntial {
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *nowDay = [dateFormatter stringFromDate:[NSDate date]];
    
    // create path for log file
    if (nil == logFilePath || ![nowDay isEqualToString:crateFileDay]) {
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *logDirectory = [documentsDirectory stringByAppendingString:@"/OCRichLog/log/"];
        NSString *crashDirectory = [documentsDirectory stringByAppendingString:@"/OCRichLog/crash/"];
        //create directory if it doesn't exist
        if (![[NSFileManager defaultManager] fileExistsAtPath:logDirectory])
            [[NSFileManager defaultManager] createDirectoryAtPath:logDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        if (![[NSFileManager defaultManager] fileExistsAtPath:crashDirectory])
            [[NSFileManager defaultManager] createDirectoryAtPath:crashDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        logDic = logDirectory;
        crashDic = crashDirectory;
        NSString *fileNamePrefix = [dateFormatter stringFromDate:[NSDate date]];
        crateFileDay = fileNamePrefix;
        NSString *fileName = [NSString stringWithFormat:@"OCRichLog_%@.logtraces.txt", fileNamePrefix];
        NSString *filePath = [logDirectory stringByAppendingPathComponent:fileName];
        
        logFilePath = filePath;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSString *fileHead = [NSString stringWithFormat:@"App:%@, version:%@, build:%@ \n", [OCDevice appName], [OCDevice clientVersion], [OCDevice buildVersion]];
            NSData *dataHead = [fileHead dataUsingEncoding:NSUTF8StringEncoding];
            [[NSFileManager defaultManager] createFileAtPath:filePath contents:dataHead attributes:nil];
        }
        
        //删除过期的日志
        NSDate *prevDate = [[NSDate date] dateByAddingTimeInterval:-60 * 60 * 24 * k_preDaysToDelLog];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:prevDate];
        [components setHour:0];
        [components setMinute:0];
        [components setSecond:0];
        
        //删除三天以前的日志（0点开始）
        NSDate *delDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        NSArray *logFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:logDic error:nil];
        for (NSString *file in logFiles) {
            NSString *fileName = [file stringByReplacingOccurrencesOfString:@".logtraces.txt" withString:@""];
            fileName = [fileName stringByReplacingOccurrencesOfString:@"OCRichLog_" withString:@""];
            NSDate *fileDate = [dateFormatter dateFromString:fileName];
            if (nil == fileDate) {
                continue;
            }
            if (NSOrderedAscending == [fileDate compare:delDate]) {
                [[NSFileManager defaultManager] removeItemAtPath:[logDic stringByAppendingString:file] error:nil];
            }
        }
    }
}

+ (void)setDebug:(BOOL)isDebug {
    isDebugModel = isDebug;
}

+ (void)setLogLevel:(OCRichLogLevel)level {
    LogLevel = level;
}

+ (void)logvLevel:(OCRichLogLevel)level Format:(NSString *)format VaList:(va_list)args {
    // only print in debug model
    if(isDebugModel){
        [OCRichLog logIntial];
        if (level >= LogLevel) {
            format = [[OCRichLog logFormatPrefix:level] stringByAppendingString:format];
            NSString *contentStr = nil;
            @try {
                contentStr = [[NSString alloc] initWithFormat:format arguments:args];
            }
            @catch (NSException *e) {
                contentStr = @"OCRichLog [logvLevel:ForMat:VaList] args Error!";
            }
            NSString *contentN = [contentStr stringByAppendingString:@"\n"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *content = [NSString stringWithFormat:@"%@ %@", [dateFormatter stringFromDate:[NSDate date]], contentN];
            NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:logFilePath];
            
            if (file == nil) {
                logFilePath = nil;
                [OCRichLog logIntial];
                file = [NSFileHandle fileHandleForUpdatingAtPath:logFilePath];
            }
            [file seekToEndOfFile];
            [file writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
            [file closeFile];
            NSLog(@"%@", content);
        }
    }
}

+ (void)logCrash:(NSException *)exception {
    if (nil == exception) {
        return;
    }
    [OCRichLog logIntial];
    if(isDebugModel){
        NSLog(@"CRASH: %@", exception);
        NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    }
    // Internal error reporting
    NSString *fileName = [NSString stringWithFormat:@"OCRichLog_crash_%@.log", [[NSDate date] description]];
    NSString *filePath = [crashDic stringByAppendingString:fileName];
    NSString *content = [[NSString stringWithFormat:@"CRASH: %@\n", exception] stringByAppendingString:[NSString stringWithFormat:@"Stack Trace: %@\n", [exception callStackSymbols]]];
    content = [content stringByAppendingString:[NSString stringWithFormat:@"iPhone:%@ ClientVersion:%@ OSVersion:%@", [OCDevice phoneModel], [OCDevice clientVersion], [OCDevice OSNumber]]];
    [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+ (void)logLevel:(OCRichLogLevel)level LogInfo:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    [OCRichLog logvLevel:level Format:format VaList:args];
    va_end(args);
}

+ (void)logV:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    [OCRichLog logvLevel:LOGLEVELV Format:format VaList:args];
    va_end(args);
}

+ (void)logD:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    [OCRichLog logvLevel:LOGLEVELD Format:format VaList:args];
    va_end(args);
}

+ (void)logI:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    [OCRichLog logvLevel:LOGLEVELI Format:format VaList:args];
    va_end(args);
}

+ (void)logW:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    [OCRichLog logvLevel:LOGLEVELW Format:format VaList:args];
    va_end(args);
}

+ (void)logE:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    [OCRichLog logvLevel:LOGLEVELE Format:format VaList:args];
    va_end(args);
}

@end
