#import "RNMXml.h"
#import "GDataXMLNode.h"
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"

@implementation RNMXml

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(findEvents:(NSString*)string queries:(NSArray*)queries callback:(RCTResponseSenderBlock)callback)
{
    callback([RNMXml findByXPathInString:string queries:queries]);
}

+(NSArray*)findByXPathInString:(NSString*)string queries:(NSArray*)queries
{
    NSError* err; // TODO: Think about error handling and reporting
    GDataXMLDocument* doc = [[GDataXMLDocument alloc] initWithXMLString:string encoding:NSUTF8StringEncoding error:&err];
    NSMutableArray* output = [NSMutableArray arrayWithCapacity:queries.count];
    [queries enumerateObjectsUsingBlock:^(NSString* query, NSUInteger idx, BOOL *stop) {
        NSArray* nodes = [doc nodesForXPath:query error:nil];
        NSMutableArray* nodesValue = [NSMutableArray arrayWithCapacity:nodes.count];
        [nodes enumerateObjectsUsingBlock:^(GDataXMLNode* node, NSUInteger idx, BOOL *stop) {
            [nodesValue addObject:node.stringValue];
        }];
        [output addObject:nodesValue];
    }];

    return output;
}

@end
