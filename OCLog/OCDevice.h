//
// Created by Lei Huang on 15/12/2016.
// Copyright (c) 2016 Lei Huang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OCDevice : NSObject

+ (NSString *)phoneModel;

+ (NSString *)OSNumber;

+ (NSString *)clientVersion;

+ (NSString *)buildVersion;

+ (NSString *)appName;
@end
