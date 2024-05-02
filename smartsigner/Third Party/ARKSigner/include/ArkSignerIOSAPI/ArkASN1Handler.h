//
//  ArkASN1Handler.h
//  call_lib
//
//  Created by Yasin  Kahramaner on 25/08/2017.
//
//

#import <Foundation/Foundation.h>
#import "ArkASN1Entity.h"
#include "ArkBigInteger.h"


@interface ArkASN1Handler : NSObject

#define ARK_ASN1_STATUS_SUCCESSFUL  0x00000000

+(NSData *) integerTo7Bit:(int) curLen;
+(NSString *) intToHexStr:(int) w;
+(NSData *) integerToBase256:(int) number;
+(NSData *) bigIntegerToBase256:(BigInt *) number;
+(NSData *) hexStringToNSData:(NSString *)hex;
+(NSData *) integerToOIDFormat:(int) number;


+(int) encodeOctetString:(ArkASN1Entity *) asn1 data:(NSMutableData *) data;
+(int) encodeBitString:(ArkASN1Entity *) asn1 data:(NSMutableData *) data;
+(int) encodeInteger:(ArkASN1Entity *) asn1 data:(NSMutableData *) data;
+(int) encodeBoolean:(ArkASN1Entity *) asn1 data:(NSMutableData *) data;
+(int) encodeNull:(ArkASN1Entity *) asn1 data:(NSMutableData *) data ;
+(int) encodeIA5String:(ArkASN1Entity *) asn1 data:(NSMutableData *) data;
+(int) encodeUTF8String:(ArkASN1Entity *) asn1 data:(NSMutableData *) data;
+(int) encodePrintableString:(ArkASN1Entity *) asn1 data:(NSMutableData *) data;
+(int) encodeObjectIdentifier:(ArkASN1Entity *) asn1 data:(NSMutableData *) data;
+(int) encodeGeneralizedTime:(ArkASN1Entity *) asn1 data:(NSMutableData *) data;
+(int) encodeUTCTime:(ArkASN1Entity *) asn1 data:(NSMutableData *) data;
+(int) encodeTag:(ArkASN1Entity *) asn1 data:(NSMutableData *) data;
+(int) encodeSequence:(ArkASN1Entity *) asn1 data:(NSMutableData *) data;
+(int) encodeSet:(ArkASN1Entity *) asn1 data:(NSMutableData *) data;

+(int) decodeUTF8String:(ArkASN1Entity *) asn1;
+(int) decodeIA5String:(ArkASN1Entity *) asn1;
+(int) decodePrintableString:(ArkASN1Entity *) asn1;
+(int) decodeOctetString:(ArkASN1Entity *) asn1;
+(int) decodeBitString:(ArkASN1Entity *) asn1;
+(int) decodeBoolean:(ArkASN1Entity *) asn1;
+(int) decodeNull:(ArkASN1Entity *) asn1;
+(int) decodeGeneralizedTime:(ArkASN1Entity *) asn1;
+(int) decodeUTCTime:(ArkASN1Entity *) asn1;
+(int) decodeObjectIdentifier:(ArkASN1Entity *) asn1;
+(int) decodeInteger:(ArkASN1Entity *) asn1;

@end
