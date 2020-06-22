#import <Flutter/Flutter.h>
#import "DeezerConnect.h"

@interface DeezerSdkPlugin : NSObject<FlutterPlugin, DeezerSessionDelegate>
@end

typedef NS_ENUM(NSUInteger, AuthState) {
    AUTHENTICATED = 0,
    UNAUTHENTICATED = 1
};
