#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"

@interface RNMXml : NSObject <RCTBridgeModule>

+(NSArray*)findByXPathInXml:(NSString*)string queries:(NSArray*)queries;
+(NSArray*)findByXPathInHtml:(NSString*)string queries:(NSArray*)queries;

@end
