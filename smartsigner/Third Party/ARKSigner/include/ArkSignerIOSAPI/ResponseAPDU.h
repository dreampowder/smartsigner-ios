//
//  ResponseAPDU.h
//  call_lib
//
//  Created by Yasin  Kahramaner on 19/08/2017.
//
//

#import <Foundation/Foundation.h>

@interface ResponseAPDU : NSObject

-(id) initWithData:(unsigned char *)response responseLength:(unsigned int) responseLength;
-(id) initWithData:(NSData *)data;

- (NSMutableData *) getData;
- (NSData *) getSW;
- (boolean_t) isSuccessful;

@end
