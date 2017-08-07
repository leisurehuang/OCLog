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

// define a time the log X days before  will be deleted
const NSInteger k_preDaysToDelLog = 3;

static OCRichLog *singleInstance = nil;

@interface OCRichLog ()
@property(nonatomic, strong) NSString *logFilePath;
@property(nonatomic, strong) NSString *crateFileDay;
@property(nonatomic, strong) NSString *logDirectory;
@property(nonatomic, strong) NSString *crashDirectory;
@property(nonatomic, assign) BOOL isDebugModel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDateFormatter *timeFormatter;

@end

@implementation OCRichLog

+ (void)logInitial {
    OCRichLog *instance = [OCRichLog shareInstance];
    [instance updateLogFile];
    [instance deleteExpiredLog];
}

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (singleInstance == nil) {
            singleInstance = [[super alloc] init];
            // init dateFormatter
            [singleInstance createTimeFormatter];

            [singleInstance catchCrash];
            [singleInstance createLogPath];

        }
    });
    return singleInstance;
}

- (void)createTimeFormatter {
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];

    self.timeFormatter = [[NSDateFormatter alloc] init];
    [self.timeFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (void)catchCrash {
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
}

- (void)createLogPath {
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *logDirectory = [documentsDirectory stringByAppendingString:@"/OCRichLog/log/"];
    NSString *crashDirectory = [documentsDirectory stringByAppendingString:@"/OCRichLog/crash/"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:logDirectory])
        [[NSFileManager defaultManager] createDirectoryAtPath:logDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    if (![[NSFileManager defaultManager] fileExistsAtPath:crashDirectory])
        [[NSFileManager defaultManager] createDirectoryAtPath:crashDirectory withIntermediateDirectories:YES attributes:nil error:nil];

    self.logDirectory = logDirectory;
    self.crashDirectory = crashDirectory;
}

- (void)updateLogFile {
    OCRichLog *instance = [OCRichLog shareInstance];
    NSString *nowDay = [instance.dateFormatter stringFromDate:[NSDate date]];

    // create new file for log
    if (nil == instance.logFilePath || ![nowDay isEqualToString:instance.crateFileDay]) {
        NSString *fileNamePrefix = [instance.dateFormatter stringFromDate:[NSDate date]];
        instance.crateFileDay = fileNamePrefix;
        NSString *fileName = [NSString stringWithFormat:@"Log_%@.logtraces.txt", fileNamePrefix];
        NSString *filePath = [instance.logDirectory stringByAppendingPathComponent:fileName];

        instance.logFilePath = filePath;

        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSString *fileHead = [NSString stringWithFormat:@"App:%@, version:%@, build:%@ \n", [OCDevice appName], [OCDevice clientVersion], [OCDevice buildVersion]];
            NSData *dataHead = [fileHead dataUsingEncoding:NSUTF8StringEncoding];
            [[NSFileManager defaultManager] createFileAtPath:filePath contents:dataHead attributes:nil];
        }
    }
}

- (void)deleteExpiredLog {
    OCRichLog *instance = [OCRichLog shareInstance];
    NSDate *prevDate = [[NSDate date] dateByAddingTimeInterval:-60 * 60 * 24 * k_preDaysToDelLog];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:prevDate];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *delDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    NSArray *logFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:instance.logDirectory error:nil];
    for (NSString *file in logFiles) {
        NSString *fileName = [file stringByReplacingOccurrencesOfString:@".logtraces.txt" withString:@""];
        fileName = [fileName stringByReplacingOccurrencesOfString:@"Log_" withString:@""];
        NSDate *fileDate = [instance.dateFormatter dateFromString:fileName];
        if (nil == fileDate) {
            continue;
        }
        if (NSOrderedAscending == [fileDate compare:delDate]) {
            [[NSFileManager defaultManager] removeItemAtPath:[instance.logDirectory stringByAppendingString:file] error:nil];
        }
    }
}

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

+ (void)setDebug:(BOOL)isDebug {
    [OCRichLog shareInstance].isDebugModel = isDebug;
}

+ (void)setLogLevel:(OCRichLogLevel)level {
    LogLevel = level;
}

+ (void)logvLevel:(OCRichLogLevel)level Format:(NSString *)format VaList:(va_list)args {
    // only print in debug model
    OCRichLog *instance = [OCRichLog shareInstance];
    if (instance.isDebugModel) {
        [OCRichLog logInitial];
        if (level >= LogLevel) {
            format = [[OCRichLog logFormatPrefix:level] stringByAppendingString:format];
            NSString *contentString = nil;
            @try {
                contentString = [[NSString alloc] initWithFormat:format arguments:args];
            }
            @catch (NSException *e) {
                contentString = @"Log [logvLevel:ForMat:VaList] args Error!";
            }

            NSString *content = [NSString stringWithFormat:@"%@ %@ \n", [instance.timeFormatter stringFromDate:[NSDate date]], contentString];
            NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:instance.logFilePath];
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
    OCRichLog *instance = [OCRichLog shareInstance];
    if (instance.isDebugModel) {
        NSLog(@"CRASH: %@", exception);
        NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    }
    // Internal error reporting
    NSString *fileName = [NSString stringWithFormat:@"Log_crash_%@.log", [instance.timeFormatter stringFromDate:[NSDate date]]];
    NSString *filePath = [instance.crashDirectory stringByAppendingString:fileName];
    NSString *content = [[NSString stringWithFormat:@"CRASH: %@\n", exception] stringByAppendingString:[NSString stringWithFormat:@"Stack Trace: %@\n", [exception callStackSymbols]]];
    content = [content stringByAppendingString:[NSString stringWithFormat:@"iPhone:%@ ClientVersion:%@ OSVersion:%@", [OCDevice phoneModel], [OCDevice clientVersion], [OCDevice OSNumber]]];
    [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
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
