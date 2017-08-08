//
//  OCLogTests.m
//  OCLogTests
//
//  Created by Lei Huang on 03/08/2017.
//  Copyright © 2017 leisurehuang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OCRichLog.h"

@interface OCLogTests : XCTestCase
@end

@implementation OCLogTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [OCRichLog logInitial];
    OCRichLogV(@"this is a debug log");
    OCRichLogD(@"this is a debug log");
    OCRichLogI(@"this is a info log");
    OCRichLogW(@"this is a warning log");
    OCRichLogE(@"this is a error log");

}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
