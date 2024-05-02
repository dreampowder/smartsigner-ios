//
//  ArkX509Certificate.h
//  call_lib
//
//  Created by Yasin  Kahramaner on 26/08/2017.
//
//

#import <Foundation/Foundation.h>
#import "ArkASN1Entity.h"
#import "ArkSignerCommons.h"

@interface ArkX509CertificatePolicy: NSObject {
    NSString *objectIdentifier;
    NSData *data;
    ArkASN1Entity *asn1;
    NSString *cpsText;
    NSString *unoticeText;
}

-(id) initWithAsn1:(ArkASN1Entity *)asn1 oid:(NSString*) oid;

-(NSString*) getObjectIdentifier;

@end

@interface ArkX509v3Extension : NSObject {
    NSString *objectIdentifier;
    NSData *data;
    ArkASN1Entity *asn1;
}

-(id) initWithValues:(NSString *)objectIdentifier data:(NSData*) data;
-(id) initWithAsn1:(ArkASN1Entity *)asn1 oid:(NSString*) oid;

@end

@interface ArkX509QCStatements : NSObject {
    NSData *data;
    BOOL etsiQcsCompliance;
    BOOL compliance5070;
    NSString *compliance5070Text;
}

-(id) initWithAsn1:(ArkASN1Entity*) asn1;

@end


@interface ArkX509v3Extensions : NSObject {
    NSData *data;
    ArkASN1Entity *asn1;
    ArkX509QCStatements *qcStatements;
    NSMutableArray<ArkX509v3Extension*> *extensions;
    NSMutableArray<ArkX509CertificatePolicy*> *policies;
    NSMutableDictionary<NSString*, ArkX509CertificatePolicy*> *policyMap;
    BOOL compliesWithETSI;
    BOOL compliesWith5070;
}

-(id) initWithAsn1:(ArkASN1Entity*) asn1;
-(NSMutableArray<ArkX509CertificatePolicy*>*) getPolicies;
- (BOOL) isCompliantWithETSI;
- (BOOL) isCompliantWith5070;

@end


@interface ArkCertificateRDN : NSObject {
    NSString *type;
    NSString *value;
    NSString *objectIdentifier;
}

-(id) initWithValues:(NSString *) type oid:(NSString *) oid value:(NSString *) value;

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *objectIdentifier;

@end

@interface ArkCertificateX500Name : NSObject {
    NSData *data;
    ArkASN1Entity *asn1;
    NSString *serialNumber;
    NSString *commonName;
    NSString *organizationName;
    NSString *organizationalUnitName;
    NSString *countryName;
    NSString *localityName;
    NSString *stateOrProvinceName;
    NSMutableArray<ArkCertificateRDN *> *listOfRDN;
    NSMutableDictionary *mapOfRDN;
}

-(id) initWithData:(NSData *) _data;
-(id) initWithASN1:(ArkASN1Entity *) _asn1;
-(ArkASN1Entity *) encode;

@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) ArkASN1Entity *asn1;
@property (nonatomic, strong) NSString *serialNumber;
@property (nonatomic, strong) NSString *commonName;
@property (nonatomic, strong) NSString *organizationName;
@property (nonatomic, strong) NSString *organizationalUnitName;
@property (nonatomic, strong) NSString *countryName;
@property (nonatomic, strong) NSString *localityName;
@property (nonatomic, strong) NSString *stateOrProvinceName;
@property (nonatomic, strong) NSMutableArray<ArkCertificateRDN *> *listOfRDN;
@property (nonatomic, strong) NSMutableDictionary *mapOfRDN;

@end


@interface ArkX509Certificate : NSObject {
    NSString *serialNumber;
    NSData *data;
    ArkCertificateX500Name *subjectDN;
    ArkCertificateX500Name *issuerDN;
    NSDate *notBefore;
    NSDate *notAfter;
    int validityStatus;
    int signatureAlgorithmID;
    int digestAlgorithmID;
    ArkASN1Entity *asn1;
    ArkX509v3Extensions *v3Extensions;
    NSString *version;
    bool isQualified;
    
    
    NSData *akisCertificateAddress;
    int akisPrivateKeyIndex;
}

-(id) initWithData:(NSData *) _data;
-(ArkASN1Entity *) encode;

-(BOOL) isQualified;

@property (nonatomic, strong) NSString *serialNumber;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) ArkCertificateX500Name *subjectDN;
@property (nonatomic, strong) ArkCertificateX500Name *issuerDN;
@property (nonatomic, strong) NSDate *notBefore;
@property (nonatomic, strong) NSDate *notAfter;
@property int digestAlgorithmID;
@property int signatureAlgorithmID;
@property int validityStatus;
@property (nonatomic, strong) ArkASN1Entity *asn1;

@property (nonatomic, strong) NSData *akisCertificateAddress;
@property int akisPrivateKeyIndex;

@end

