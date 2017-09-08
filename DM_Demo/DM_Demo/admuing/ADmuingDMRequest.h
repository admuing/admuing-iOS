

#import <Foundation/Foundation.h>

@interface ADmuingDMRequest : NSObject{
    SEL _onSuccessCallback;
    SEL _onErrorCallback;
    id _target;
    NSURLSession *_session;
}
- (id)initWithTarget:(id)target
              onResult:(SEL)onSuccessCallback
               onError:(SEL)onErrorCallback;

- (void)doRequest:(NSString *)requestType
              url:(NSURL *)url
          andBody:(NSDictionary *)body;

@end
