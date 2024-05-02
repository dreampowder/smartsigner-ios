//
//  ESignViewController.h
//  smartsigner
//
//  Created by Serdar Coskun on 11.12.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SmartSignerSwift;
@class ESignViewController;
NS_ASSUME_NONNULL_BEGIN

@protocol ESignCompleterDelegate

- (void)createESignPackageWithCertificateData:(NSString * _Nonnull)certificateData completion:(void (^ _Nonnull)(NSString * _Nullable))completion;
- (void)completeSigningWithBase64String:(NSString * _Nonnull)base64String completition:(void (^ _Nonnull)(BOOL, NSString * _Nullable))completition;
- (void)completeSigningWithBase64String:(NSString * _Nonnull)base64String isMobileSign:(BOOL)isMobileSign completition:(void (^ _Nonnull)(BOOL, NSString * _Nullable))completition;
- (void)continueWorkFlowWithBase64String:(NSString * _Nonnull)base64String;
- (void)viewController:(ESignViewController*)viewController signingCompleteWithSuccess:(BOOL)success andWithMessage:(NSString*)message;
- (void)didSelectCertificateWithSerialNumber:(NSString*)serialNumber andWithPinCode:(NSString*)pinCode andWithIdentity:(NSString*)identity;

@optional
- (void)didCancelESign;

@end

@interface ESignViewController : UIViewController
- (instancetype)initWithParentVC:(UIViewController<ESignCompleterDelegate>*)parentVC;
- (instancetype)initWithParentVC:(UIViewController<ESignCompleterDelegate>*)parentVC isBatchOperation:(BOOL)isBatchOperation andWithCertificateSerial:(NSString* _Nullable)serial andWithPinCode:(NSString* _Nullable)pinCode;
- (void)animateDismissWithCompletitionBlock:(void (^ _Nonnull)(void))completion;
@end

NS_ASSUME_NONNULL_END
