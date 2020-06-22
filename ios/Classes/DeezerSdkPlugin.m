#import "DeezerSdkPlugin.h"
#import "DeezerConnect.h"
#import "DZRRequestManager.h"
#import "DZRUser.h"

DeezerConnect *dzrConnect;
FlutterMethodChannel *outChannel;
AuthState *authState = UNAUTHENTICATED;

@implementation DeezerSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"deezer_sdk"
            binaryMessenger:[registrar messenger]];
    outChannel = channel;
  DeezerSdkPlugin* instance = [[DeezerSdkPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSLog(@"METHOD %@ %@", call.method, call.arguments[@"appId"]);
    
    [[DZRRequestManager defaultManager] setDzrConnect:dzrConnect];
    
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"initialize" isEqualToString:call.method]){
      NSString* appId = call.arguments[@"appId"];
      
      dzrConnect = [[DeezerConnect alloc] initWithAppId:appId andDelegate:self];
  } else if ([@"login" isEqualToString:call.method]){
      NSArray *permissions = [NSArray arrayWithObject:DeezerConnectPermissionBasicAccess];
      [dzrConnect authorize:permissions];
  } else if ([@"authState" isEqual:call.method]) {
      result([self stringFromEnum:authState]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (NSString* )stringFromEnum:(AuthState)state {
    if (state == AUTHENTICATED) return @"AUTHENTICATED";
    
    return @"UNAUTHENTICATED";
}

#pragma DeezerSessionDelegate implementation

- (void)deezerDidLogin {
    NSLog(@"LOGIN");
   
    NSString *url = [NSString stringWithFormat:@"https://api.deezer.com/user/%@", dzrConnect.userId];
    
    DZRJSONRequest *request = [[DZRJSONRequest alloc] initWithURLString: url];

    request.dataCompletionBlock = ^(NSData *res, NSError *err) {
        if ([err isEqual:nil]) {
            [outChannel invokeMethod:@"onError" arguments:err];
        } else{
            authState = AUTHENTICATED;
            NSDictionary *dict = @{
                @"user": [[NSString alloc] initWithData:res encoding:NSUTF8StringEncoding],
                @"access_token": dzrConnect.accessToken,
                @"expires": [NSNumber numberWithInt:dzrConnect.expirationDate.timeIntervalSince1970]
            };

            [outChannel invokeMethod:@"onComplete" arguments: dict];
        }
    };

    [[DZRRequestManager defaultManager] addRequest:request];

    [[DZRRequestManager defaultManager] resume];
}

- (void)deezerDidLogout {
    NSLog(@"LOGOUT");
}

- (void)deezerDidNotLogin:(BOOL)cancelled {
    NSLog(@"CANCEL");
    if (cancelled) {
        [outChannel invokeMethod:@"onCancel" arguments:nil];
    } else {
        [outChannel invokeMethod:@"onError" arguments:nil];
    }
}
@end
