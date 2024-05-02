//
//  ObjCUtils.h
//  smartsigner
//
//  Created by Serdar Coskun on 20.02.2019.
//  Copyright © 2019 Seneka. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObjCUtils : NSObject

+(BOOL)isTurkishIdentityValid:(NSString*)idNumber;

@end

NS_ASSUME_NONNULL_END
