//
//  ArkCAdESHandler.h
//  call_lib
//
//  Created by Yasin  Kahramaner on 26/08/2017.
//
//

#import <Foundation/Foundation.h>
#import "ArkASN1Entity.h"
#import "ArkSignerCommons.h"
#import "ArkSignerContext.h"
#import "ArkX509Certificate.h"
#import "AkisApduHandler.h"
#import "SmartCardReader.h"

///////////////////////////////////////////////////////////
//      CONSTANT DECLARATIONS
///////////////////////////////////////////////////////////

#define ARK_CADES_TASK_STATUS_SUCCESSFUL 0


///////////////////////////////////////////////////////////
//      HANDLER CLASS
///////////////////////////////////////////////////////////

@interface ArkCAdESTask : NSObject {
    int signerType;
    BOOL isAttached;
    int cmsVersion;
    NSMutableData *content;
    NSData *messageDigest;
    BOOL addSigningTime;
    NSDate *customSigningTime;
    int digestAlgorithmID;
    int signatureAlgorithmID;
    int signatureTypeID;
    BOOL usePolicyInformation;
    ArkX509Certificate *signingCertificate;
    NSString *pinCode;
}

@property int signerType;
@property int cmsVersion;
@property int digestAlgorithmID;
@property int signatureAlgorithmID;
@property BOOL isAttached;
@property (nonatomic, strong) NSMutableData *content;
@property (nonatomic, strong) NSData *messageDigest;
@property BOOL addSigningTime;
@property (nonatomic, strong) NSDate *customSigningTime;
@property int signatureTypeID;
@property (nonatomic, strong) ArkX509Certificate *signingCertificate;
@property BOOL usePolicyInformation;
@property (nonatomic, strong) NSString *pinCode;


@end

@interface ArkCAdESHandler : NSObject

-(id) initWithContext:(ArkSignerContext*) context;
-(int) sign:(SmartCardReader*) device task:(ArkCAdESTask *)task signedData:(NSMutableData *) signedData;

@end

///////////////////////////////////////////////////////////
//      CAdES ENTITY CLASSES
///////////////////////////////////////////////////////////

@interface ArkCAdESCMSVersion : NSObject {
    int cmsVersion;
}

@property int cmsVersion;

-(ArkASN1Entity *) encode;

@end

///////////////////////////////////////////////////////////
//      CAdES ENTITY CLASSES
///////////////////////////////////////////////////////////

@interface ArkCAdESContentType : NSObject {
    NSString *contentTypeOID;
    NSString *pkcs7OID;
}

@property (nonatomic, strong) NSString *contentTypeOID;
@property (nonatomic, strong) NSString *pkcs7OID;

-(ArkASN1Entity *) encode;

@end

///////////////////////////////////////////////////////////
//      CAdES ENTITY CLASSES
///////////////////////////////////////////////////////////

@interface ArkCAdESSigningTime : NSObject {
    NSDate *time;
}

@property (nonatomic, strong) NSDate *time;

-(ArkASN1Entity *) encode;

@end

///////////////////////////////////////////////////////////
//      CAdES ENTITY CLASSES
///////////////////////////////////////////////////////////


@interface ArkCAdESMessageDigest : NSObject {
    NSData *messageDigest;
}

@property (nonatomic, strong) NSData *messageDigest;

-(ArkASN1Entity *) encode;

@end

///////////////////////////////////////////////////////////
//      CAdES ENTITY CLASSES
///////////////////////////////////////////////////////////


@interface ArkCAdESDigestAlgorithm : NSObject {
    int digestAlgorithmID;
    NSString *digestAlgorithmOID;
}
@property int digestAlgorithmID;
@property (nonatomic, strong) NSString *digestAlgorithmOID;

-(ArkASN1Entity *) encode;

@end

///////////////////////////////////////////////////////////
//      CAdES ENTITY CLASSES
///////////////////////////////////////////////////////////


@interface ArkCAdESSignatureAlgorithm : NSObject {
    int signatureAlgorithm;
    NSString *signatureAlgorithmOID;
}

@property int signatureAlgorithm;;
@property (nonatomic, strong) NSString *signatureAlgorithmOID;;

-(ArkASN1Entity *) encode;

@end

///////////////////////////////////////////////////////////
//      CAdES ENTITY CLASSES
///////////////////////////////////////////////////////////

@interface ArkCAdESEncapContentInfo : NSObject {
    NSData *digest;
    NSData *content;
    BOOL isDetached;
}

@property (nonatomic, strong) NSData *digest;
@property (nonatomic, strong) NSData *content;
@property BOOL isDetached;

-(ArkASN1Entity *) encode;

@end

///////////////////////////////////////////////////////////
//      CAdES ENTITY CLASSES
///////////////////////////////////////////////////////////

@interface ArkCAdESCertificates : NSObject {
    NSMutableArray<ArkX509Certificate *> *certificates;
}

@property (nonatomic, strong) NSMutableArray<ArkX509Certificate *> *certificates;

-(ArkASN1Entity *) encode;

@end

///////////////////////////////////////////////////////////
//      CAdES ENTITY CLASSES
///////////////////////////////////////////////////////////

@interface ArkCAdESSignaturePolicy : NSObject

-(ArkASN1Entity *) encode;

@end

///////////////////////////////////////////////////////////
//      CAdES ENTITY CLASSES
///////////////////////////////////////////////////////////

@interface ArkCAdESSignerIdentifier : NSObject {
    ArkX509Certificate *signingCertificate;
}

@property (nonatomic, strong) ArkX509Certificate *signingCertificate;

-(ArkASN1Entity *) encode;

@end

///////////////////////////////////////////////////////////
//      CAdES ENTITY CLASSES
///////////////////////////////////////////////////////////

@interface ArkCAdESSigningCertificateV2 : NSObject {
    NSString *certivicateV2OID;
    NSString *serialNumber;
    NSData *certificateDigest;
    ArkASN1Entity *issuerInfoASN1;
}

@property (nonatomic, strong) NSString *certivicateV2OID;
@property (nonatomic, strong) NSString *serialNumber;
@property (nonatomic, strong) NSData *certificateDigest;
@property (nonatomic, strong) ArkASN1Entity *issuerInfoASN1;


-(ArkASN1Entity *) encode;

@end

///////////////////////////////////////////////////////////
//      CAdES ENTITY CLASSES
///////////////////////////////////////////////////////////

@interface ArkCAdESSignedAttributes : NSObject {
    ArkCAdESContentType *contentType;
    ArkCAdESSigningTime *signingTime;
    ArkCAdESMessageDigest *messageDigest;
    ArkCAdESSigningCertificateV2 *signingCertificateV2;
    ArkCAdESSignaturePolicy *signaturePolicy;
}

@property (nonatomic, strong) ArkCAdESContentType *contentType;
@property (nonatomic, strong) ArkCAdESSigningTime *signingTime;
@property (nonatomic, strong) ArkCAdESMessageDigest *messageDigest;
@property (nonatomic, strong) ArkCAdESSigningCertificateV2 *signingCertificateV2;
@property (nonatomic, strong) ArkCAdESSignaturePolicy *signaturePolicy;

-(ArkASN1Entity *) encode;

@end

///////////////////////////////////////////////////////////
//      CAdES ENTITY CLASSES
///////////////////////////////////////////////////////////

@interface ArkCAdESSignature : NSObject {
    NSMutableData *signature;
    NSMutableData *digestToBeSigned;
}

@property (nonatomic, strong) NSMutableData *signature;
@property (nonatomic, strong) NSMutableData *digestToBeSigned;

-(id) init;

-(ArkASN1Entity *) encode;

@end

///////////////////////////////////////////////////////////
//      CAdES ENTITY CLASSES
///////////////////////////////////////////////////////////

@interface ArkCAdESUnsignedAttributes : NSObject

-(ArkASN1Entity *) encode;

@end

///////////////////////////////////////////////////////////
//      CAdES ENTITY CLASSES
///////////////////////////////////////////////////////////

@interface ArkCAdESSignerInfo : NSObject {
    ArkCAdESCMSVersion *cmsVersion;
    ArkCAdESSignerIdentifier *signerIdentifier;
    ArkCAdESDigestAlgorithm *digestAlgorithm;
    ArkCAdESSignedAttributes *signedAttributes;
    ArkCAdESSignatureAlgorithm *signatureAlgorithm;
    ArkCAdESSignature *signature;
    ArkCAdESUnsignedAttributes *unsignedAttributes;
}

@property (nonatomic, strong) ArkCAdESCMSVersion *cmsVersion;
@property (nonatomic, strong) ArkCAdESSignerIdentifier *signerIdentifier;
@property (nonatomic, strong) ArkCAdESDigestAlgorithm *digestAlgorithm;
@property (nonatomic, strong) ArkCAdESSignedAttributes *signedAttributes;
@property (nonatomic, strong) ArkCAdESSignatureAlgorithm *signatureAlgorithm;
@property (nonatomic, strong) ArkCAdESSignature *signature;
@property (nonatomic, strong) ArkCAdESUnsignedAttributes *unsignedAttributes;

-(ArkASN1Entity *) encode;

@end

///////////////////////////////////////////////////////////
//      CAdES ENTITY CLASSES
///////////////////////////////////////////////////////////

@interface ArkCAdESSignerInfos : NSObject {
    NSMutableArray<ArkCAdESSignerInfo *> *signerInfos;
}

@property (nonatomic, strong) NSMutableArray<ArkCAdESSignerInfo *> *signerInfos;

-(ArkASN1Entity *) encode;

@end

///////////////////////////////////////////////////////////
//      CAdES ENTITY CLASSES
///////////////////////////////////////////////////////////

@interface ArkCAdESContentInfo : NSObject

-(id) initWithParams:(ArkSignerContext *) context task:(ArkCAdESTask *) task;

-(ArkASN1Entity *) encode;

@end
