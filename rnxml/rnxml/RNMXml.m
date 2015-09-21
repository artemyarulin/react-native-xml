#import "RNMXml.h"
#import "GDataXMLNode.h"
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"

@implementation RNMXml

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(queryXml:(NSString*)string queries:(NSArray*)queries callback:(RCTResponseSenderBlock)callback)
{
    callback(@[[RNMXml findByXPathInXml:string queries:queries]]);
}

RCT_EXPORT_METHOD(queryHtml:(NSString*)string queries:(NSArray*)queries callback:(RCTResponseSenderBlock)callback)
{
    callback(@[[RNMXml findByXPathInHtml:string queries:queries]]);
}

+(NSArray*)findByXPathInXml:(NSString*)string queries:(NSArray*)queries;
{
    NSError* err;
    GDataXMLDocument* doc = [[GDataXMLDocument alloc] initWithXMLString:string encoding:NSUTF8StringEncoding error:&err];
    if (err) NSLog(@"findByXPathInXml error: %@", err);
    return [self queryDocument:doc queries:queries];
}

+(NSArray*)findByXPathInHtml:(NSString*)string queries:(NSArray*)queries
{
    NSError* err;
    GDataXMLDocument* doc = [[GDataXMLDocument alloc] initWithHTMLString:string encoding:NSUTF8StringEncoding error:&err];
    if (err) NSLog(@"findByXPathInHtml error: %@", err);
    return [self queryDocument:doc queries:queries];
}

+(NSArray*)queryDocument:(GDataXMLDocument*)doc queries:(NSArray*)queries
{
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
