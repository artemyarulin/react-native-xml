#import <XCTest/XCTest.h>
#import "GDataXMLNode.h"

@interface rnxmlTests : XCTestCase

@end

@implementation rnxmlTests

- (void)testGDataXMLShoudWork
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


@end
