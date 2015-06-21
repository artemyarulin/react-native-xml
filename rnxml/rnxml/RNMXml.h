#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"

@interface RNMXml : NSObject <RCTBridgeModule>

+(NSArray*)findByXPathInString:(NSString*)string queries:(NSArray*)queries;

@end
