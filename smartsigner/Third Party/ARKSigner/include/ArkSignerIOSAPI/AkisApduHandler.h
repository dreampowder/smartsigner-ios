//
//  PCSCHandler.h
//  call_lib
//
//  Created by Yasin  Kahramaner on 23/08/2017.
//
//

#import <Foundation/Foundation.h>
#import "SmartCardReader.h"

#define PCSC_STATUS_SUCCESSFUL  0;
#define PCSC_CARD_BLOCKED       1;
#define PCSC_PIN_INCORRECT_2    2;
#define PCSC_PIN_INCORRECT_1    3;
#define PCSC_UNDEFINED_ERROR    4;

#define CARD_TYPE_TCKK 1;
#define CARD_TYPE_AKIS 2;


@interface AkisApduHandler : NSObject {

}

////////////////////////////////////////////////////
//  ARKSIGNER SIGNATURE METHODS
////////////////////////////////////////////////////

- (id) initWithSmarCardReader:(SmartCardReader *) device;

/**
 *  Reads the signing certificate on the smartcard reader
 *  Warning - This method returns only the first certificate on the card
 *  Prefer to use listCertificates method instead
 *  @param certificates  The list of certificates
 */
- (int) readAllCertificates:(NSMutableArray *)certificates;

- (int) signDigestWithRSA_PKCS_1_5:(ArkX509Certificate*) cert digestToSign:(NSData *)digestToSign pinCode:(NSString *) pinCode signedData:(NSMutableData *) signedData;

- (int) signDigestWithPSS:(NSData *)digestToSign pinCode:(NSString *) pinCode signedData:(NSMutableData *) signedData;

////////////////////////////////////////////////////
//  ARKSIGNER CRYPTO METHODS
////////////////////////////////////////////////////

-(NSData *)calculateSHA1Digest:(NSData *)data;
-(NSData *)calculateSHA256Digest:(NSData *)data;

@end
