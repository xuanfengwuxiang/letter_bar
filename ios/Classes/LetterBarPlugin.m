#import "LetterBarPlugin.h"
#if __has_include(<letter_bar/letter_bar-Swift.h>)
#import <letter_bar/letter_bar-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "letter_bar-Swift.h"
#endif

@implementation LetterBarPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLetterBarPlugin registerWithRegistrar:registrar];
}
@end
