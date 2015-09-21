#import <XCTest/XCTest.h>
#import "GDataXMLNode.h"
#import "RNMXml.h"

@interface rnxmlTests : XCTestCase

@end

@implementation rnxmlTests

-(void)testGDataXMLShoudWork
{
    NSString* xml = @"<doc a=\"V1\">V2</doc>";
    NSError* err;
    GDataXMLDocument* doc = [[GDataXMLDocument alloc] initWithXMLString:xml encoding:NSUTF8StringEncoding error:&err];
    XCTAssertNil(err,@"There should be no error during parsing");
    
    NSArray* nodes = [doc nodesForXPath:@"/doc/@a" error:&err];
    XCTAssertNil(err,@"There should be no error during parsing");
    XCTAssertEqual(nodes.count, (NSUInteger)1,@"There should be only one node");
    XCTAssertEqualObjects([nodes.firstObject stringValue], @"V1","There should be right value");
    
    nodes = [doc nodesForXPath:@"/doc" error:&err];
    XCTAssertNil(err,@"There should be no error during parsing");
    XCTAssertEqual(nodes.count, (NSUInteger)1,@"There should be only one node");
    XCTAssertEqualObjects([nodes.firstObject stringValue], @"V2","There should be right value");
}

-(void)testXml
{
    NSString* xml = @"<doc a=\"V1\"><S>V2</S><S a=\"V3\">V4</S></doc>";
    NSDictionary* testRuns =  @{ @"/doc":    @[@"V2V4"],
                                 @"doc":     @[@"V2V4"],
                                 @"/doc/@a": @[@"V1"],
                                 @"doc/@a":  @[@"V1"],
                                 @"/doc/S":  @[@"V2",@"V4"],
                                 @"//@a":    @[@"V1",@"V3"],
                                 @"/doc/@b": @[],
                                 @"asdasd":  @[] };
    
    NSArray* queries = testRuns.allKeys;
    NSArray* results =  [RNMXml findByXPathInXml:xml queries:queries];
    XCTAssertEqual(results.count, testRuns.count);
    
    [queries enumerateObjectsUsingBlock:^(NSString* query, NSUInteger idx, BOOL *stop) {
        NSArray* expResults = [testRuns objectForKey:query];
        NSArray* curResults = [results objectAtIndex:idx];
        XCTAssertEqual(expResults.count, curResults.count,@"There should be right amount of results for xpath: %@", query);
        XCTAssert([curResults isEqualToArray:expResults],@"There should be right result values for xpath: %@",query);
    }];
}

-(void)testHtml
{
    NSString* html = @"<html><div><input name='user' value='john'></html>";
    NSDictionary* testRuns =  @{ @"html":                           @[@""],
                                 @"/html/body/div/input":           @[@""],
                                 @"//input/@value":                 @[@"john"],
                                 @"//input[@name='user']":          @[@""],
                                 @"//input[@name='user']/@value":   @[@"john"],
                                 @"/doc/@b":                        @[],
                                 @"asdasd":                         @[] };
    
    NSArray* queries = testRuns.allKeys;
    NSArray* results =  [RNMXml findByXPathInHtml:html queries:queries];
    XCTAssertEqual(results.count, testRuns.count);
    
    [queries enumerateObjectsUsingBlock:^(NSString* query, NSUInteger idx, BOOL *stop) {
        NSArray* expResults = [testRuns objectForKey:query];
        NSArray* curResults = [results objectAtIndex:idx];
        XCTAssertEqual(expResults.count, curResults.count,@"There should be right amount of results for xpath: %@", query);
        XCTAssert([curResults isEqualToArray:expResults],@"There should be right result values for xpath: %@",query);
    }];
}

@end
