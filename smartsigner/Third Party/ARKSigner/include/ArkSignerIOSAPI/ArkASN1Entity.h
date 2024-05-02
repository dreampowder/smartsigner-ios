//
//  ArkASN1Entity.h
//  call_lib
//
//  Created by Yasin  Kahramaner on 25/08/2017.
//
//

#import <Foundation/Foundation.h>


#define ASN1_Boolean            0x01
#define ASN1_INTEGER            0x02
#define ASN1_BIT_STRING         0x03
#define ASN1_OCTET_STRING       0x04
#define ASN1_NULL               0x05
#define ASN1_OBJECT_IDENTIFIER  0x06
#define ASN1_UTF8_STRING        0x0C
#define ASN1_PRINTABLE_STRING   0x13
#define ASN1_TELETEX_STRING     0x14
#define ASN1_IA5STRING          0x16
#define ASN1_UTC_TIME           0x17
#define ASN1_GENERALIZED_TIME   0x18
#define ASN1_BMP_STRING         0x1E
#define ASN1_SEQUENCE           0x30
#define ASN1_SEQUENCE_OF        0x30
#define ASN1_SET                0x31
#define ASN1_SET_OF             0x31
#define ASN1_TAG                0xA0

@interface ArkASN1Entity : NSObject {
    unsigned int tag;
    unsigned int tagNumber;
    BOOL isTag;
    unsigned long length;
    NSObject *value;
    NSData *valueByteArray;
    NSMutableArray<ArkASN1Entity *> *children;
    BOOL isPrimitive;
}

@property unsigned int tag;
@property unsigned int tagNumber;
@property BOOL isTag;
@property unsigned long length;
@property (nonatomic, strong) NSObject *value;
@property (nonatomic, strong) NSData *valueByteArray;
@property (nonatomic, strong) NSMutableArray<ArkASN1Entity *> *children;
@property BOOL isPrimitive;

/////////////////////////////////////////////////////
//  CONSTRUCTORS
/////////////////////////////////////////////////////

-(id) initForInteger:(NSNumber *) _value;
-(id) initForBigInteger:(NSString *) _value;
-(id) initForIntegerWithInt:(int) _value;
-(id) initForBoolean:(BOOL) _value;
-(id) initForNull;
-(id) initForIA5String:(NSString *) _value;
-(id) initForUTF8String:(NSString *) _value;
-(id) initForPrintableString:(NSString *) _value;
-(id) initForBitString:(NSString *) _value;
-(id) initForObjectIdentifier:(NSString *) _value;
-(id) initForGeneralizedTime:(NSDate *) _value;
-(id) initForUTCTime:(NSDate *) _value;
-(id) initForOctetString:(NSData *) _value;
-(id) initForNumberedTag:(int) _tagNumber elements:(NSMutableArray<ArkASN1Entity *>*) _elements;
-(id) initForNumberedTagWithData:(int) _tagNumber valueData:(NSData *) _valueData;
-(id) initForSet:(NSMutableArray<ArkASN1Entity *>*) _elements;
-(id) initForSequence:(NSMutableArray<ArkASN1Entity *>*) _elements;

-(id) initFromData:(NSData *) data;


-(NSMutableData*) getValue;
-(NSMutableArray<ArkASN1Entity *> *) getChildren;
-(int) getTagID;

// encodes the ASN.1 entity
-(NSMutableData *) encode;

// returns NSString representation of data
-(NSString *) dumpAsString:(NSString *) indent;

// returns NSString representation of value
-(NSString *) valueAsString;

// returns NSString representation of TAG
-(NSString *) tagAsString;


@end
