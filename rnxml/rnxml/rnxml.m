#import "rnxml.h"
#import "GDataXMLNode.h"

@implementation rnxml

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
