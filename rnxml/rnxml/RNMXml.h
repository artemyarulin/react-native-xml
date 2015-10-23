#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"

@interface RNMXml : NSObject <RCTBridgeModule>

+(NSArray*)findByXPathInXml:(NSString*)string queries:(NSArray*)queries error:(NSError**)error;
+(NSArray*)findByXPathInHtml:(NSString*)string queries:(NSArray*)queries error:(NSError**)error;
+(NSDictionary*)parseString:(NSString*)string isHtml:(BOOL)isHtml error:(NSError**)error;

@end
