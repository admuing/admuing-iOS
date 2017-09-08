

#import "ADmuingDMRequest.h"

static NSString *JJURLEncode(id object) {
    NSString *string = [NSString stringWithFormat: @"%@", object];
    return (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,(CFStringRef)string,
                                                                                nil,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8));
}

@implementation ADmuingDMRequest
- (id)initWithTarget:(id)target
            onResult:(SEL)onSuccessCallback
             onError:(SEL)onErrorCallback
{
    if (self == [super init]) {
        _target = target;
        _onSuccessCallback = onSuccessCallback;
        _onErrorCallback = onErrorCallback;
        return self;
    }
    return nil;
}

- (void)doRequest:(NSString *)requestType
              url:(NSURL *)url
          andBody:(NSDictionary *)body
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:requestType];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString *str = nil;
    if (body) {
        str = [self bodyString:body];
    }
    [request setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    
    dispatch_queue_t userQueue = dispatch_queue_create("com.adtm.gcd", DISPATCH_QUEUE_SERIAL);
    dispatch_async(userQueue,^{
        NSURLSessionTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_sync(dispatch_get_main_queue(),^{ //回到主线程
                NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                NSInteger responseStatusCode = [httpResponse statusCode];
                if (error) {
                    if (_target && [_target respondsToSelector:_onErrorCallback]) {
                        [_target performSelector:_onErrorCallback withObject:error afterDelay:0];
                    }
                }else{
                    NSError *jsonError;
                    id json = [NSJSONSerialization JSONObjectWithData:data
                                                              options:NSJSONReadingMutableContainers
                                                                error:&jsonError];
                    if (_target && [_target respondsToSelector:_onSuccessCallback] && responseStatusCode == 200) {
                        [_target performSelector:_onSuccessCallback withObject:json afterDelay:0];
                    }else{
                        if ([json isKindOfClass:[NSDictionary class]] && _target && [_target respondsToSelector:_onErrorCallback]) {
                            NSError *error = [[NSError alloc] initWithDomain:@"" code:responseStatusCode userInfo:json];
                            [_target performSelector:_onErrorCallback withObject:error afterDelay:0];
                        }
                    }
                }
            });
        }];
        [task resume];
    });
}

- (NSString *)bodyString:(NSDictionary *)dic{
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"i=1"];
    
    [dic.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = [[NSString alloc] initWithFormat:@"%@",obj];
        NSString *value = [[NSString alloc] initWithFormat:@"%@",[dic objectForKey:obj]];
        [str appendFormat:@"&%@=%@",key, JJURLEncode(value)];
    }];
    return str;
}

@end
