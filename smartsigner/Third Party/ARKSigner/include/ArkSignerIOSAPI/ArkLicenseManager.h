//
//  ArkLicenseManager.h
//  ArkSignerIOSAPI
//
//  Created by Yasin  Kahramaner on 16.04.2018.
//  Copyright © 2018 Ark ICT Consulting Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmartCardReader.h"

@interface ArkLicenseManager : NSObject

/**
 *  Loads the provided license
 *  @param  license license of the application
 */
+ (void) loadLicense:(NSString *) license;

+ (void) check;

+ (void) checkDevice:(SmartCardReader*) cardReader;

@end
