#import <Foundation/Foundation.h>

@interface rnxml : NSObject

+(NSArray*)findByXPathInString:(NSString*)string queries:(NSArray*)queries;

@end
