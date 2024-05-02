//
//  ACSCardReader.h
//  ArkSignerIOSAPI
//
//  Created by Yasin  Kahramaner on 25.04.2018.
//  Copyright © 2018 Ark ICT Consulting Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmartCardReader.h"
#import "ResponseAPDU.h"

///////////////////////////////////////////////
//  ACS BLUETOOTH HEADERS
///////////////////////////////////////////////

#import <CoreBluetooth/CoreBluetooth.h>
#import "ACSBluetooth.h"

@interface ACSCardReader : SmartCardReader <ABTBluetoothReaderDelegate>

@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) ABTBluetoothReader *bluetoothReader;

/**
 *  Initializes ACS card reader with BLE
 */
- (id) initWithACSReader:(CBPeripheral *) peripheral reader:(ABTBluetoothReader *) reader;

@end
