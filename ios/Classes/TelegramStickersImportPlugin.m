#import "TelegramStickersImportPlugin.h"
#if __has_include(<telegram_stickers_import/telegram_stickers_import-Swift.h>)
#import <telegram_stickers_import/telegram_stickers_import-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "telegram_stickers_import-Swift.h"
#endif

@implementation TelegramStickersImportPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTelegramStickersImportPlugin registerWithRegistrar:registrar];
}
@end
