//
//  KeyboardLayoutBridge.h
//  MagicLSwitcher
//
//  Created by Khachatur Abramian on 25.4.2026.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyboardLayoutBridge : NSObject

+ (BOOL)selectLayoutID:(NSString *)layoutID;

+ (nullable NSString *) currentLayoutID;
    
+ (nullable NSString *)translateKeyCode:(uint16_t)keyCode
    modifiers:(uint32_t)modifiers
    layoutID:(NSString *)LayoutID;

+ (NSArray<NSString *> *)availableLAyoutIDs;

@end
NS_ASSUME_NONNULL_END
