//
//  ObjCUtils.m
//  smartsigner
//
//  Created by Serdar Coskun on 20.02.2019.
//  Copyright © 2019 Seneka. All rights reserved.
//

#import "ObjCUtils.h"

@implementation ObjCUtils

+(BOOL)isTurkishIdentityValid:(NSString*)idNumber{
    if (!idNumber||idNumber.length!=11) {
        return NO;
    }
    
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([idNumber rangeOfCharacterFromSet:notDigits].location != NSNotFound)
    {
        return NO;
    }
    
    NSString* firstDigit = [idNumber substringWithRange:NSMakeRange(0, 1)];
    if (!firstDigit) {
        return NO;
    }
    if (firstDigit.integerValue==0) {
        return YES; //0 ile başlıyor ise KKTC veya yabancı kimlik no dur
    }
    else{
        NSString* tenthDigit = [idNumber substringWithRange:NSMakeRange(9, 1)];
        
        NSMutableDictionary<NSNumber*,NSNumber*>* digits = @{}.mutableCopy;
        NSInteger totalFirstTenDigit = 0;
        for (int i = 0; i<idNumber.length; i++) {
            digits[@(i+1)] = @([[idNumber substringWithRange:NSMakeRange(i, 1)] integerValue]);
            if (i!=idNumber.length-1) {
                totalFirstTenDigit += [[idNumber substringWithRange:NSMakeRange(i, 1)] integerValue];
            }
        }
        
        NSInteger totalSingleDigits = digits[@1].integerValue+digits[@3].integerValue+digits[@5].integerValue+digits[@7].integerValue+digits[@9].integerValue;
        NSInteger totalDoubleDigits = digits[@2].integerValue+digits[@4].integerValue+digits[@6].integerValue+digits[@8].integerValue;
        
        if (tenthDigit.integerValue != (totalSingleDigits*7 - totalDoubleDigits)%10) {
            return NO;
        }
        NSInteger eleventhDigit = digits[@11].integerValue;
        return eleventhDigit == (totalFirstTenDigit)%10;
    }
}


@end
