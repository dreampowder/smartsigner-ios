//
//  ArkSignerContext.h
//  call_lib
//
//  Created by Yasin  Kahramaner on 26/08/2017.
//
//

#import <Foundation/Foundation.h>
#include "winscard.h"

@interface ArkSignerContext : NSObject {
    
}

////////////////////////////////////////////////////
//  ARKSIGNER DEVICE CONNECTIONS
////////////////////////////////////////////////////

+ (void)attachDevices;
+ (void)detachDevices;

/**
 *  Determines if online verification should be used
 *  to verify the identity of the device
 */
+ (void)setOnlineVerify:(BOOL) onlineVerify;

/**
 *  Returns if device is online verified or not
 *  Default value is TRUE
 */
+ (BOOL)OnlineVerify;

/**
 *  Returns the smartcard context for Feitian card reader
 *  @return feitian smartcard reader context
 */
+ (SCARDCONTEXT) getFeitianContext;

////////////////////////////////////////////////////
//  ARKSIGNER CRYPTO METHODS
////////////////////////////////////////////////////

- (NSData *)calculateSHA1Digest:(NSData *)data;
- (NSData *)calculateSHA256Digest:(NSData *)data;
- (NSData *)calculateSHA384Digest:(NSData *)data;
- (NSData *)calculateSHA512Digest:(NSData *)data;

@end
