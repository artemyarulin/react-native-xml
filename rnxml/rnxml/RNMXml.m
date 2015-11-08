#import "RNMXml.h"
#import "GDataXMLNode.h"
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import "RCTUtils.h"

@implementation RNMXml

static NSString* ERR_DOMAIN = @"RNMXml";

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(queryXml:(NSString*)string queries:(NSArray*)queries callback:(RCTResponseSenderBlock)callback)
{
    NSError* err;
    NSArray* results = [RNMXml findByXPathInXml:string queries:queries error:&err];
    callback(@[(err? RCTJSErrorFromNSError(err): [NSNull null]),results]);
}

RCT_EXPORT_METHOD(queryHtml:(NSString*)string queries:(NSArray*)queries callback:(RCTResponseSenderBlock)callback)
{
    NSError* err;
    NSArray* results = [RNMXml findByXPathInHtml:string queries:queries error:&err];
    callback(@[(err? RCTJSErrorFromNSError(err): [NSNull null]),results]);
}

RCT_EXPORT_METHOD(parseString:(NSString*)string isHtml:(BOOL)isHtml callback:(RCTResponseSenderBlock)callback)
{
    NSError* err;
    NSDictionary* results = [RNMXml parseString:string isHtml:isHtml error:&err];
    callback(@[(err? RCTJSErrorFromNSError(err): [NSNull null]),results]);}

+(NSArray*)findByXPathInXml:(NSString*)string queries:(NSArray*)queries error:(NSError**)error
{
    NSError* err;
    GDataXMLDocument* doc = [[GDataXMLDocument alloc] initWithXMLString:string encoding:NSUTF8StringEncoding error:&err];
    if (err)
    {
        *error = [NSError errorWithDomain:ERR_DOMAIN
                                     code:err.code
                                 userInfo:@{NSLocalizedDescriptionKey:@"Error during parsing. Xml not in a proper mode"}];
        return @[];
    }
    else
        return [self queryDocument:doc queries:queries];
}

+(NSArray*)findByXPathInHtml:(NSString*)string queries:(NSArray*)queries error:(NSError**)error
{
    NSError* err;
    GDataXMLDocument* doc = [[GDataXMLDocument alloc] initWithHTMLString:string encoding:NSUTF8StringEncoding error:&err];
    if (err)
    {
        *error = [NSError errorWithDomain:ERR_DOMAIN
                                     code:err.code
                                 userInfo:@{NSLocalizedDescriptionKey:@"Error during parsing. HTML not in a proper mode"}];
        return @[];
    }
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

+(NSDictionary*)parseString:(NSString*)string isHtml:(BOOL)isHtml error:(NSError**)error
{
    NSError* err;
    GDataXMLDocument* doc;

    if (isHtml)
        doc = [[GDataXMLDocument alloc] initWithHTMLString:string encoding:NSUTF8StringEncoding error:&err];
    else
        doc = [[GDataXMLDocument alloc] initWithXMLString:string encoding:NSUTF8StringEncoding error:&err];

    if (err)
    {
        *error = [NSError errorWithDomain:ERR_DOMAIN
                                     code:err.code
                                 userInfo:@{NSLocalizedDescriptionKey:@"Error during parsing"}];
        return @{};
    }

    return [self readNode:doc.rootElement];
}

+(NSDictionary*)readNode:(GDataXMLNode*)node
{
    NSMutableDictionary* attrs = [@{} mutableCopy];

    if ([node isKindOfClass:GDataXMLElement.class])
    {
        [((GDataXMLElement*)node).attributes enumerateObjectsUsingBlock:^(GDataXMLNode* attr, NSUInteger idx, BOOL* stop) {
            attrs[attr.name] = attr.stringValue;
        }];

        [((GDataXMLElement*)node).namespaces enumerateObjectsUsingBlock:^(GDataXMLNode* ns, NSUInteger idx, BOOL* stop) {
            NSString* fullName = [ns.name isEqualToString:@""] ? @"xmlns" : [NSString stringWithFormat:@"xmlns/%@", ns.name];
            attrs[fullName] = ns.stringValue;
        }];
    }

    NSMutableArray* childs = [@[] mutableCopy];
    NSString* content;
    if (node.children.count == 1 && ((GDataXMLNode*)node.children[0]).kind == GDataXMLTextKind)
        content =[((GDataXMLNode*)node.children[0]).stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    else
        [node.children enumerateObjectsUsingBlock:^(GDataXMLNode* child, NSUInteger idx, BOOL* stop) {
            [childs addObject:[self readNode:child]];
        }];

    return @{@"tag":node.name,
             @"attrs":attrs,
             @"content":childs.count ? childs : (content.length ? @[content]: @[])};
}

@end
