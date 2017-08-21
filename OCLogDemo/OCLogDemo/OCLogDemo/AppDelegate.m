//
//  AppDelegate.m
//  OCLogDemo
//
//  Created by Lei Huang on 21/08/2017.
//  Copyright © 2017 leisurehuang. All rights reserved.
//

#import "AppDelegate.h"
#import <OCLog/OCLog.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //use the thread to check UI block issues
    UIBlockCheckThread *checkThread = [[UIBlockCheckThread alloc] init];
    [checkThread start];
    
    [OCRichLog logInitial];
    [OCRichLog setDebug:YES];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
   
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
  
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
   
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
}


@end
