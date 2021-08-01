//
//  YAOCAnnotationDemoTests.m
//  YAOCAnnotationDemoTests
//
//  Created by 何亚鲁 on 2021/7/26.
//

#import <XCTest/XCTest.h>
#import "YAAnnotationManager.h"

@interface YAOCAnnotationDemoTests : XCTestCase

@end


ClassAnnotation(YAOCAnnotationDemoTests, heyalu, , P0, 测试)
@implementation YAOCAnnotationDemoTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSLog(@"%@", [YAAnnotationManager sharedInstance].classAnnotationDict);
    NSLog(@"%@", [YAAnnotationManager sharedInstance].methodAnnotationDict);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

MethodAnnotation(YAOCAnnotationDemoTests, testExample, P1, 测试)
- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}


@end
