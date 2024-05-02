//
//  SmartCardReader.h
//  ArkSignerIOSAPI
//
//  Created by Yasin  Kahramaner on 15.04.2018.
//  Copyright © 2018 Ark ICT Consulting Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArkX509Certificate.h"
#import "ResponseAPDU.h"
#include "winscard.h"

///////////////////////////////////////////////
//  ACS BLUETOOTH HEADERS
///////////////////////////////////////////////

#import <CoreBluetooth/CoreBluetooth.h>
#import "ACSBluetooth.h"

////////////////////////////////////////////////
//  CARD READER TYPES
////////////////////////////////////////////////
#define ARK_SMARTCARDREADER_TYPE_NONE      0
#define ARK_SMARTCARDREADER_TYPE_ARK       1
#define ARK_SMARTCARDREADER_TYPE_ACS       2
#define ARK_SMARTCARDREADER_TYPE_FEITIAN   3

////////////////////////////////////////////////
//  CARD CONNECTION TYPES
////////////////////////////////////////////////

#define ARK_SMARTCARDREADER_CONNECTION_TYPE_LIGHTNING_CONNECTOR     4
#define ARK_SMARTCARDREADER_CONNECTION_TYPE_BLUETOOTH               5
#define ARK_SMARTCARDREADER_CONNECTION_TYPE_BLE                     6

////////////////////////////////////////////////
//  CARD CONNECTION STATUS
////////////////////////////////////////////////

#define ARK_SMARTCARDREADER_STATUS_NOT_CONNECTED            7
#define ARK_SMARTCARDREADER_STATUS_NO_SMARTCARD_IN_READER   8
#define ARK_SMARTCARDREADER_STATUS_INVALID_CERTIFICATE      9
#define ARK_SMARTCARDREADER_STATUS_CONNECTED                10
#define ARK_SMARTCARDREADER_STATUS_POWER_SAVE               11 // BLE specific state
#define ARK_SMARTCARDREADER_STATUS_ABSENT                   12 // BLE specific state

////////////////////////////////////////////////
//  CARD TYPE
////////////////////////////////////////////////

#define ARK_SMARTCARDREADER_CARD_TYPE_UNDEFINED             0
#define ARK_SMARTCARDREADER_CARD_TYPE_TCKK                  1
#define ARK_SMARTCARDREADER_CARD_TYPE_AKIS                  2

////////////////////////////////////////////////
//  SmartCardReader CLASS DEFINITION
////////////////////////////////////////////////

@interface SmartCardReader : NSObject <CBCentralManagerDelegate, ABTBluetoothReaderManagerDelegate, ABTBluetoothReaderDelegate> {
}

@property (nonatomic) int cardReaderType;
@property (nonatomic) int cardType;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic) int connectionType;
@property (nonatomic) int connectionStatus;
@property (nonatomic) int slotId;
@property (nonatomic) BOOL isRegistered;
@property (nonatomic, strong) NSString *atr;


////////////////////////////////////////////////
//  STATIC METHODS
////////////////////////////////////////////////

+ (void) listDiscoverableBLEDevices:(NSMutableArray<SmartCardReader*>*) listOfSmartCardReaders;

+ (void) listAttachedDevices:(NSMutableArray<SmartCardReader*>*) listOfSmartCardReaders;

/**
 *  Returns if the card reader is allowed or not
 *  @param  deviceID ID of the device to be used
 *  @return returns true if the card reader is allowed
 */
+ (BOOL) checkIfCardReaderIsAllowed:(NSString *) deviceID;

////////////////////////////////////////////////
//  PUBLIC METHODS
////////////////////////////////////////////////

/**
 *  Activates the smartcard reader with the provided QR code
 *  @param qrCode The QR Code corresponding to the card reader
 *  @return returns true is the smartcard reader is registered successfully
 */
- (BOOL) activateWithQRCode:(NSString*) qrCode;

/**
 *  Returns the list of certificates on the smartcard reader
 *  @param listOfCertificates a mutable list of certificates to be returned
 */
- (void) listCertificates:(NSMutableArray<ArkX509Certificate*>*) listOfCertificates;

/**
 *  Sends APDU command to Feitian card reader
 *  @param  apdu    The apdu command to be sent
 *  @return The APDU response
 */
- (ResponseAPDU *) sendAPDU:(NSData*) apdu;

/**
 *  Signs the provided digest data with the provided pin code
 *  and returns the signed data
 *  @param  cert                        Certificate to use for signing
 *  @param  digestOfMessageImprint      The digest data to be signed
 *  @param  digestAlgorithmId           The id of the digest algorithm and defined in the header ArkSignerCommons.h
 *  @param  pinCode                     The user pin code. If the signing device has PIN pad, then this value can be omitted.
 *  @param  signedData                  The output parameter
 *  @return returns if successful or not
 */
- (int) signDigestWithRSA_PKCS_1_5:(ArkX509Certificate*) cert digestOfMessageImprint:(NSData *)digestOfMessageImprint digestAlgorithmId:(int) digestAlgorithmId pinCode:(NSString *) pinCode signedData:(NSMutableData *) signedData;

- (BOOL)        checkIfCardReaderIsAllowed;

- (void)        retrieveQRCodeFromServer:(NSMutableString *)qrCode;

- (NSData *)    decryptQRCode:(NSString *)qrCode;


@end
