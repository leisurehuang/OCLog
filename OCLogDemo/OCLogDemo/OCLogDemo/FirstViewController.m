//
//  FirstViewController.m
//  OCLogDemo
//
//  Created by Lei Huang on 21/08/2017.
//  Copyright © 2017 leisurehuang. All rights reserved.
//

#import "FirstViewController.h"
#import <OCLog/OCLog.h>

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    OCRichLogD(@"view Did Load");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
