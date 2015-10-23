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
    NSError* err;
    NSArray* results =  [RNMXml findByXPathInXml:xml queries:queries error:&err];
    XCTAssertNil(err);
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
    NSError* err;
    NSArray* results =  [RNMXml findByXPathInHtml:html queries:queries error:&err];
    XCTAssertNil(err);
    XCTAssertEqual(results.count, testRuns.count);
    
    [queries enumerateObjectsUsingBlock:^(NSString* query, NSUInteger idx, BOOL *stop) {
        NSArray* expResults = [testRuns objectForKey:query];
        NSArray* curResults = [results objectAtIndex:idx];
        XCTAssertEqual(expResults.count, curResults.count,@"There should be right amount of results for xpath: %@", query);
        XCTAssert([curResults isEqualToArray:expResults],@"There should be right result values for xpath: %@",query);
    }];
}

-(void)testParseingStrings
{
    NSString* doc = @"<?xml version=\"1.0\" encoding=\"utf-8\" ?> \
    <SyncFolderItems xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"> \
      <ItemShape xmlns=\"http://schemas.microsoft.com/exchange/services/2006/messages\"> \
        <BaseShape xmlns=\"http://schemas.microsoft.com/exchange/services/2006/types\"> \
          Default \
        </BaseShape> \
      </ItemShape> \
      <SyncFolderId xmlns=\"http://schemas.microsoft.com/exchange/services/2006/messages\"> \
        <DistinguishedFolderId Id=\"drafts\" xmlns=\"http://schemas.microsoft.com/exchange/services/2006/types\" /> \
      </SyncFolderId> \
      <MaxChangesReturned xmlns=\"http://schemas.microsoft.com/exchange/services/2006/messages\"> \
        20 \
      </MaxChangesReturned> \
    </SyncFolderItems>";

    NSError* err;
    NSDictionary* parsed = [RNMXml parseString:doc isHtml:NO error:&err];
    XCTAssertNil(err);
    
    
    NSDictionary* expected = @{@"tag":@"SyncFolderItems",
                               @"attrs":@{@"xmlns/xsi": @"http://www.w3.org/2001/XMLSchema-instance",
                                          @"xmlns/xsd": @"http://www.w3.org/2001/XMLSchema"},
                               @"content":@[
                                       @{@"tag":@"ItemShape",
                                         @"attrs":@{@"xmlns":@"http://schemas.microsoft.com/exchange/services/2006/messages"},
                                         @"content":@[
                                                 @{@"tag":@"BaseShape",
                                                   @"attrs":@{@"xmlns": @"http://schemas.microsoft.com/exchange/services/2006/types" },
                                                   @"content":@[@"Default"]}]},
                                       @{@"tag":@"SyncFolderId",
                                         @"attrs":@{@"xmlns":@"http://schemas.microsoft.com/exchange/services/2006/messages"},
                                         @"content":@[
                                                 @{@"tag":@"DistinguishedFolderId",
                                                   @"attrs":@{@"Id":@"drafts",
                                                              @"xmlns":@"http://schemas.microsoft.com/exchange/services/2006/types"},
                                                   @"content":@[]}]},
                                       @{@"tag":@"MaxChangesReturned",
                                         @"attrs":@{@"xmlns":@"http://schemas.microsoft.com/exchange/services/2006/messages"},
                                         @"content":@[@"20"]}]};
    XCTAssertEqualObjects(parsed, expected,@"Parsed dictionary has to have a right structure");
}

@end
