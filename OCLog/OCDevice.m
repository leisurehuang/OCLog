//
// Created by Lei Huang on 15/12/2016.
// Copyright (c) 2016 Lei Huang. All rights reserved.
//

#import "OCDevice.h"
#include <sys/sysctl.h>
#import <UIKit/UIKit.h>

@implementation OCDevice

+ (NSString *)phoneModel {
    char *typeSpecifier = "hw.machine";
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    NSString *results = [NSString stringWithCString:answer encoding:NSUTF8StringEncoding];
    free(answer);
    return results;
}

+ (NSString *)OSNumber {
    UIDevice *device = [UIDevice currentDevice];
    return device.systemVersion;
}

+ (NSString *)clientVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return infoDictionary[@"CFBundleShortVersionString"];
}

+ (NSString *)buildVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];

}

+ (NSString *)appName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}
@end
