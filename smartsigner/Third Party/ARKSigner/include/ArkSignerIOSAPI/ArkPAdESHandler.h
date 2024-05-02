//
//  ArkPAdESHandler.h
//  call_lib
//
//  Created by Yasin  Kahramaner on 04/09/2017.
//
//

#import <Foundation/Foundation.h>

///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////

#define ARK_PADES_DOC_COMP_OBJECT   1
#define ARK_PADES_DOC_COMP_OTHER    2
#define ARK_PADES_DOC_SIGNATURE_CADES_OBJ   3
#define ARK_PADES_DOC_SIGNATURE_CMS_OBJ     4
#define ARK_PADES_DOC_SIGNATURE_TIMESTAMP_OBJ   5

///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////

@interface ArkPAdESComponent : NSObject {
    unsigned long long startOffset;
    unsigned long long endOffset;
    NSData *data;
    int componentType;
}

@property unsigned long long startOffset;
@property unsigned long long endOffset;
@property (nonatomic, strong) NSData *data;
@property int componentType;

@end

///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////

@interface ArkPAdESObject : ArkPAdESComponent {
    unsigned int objectID;
    unsigned int versionNumber;
    NSString *filter;
}

@property unsigned int objectID;
@property unsigned int versionNumber;
@property (nonatomic, strong) NSString *filter;

-(id) initWithValues:(NSData *)data startOffset:(NSNumber *)_startOffset endOffset:(NSNumber *) _endOffset;

@end

///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////

@interface ArkPAdESSignatureObject : ArkPAdESObject {
    NSData *signatureData;
    unsigned long long messageImprintStartIndex;
    unsigned long long messageImprintMiddleEndIndex;
    unsigned long long messageImprintMiddleStartIndex;
    unsigned long long messageImprintEndIndex;
    NSString *location;
    NSString *reason;
    NSString *type;
    NSString *subfilter;
}

@property (nonatomic, strong) NSData *signatureData;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *subfilter;
@property unsigned long long messageImprintStartIndex;
@property unsigned long long messageImprintMiddleEndIndex;
@property unsigned long long messageImprintMiddleStartIndex;
@property unsigned long long messageImprintEndIndex;

-(id) init;
-(id) initWithValues:(NSData *)_data startOffset:(NSNumber *)_startOffset endOffset:(NSNumber *) _endOffset;

@end

///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////

@interface ArkPAdESDocument: NSObject {
    NSData *pdfData;
    NSMutableArray<ArkPAdESComponent *> *components;
}

-(id) init;
-(id) initWithData:(NSData *) _data;

@property (nonatomic, strong) NSData *pdfData;
@property (nonatomic, strong) NSMutableArray<ArkPAdESComponent *> *components;

@end

///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////

@interface ArkPAdESHandler : NSObject

+(ArkPAdESDocument *) parsePDF:(NSData *) data;
+(NSData *) generatePDF:(ArkPAdESDocument *) document;
+(NSMutableArray<ArkPAdESSignatureObject *> *) getDigitalSignatures:(ArkPAdESDocument *) document;

@end
