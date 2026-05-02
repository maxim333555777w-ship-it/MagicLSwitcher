//
//  KeyboardLayoutBridge.m
//  MagicLSwitcher
//
//  Created by Khachatur Abramian on 25.4.2026.
//

#import "KeyboardLayoutBridge.h"
#import <Carbon/Carbon.h>

@implementation KeyboardLayoutBridge

+ (nullable NSString *)translateKeyCode:(uint16_t)keyCode
                              modifiers:(uint32_t)modifiers
                               layoutID:(NSString *)layoutID {
    NSDictionary *filter = @{
        (__bridge NSString *)kTISPropertyInputSourceID: layoutID
    };
    CFArrayRef sources = TISCreateInputSourceList((__bridge CFDictionaryRef)filter, false);
    
    if (sources == NULL || CFArrayGetCount(sources) == 0) {
        if (sources != NULL) {
            CFRelease(sources);
        }
            return nil;
    }
    TISInputSourceRef source = (TISInputSourceRef)CFArrayGetValueAtIndex(sources, 0);
    CFDataRef layoutData = TISGetInputSourceProperty(
                                                     source,
                                                     kTISPropertyUnicodeKeyLayoutData
                                                     );
    
    if (layoutData == NULL) {
        CFRelease(sources);
        return nil;
    }
    const UCKeyboardLayout *keyboardLayout =
                                  (const UCKeyboardLayout *)CFDataGetBytePtr(layoutData);
    
    UInt32 deadKeyState = 0;
    UniChar chars[8];
    UniCharCount realLength = 0;
    
    OSStatus status = UCKeyTranslate(
                                     keyboardLayout,
                                     keyCode,
                                     kUCKeyActionDown,
                                     modifiers >> 8,
                                     LMGetKbdType(),
                                     kUCKeyTranslateNoDeadKeysBit,
                                     &deadKeyState,
                                     8,
                                     &realLength,
                                     chars
                                     );
    CFRelease(sources);
    
    if (status != noErr || realLength == 0) {
        return nil;
    }
                                  return [NSString stringWithCharacters:chars length:realLength];
}
+ (NSArray<NSString *> *)availableLAyoutIDs {
    NSMutableArray<NSString *> *result = [NSMutableArray array];
    CFArrayRef sources = TISCreateInputSourceList(NULL, false);
    
    if (sources == NULL) {
        return result;
    }
    CFIndex count = CFArrayGetCount(sources);
    
    for (CFIndex i = 0; i < count; i++) {
        TISInputSourceRef source =
        (TISInputSourceRef)CFArrayGetValueAtIndex(sources, i);
        
        NSString *sourceID = (__bridge NSString *)
        TISGetInputSourceProperty(source, kTISPropertyInputSourceID);
        
        NSString *category = (__bridge NSString *)
        TISGetInputSourceProperty(source, kTISPropertyInputSourceCategory);
        
        if ([category isEqualToString:(__bridge NSString *)kTISCategoryKeyboardInputSource]) {
            if (sourceID != nil) {
                [result addObject:sourceID];
            }
        }
    }
    CFRelease(sources);
    return result;
}
+ (nullable NSString *)currentLayoutID {
    TISInputSourceRef source = TISCopyCurrentKeyboardInputSource();
    if (source == NULL) {
        return nil;
    }
    NSString *sourceID = (__bridge NSString *)
    TISGetInputSourceProperty(source, kTISPropertyInputSourceID);
    CFRelease(source);
    return sourceID;
}
+ (BOOL)selectLayoutID:(NSString *)layoutID {
    NSDictionary *filter =@{
        (__bridge NSString *)kTISPropertyInputSourceID: layoutID
    };
    CFArrayRef sources = TISCreateInputSourceList((__bridge CFDictionaryRef)filter,
    true
    );
    if (sources == NULL || CFArrayGetCount(sources) == 0) {
        NSLog(@"No input source found for layoutID: %@", layoutID);
        if (sources != NULL) {
            CFRelease(sources);
        }
        return NO;
    }
    TISInputSourceRef source = (TISInputSourceRef)CFArrayGetValueAtIndex(sources, 0);
    CFBooleanRef isEnabled = TISGetInputSourceProperty(source, kTISPropertyInputSourceIsEnabled);
    if (isEnabled == kCFBooleanFalse) {
        OSStatus enableStatus = TISEnableInputSource(source);
        NSLog(@"Enable status: %d", enableStatus);
    }
    OSStatus status = TISSelectInputSource(source);
    NSLog(@"Select layoutID: %@ status: %d", layoutID, status);
    CFRelease(sources);
    return status == noErr;
}

@end
