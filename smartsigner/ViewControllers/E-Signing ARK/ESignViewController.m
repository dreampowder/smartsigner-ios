//
//  ESignViewController.m
//  smartsigner
//
//  Created by Serdar Coskun on 11.12.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

#import "ESignViewController.h"
#import "QRCodeReaderViewController.h"
#import "NVActivityIndicatorView-Swift.h"
#import "SmartSignerSwift.h"
#import "smartsigner-Bridging-Header.h"

#define SSLocalizedString(key,command) [LocalizationHelper getLocalizedStringWithKey:(key) comment:@""]
@import MaterialComponents;


@interface SmartCardReader(private) //v1.6 api sinde getDeviceId hata verdiği için manuel olarak private değere ulaşmada kullanıyoruz.

@property (nonatomic, strong) NSString* deviceID;

@end

@interface ESignViewController ()<ReaderInterfaceDelegate,UITableViewDataSource,UITableViewDelegate,QRCodeReaderDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet MDCTextField* txtUsername;
@property (nonatomic, strong) IBOutlet MDCTextField* txtPin;
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, weak) IBOutlet MDCButton* btnSign;
@property (nonatomic, weak) IBOutlet UIButton* btnClose;
@property (nonatomic, weak) IBOutlet UIView* loadingView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView* activityIndicatorView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* consViewHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* consViewBottom;
@property (nonatomic, weak) IBOutlet UILabel* lblStatus;

@property (nonatomic, strong) SmartCardReader *cardReader;
@property (nonatomic, strong) ArkX509Certificate *signingCertificate;
@property (nonatomic, strong) NSMutableArray* signingCertificates;

@property (nonatomic, strong) ReaderInterface *readInf;

@property (nonatomic, strong) QRCodeReader *reader;
@property (nonatomic, strong) UIViewController<ESignCompleterDelegate> *parentVC;

@property (nonatomic, strong) NSString* selectedDeviceId;
@property (nonatomic, strong) NSString* selectedDeviceIdToRegister;
@property (nonatomic, strong) MDCTextInputControllerFilled* txtPasswordController;

@property (nonatomic, assign) BOOL isFirstTimeLoading;

@property (nonatomic, strong) MDCDialogTransitionController* transitioningDelegate;

@property (nonatomic, assign) BOOL isBatchOperation;
@property (nonatomic, strong) NSString* lastCertSerial;
@property (nonatomic, strong) NSString* lastPinCode;

@end

@implementation ESignViewController

- (void)dealloc
{
    NSLog(@"dealloc e-sign");
}



- (instancetype)initWithParentVC:(UIViewController*)parentVC{
    return [self initWithParentVC:parentVC isBatchOperation:NO andWithCertificateSerial:nil andWithPinCode:nil];
}

- (instancetype)initWithParentVC:(UIViewController<ESignCompleterDelegate>*)parentVC isBatchOperation:(BOOL)isBatchOperation andWithCertificateSerial:(NSString*)serial andWithPinCode:(NSString*)pinCode{
    self = [super initWithNibName:@"ESignViewController" bundle:nil];
    if (self){
        _reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
        self.parentVC = parentVC;
        self.isBatchOperation = isBatchOperation;
        self.lastPinCode = pinCode;
        self.lastCertSerial = serial;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.txtPasswordController = [[MDCTextInputControllerFilled alloc] initWithTextInput:self.txtPin];
    self.activityIndicatorView.color = [UIColor colorWithRed:1.0 green:0.76f blue:0.03f alpha:1.0];
    [self.btnSign setEnabled:NO animated:NO];
    [self.btnSign setTitle:SSLocalizedString(@"e_sign_btn_title", nil) forState:UIControlStateNormal];
    [self updateStatusLabel:SSLocalizedString(@"smart_card_status_searching", nil)];
    [ThemeManager applyButtonColorThemeWithButton:self.btnSign];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.isFirstTimeLoading) {
        self.isFirstTimeLoading = YES;
        [self animatePresentation];
    }
}

- (NSString*)getDeviceId:(SmartCardReader*)reader{
    NSLog(@"deviceId: %@",reader.deviceID);
    return reader.deviceID;
}

- (void)startConnecting{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [ArkLicenseManager loadLicense:@"JBdNU5T05r0zcg5vDpHiGkgjic6svpK/ydPdupijMbTQKltoEX6tGYL4Lmagn/6csRrheChZwm2SKArcK1DRfkaPkL9mlGxuJnzZ8Ehr23eQQIlRjXgbXjm2UYEaZKMfZ7chCgy6aUS/TWTiqKwLjzZr4oZqdzZdFrjO36hoHyqRsXwf9w36U61Rsr2FyngPq5DgVUdebsDozCt25WVoBASlRQBtZNsfzOnKBgu/sblpg9co1NljRoWMfA89Ygwiz6c12zcQAftiTjJzwB+qYIrdzTh7kaSYW/xXjvR3x8b6Imu43V30yvr0yl2RFFp4h3V18sySiJ9GFSgWqdV2Aw=="];
        [ArkLicenseManager loadLicense:@"w9g3EsBqtMVkBkeKzvr6+OBKwYfhG9UxWjPb3o4To1CPBgZMLBUMhJhBRIVUmDqS8MbhaAlLW+JjioUnzLdwS4BG4TF27lBGkER1wLKUalZIDAvglB9E3IGL6Gw5FXwVJfJEYnQZS26EY92WNMC54b970te4zr1EkKk/+oPhQNb+Vui+Mzu6tQHtp3GiNOutmubrm/PWPvrJLlNhaBK0VKMAw/k2wd64Oiuv9VArLuN324irfoJC8MqmtLo1jFa2T/wy+MSdW67vhX8zAoS9LVgyJpkZ04g6/uEkHFALe7E+aWlKQjjT2c9NdQZG2mKxXGjWuiKEiOG9I0kfjQzdDg=="];
        [ArkSignerContext attachDevices];
        [ArkSignerContext setOnlineVerify:YES];
        
        self->_readInf = [[ReaderInterface alloc]init];
        [self->_readInf setDelegate:self];

        [self connectToSmartCard];
    });
}

- (void)animatePresentation{
    [UIView animateWithDuration:0.25f animations:^{
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25f animations:^{
            self.consViewBottom.constant = 0;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
            [self startConnecting];
        }];
    }];
}

- (void)animateDismiss{
    
    [self animateDismissWithCompletitionBlock:^{
        
    }];
}

- (void)animateDismissWithCompletitionBlock:(void (^ _Nonnull)(void))completion{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        __weak ESignViewController* weakSelf = self;
        [UIView animateWithDuration:0.25f animations:^{
            weakSelf.consViewBottom.constant = weakSelf.consViewHeight.constant * -1;
            [weakSelf.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25f animations:^{
                weakSelf.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
            } completion:^(BOOL finished) {
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    if (completion) {
                        [ArkSignerContext detachDevices];
                        completion();
                        weakSelf.readInf = nil;
                        weakSelf.parentVC = nil;
                        weakSelf.reader = nil;
                        weakSelf.signingCertificate = nil;
                        weakSelf.signingCertificates = nil;
                        weakSelf.transitioningDelegate = nil;
                    }
                }];
            }];
        }];
    });
    
}

- (void)updateStatusLabel:(NSString*)status{
    [self updateStatusLabelWithAtributedString:[[NSAttributedString alloc]initWithString:status]];
}

- (void)updateStatusLabelWithAtributedString:(NSAttributedString*)status{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.lblStatus.attributedText = status;
    });
}

- (void)setActivityViewHidden:(BOOL)hidden{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5f animations:^{
            self.loadingView.alpha = hidden ? 0 : 1;
            
        } completion:^(BOOL finished) {
            self.loadingView.hidden = hidden;
            if (hidden) {
                [self.activityIndicatorView stopAnimating];
            }else{
                [self.activityIndicatorView startAnimating];
            }
        }];
    });
}

- (IBAction)didTapConnect:(id)sender{
    
}

- (IBAction)didTapCancel:(id)sender{
    
    [self animateDismissWithCompletitionBlock:^{
        if ([self.parentVC respondsToSelector:@selector(didCancelESign)]) {
            [self.parentVC didCancelESign];
        }
    }];
}

- (void)showError:(NSString*)title description:(NSString*)description{
    if (!title) {
        title = SSLocalizedString(@"error", nil);
    }
    
    [self showAlert:title description:description actions:@[[MDCAlertAction actionWithTitle:SSLocalizedString(@"ok", nil) handler:nil]]];
    
}

- (void)showAlert:( NSString* _Nonnull)title description:(NSString*)description actions:(NSArray<MDCAlertAction*>*)actions{
    [self showAlert:title description:description actions:actions parentVC:self];
}
    
- (void)showAlert:( NSString* _Nonnull)title description:(NSString*)description actions:(NSArray<MDCAlertAction*>*)actions parentVC:(UIViewController*)parentVc{
    
    
    if (!title) {
        title = @"";
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        MDCAlertController* alertCon = [MDCAlertController alertControllerWithTitle:title message:description];
        for (int i = 0; i<actions.count; i++) {
            [alertCon addAction:actions[i]];
        }
        
        self.transitioningDelegate = (MDCDialogTransitionController*)alertCon.transitioningDelegate;
        if (self.transitioningDelegate) {
            alertCon.mdc_dialogPresentationController.dismissOnBackgroundTap = NO;
        }
        alertCon.titleColor = [UIColor blackColor];
        alertCon.messageColor = [UIColor darkGrayColor];
        [parentVc presentViewController:alertCon animated:YES completion:nil];
    });
    
}

- (IBAction)signDocument:(id)sender{
    if (!self.txtPin.text || self.txtPin.text.length == 0) {
        [self showError:nil description:SSLocalizedString(@"sign_smart_card_please_enter_pin", nil)];
    }else{
        NSString* pinCode = self.txtPin.text;
        NSString* certData = [self.signingCertificate.data base64EncodedStringWithOptions:0];
            [self updateStatusLabel:SSLocalizedString(@"e_sign_creating_package", nil)];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setActivityViewHidden:NO];
                [self.btnClose setEnabled:NO];
            });
        
            __weak ESignViewController* weakSelf = self;
            [weakSelf.parentVC createESignPackageWithCertificateData:certData completion:^(NSString * packageSummaryBytes) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    if (!packageSummaryBytes) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf setActivityViewHidden:YES];
                            [weakSelf.btnClose setEnabled:YES];
                        });
                        if (!self.isBatchOperation) {
                            [weakSelf showError:nil description:SSLocalizedString(@"sign_smart_card_error_no_sign_data", nil)];
                        }else{
                            NSLog(@"SummaryBytes: %@",packageSummaryBytes);
                            [self.parentVC viewController:weakSelf signingCompleteWithSuccess:NO andWithMessage:SSLocalizedString(@"sign_smart_card_error_no_sign_data", nil)];
                        }
                        return;
                    }else{
                        
                        // son 32 byte imzalanacak özettir
                        
                        NSData *digestToSign = [[NSData alloc] initWithBase64EncodedString:packageSummaryBytes options:NSDataBase64DecodingIgnoreUnknownCharacters];
                        digestToSign = [digestToSign subdataWithRange:NSMakeRange([digestToSign length] - 32, 32)];
                        
                        NSMutableData *signatureData = [[NSMutableData alloc] init];
                        NSString* errorMessage = nil;
                        
                        @try {
                            ////////////////////////////////////////
                            // Call the signer method
                            // For PKCS1 signatures, use the SmartCardReader object
                            ////////////////////////////////////////
                            [weakSelf updateStatusLabel:SSLocalizedString(@"e_sign_signing_document", nil)];
                            NSLog(@"Cert: %@",self.signingCertificate);
                            NSLog(@"Sign: %@",digestToSign);
                            
                            [weakSelf.cardReader signDigestWithRSA_PKCS_1_5:self.signingCertificate digestOfMessageImprint:digestToSign digestAlgorithmId:ARK_DIGEST_ALGORITHM_SHA256 pinCode:pinCode signedData:signatureData];
                            NSLog(@"signatureData: %@", [[NSByteCountFormatter new] stringFromByteCount:signatureData.length]);
                        }
                        @catch (NSException *ex) {
                            errorMessage = [NSString stringWithFormat:@"%@",[ex reason]];
                        }
                        NSLog(@"ErrorMessage: %@",errorMessage);
                        //                if (errorMessage != nil && errorMessage.length > 0)
                        if (errorMessage && errorMessage.length > 0) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakSelf setActivityViewHidden:YES];
                                [weakSelf.btnClose setEnabled:YES];
                            });
                            
                            if ([errorMessage containsString:@"Smartcard is locked"]) {
                                if (!self.isBatchOperation) {
                                    [weakSelf showError:nil description:SSLocalizedString(@"sign_smart_card_error_locked", nil)];
                                }else{
                                    [self.parentVC viewController:weakSelf signingCompleteWithSuccess:NO andWithMessage:SSLocalizedString(@"sign_smart_card_error_locked", nil)];
                                }
                            }
                            else if ([errorMessage containsString:@"Wrong PIN Code"]) {
                                [SessionManager.current clearLastUsedPin];
                                [self.parentVC didSelectCertificateWithSerialNumber:nil andWithPinCode:nil andWithIdentity:nil];
                                    [weakSelf showError:nil description:SSLocalizedString(@"sign_smart_card_error_wrong_pin", nil)];
                            }
                            else{
                                if (!self.isBatchOperation) {
                                    [weakSelf showError:nil description:[NSString stringWithFormat:@"%@\nHata:%@",SSLocalizedString(@"sign_smart_card_error_generic", nil),errorMessage]];
                                }else{
                                    [self.parentVC viewController:weakSelf signingCompleteWithSuccess:NO andWithMessage:[NSString stringWithFormat:@"%@\nHata:%@",SSLocalizedString(@"sign_smart_card_error_generic", nil),errorMessage]];
                                }
                                
                            }
                        }else{
                            //26.05.2019 Son başarılı girilen pin kodu hafızada saklanıyor.
                            dispatch_async(dispatch_get_main_queue(), ^{
                                SessionManager.current.lastUsedPin = self.txtPin.text;
                                if ([self.parentVC respondsToSelector:@selector(didSelectCertificateWithSerialNumber:andWithPinCode:andWithIdentity:)]) {
                                    [self.parentVC didSelectCertificateWithSerialNumber:self.signingCertificate.serialNumber andWithPinCode:self.txtPin.text andWithIdentity:self.signingCertificate.subjectDN.serialNumber];
                                }
                            });
                            
                            
                            NSString *base64String = [signatureData base64EncodedStringWithOptions:0];
                            
                            [weakSelf.parentVC completeSigningWithBase64String:base64String completition:^(BOOL success, NSString* errorContent) {
                                if (success) {
                                    if (errorContent && [errorContent isEqualToString:@"workflow_action"]) {
                                        [weakSelf animateDismissWithCompletitionBlock:^{
                                            [weakSelf.parentVC continueWorkFlowWithBase64String:base64String];
                                        }];
                                    }else{
                                        if (weakSelf.isBatchOperation) {
                                            [weakSelf.parentVC viewController:weakSelf signingCompleteWithSuccess:YES andWithMessage:SSLocalizedString(@"sign_smart_card_success", nil)];
                                        }else{
                                            [weakSelf showAlert:SSLocalizedString(@"e_sign", nil) description:SSLocalizedString(@"sign_smart_card_success", nil) actions:@[[MDCAlertAction actionWithTitle:SSLocalizedString(@"ok", nil) handler:^(MDCAlertAction * _Nonnull action) {
                                                [weakSelf animateDismiss];
                                            }]]];
                                        }
                                    }
                                }else{
                                    [weakSelf setActivityViewHidden:YES];
                                    [weakSelf.btnClose setEnabled:YES];
                                    if (!self.isBatchOperation) {
                                        [weakSelf showError:nil description:(errorContent && errorContent.length > 0) ? errorContent : SSLocalizedString(@"sign_smart_card_error_generic", nil)];
                                    }else{
                                        [self.parentVC viewController:weakSelf signingCompleteWithSuccess:NO andWithMessage:(errorContent && errorContent.length > 0) ? errorContent : SSLocalizedString(@"sign_smart_card_error_generic", nil)];
                                    }
                                }
                            }];
                        }
                    }
                });
            }];
//        });
    }
}

- (void) connectToSmartCard {
    [self updateStatusLabel:SSLocalizedString(@"smart_card_status_connecting", nil)];
    self.signingCertificates = [[NSMutableArray alloc] init];
    NSMutableArray<SmartCardReader*> *smartCardReaders = [[NSMutableArray alloc] init];
    @try {
        [SmartCardReader listAttachedDevices:smartCardReaders];
    } @catch (NSException *exception) {
        [self showError:@"ConnectToSmartCard" description:[NSString stringWithFormat:@"!!! Cannot list attached devices due to %@", [exception reason]]];
        NSLog(@"!!! Cannot list attached devices due to %@", [exception debugDescription]);
    }
    if(smartCardReaders.count > 0){
        NSLog(@"Number of smartcard readers: %lu", (unsigned long)[smartCardReaders count]);
        if (smartCardReaders.count > 1) {
            //Show smart card reader selecttor
            UIAlertController* alertCon = [UIAlertController alertControllerWithTitle:SSLocalizedString(@"sign", nil) message:SSLocalizedString(@"sign_smart_card_please_select_reader", nil) preferredStyle:UIAlertControllerStyleActionSheet];
            for (SmartCardReader* reader in smartCardReaders) {
                [alertCon addAction:[UIAlertAction actionWithTitle:[self getDeviceId:reader] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self didSelectSmartCard:reader];
                }]];
            }
            [alertCon addAction:[UIAlertAction actionWithTitle:SSLocalizedString(@"cancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alertCon animated:YES completion:nil];
        }else{
            [self didSelectSmartCard:smartCardReaders.firstObject];
        }
    }else{
        NSLog(@"Smart Card not found");
        //TODO Eğer bağlı cihaz bulunamaz ise tekrar bağlan veya vazgeç tarzu bir alert gösterilsin
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView.refreshControl endRefreshing];
    });
}


- (void)didSelectSmartCard:(SmartCardReader*)reader{
    self.cardReader = reader;
//    self.selectedDeviceId = [reader getDeviceID];
    self.selectedDeviceId = [self getDeviceId:reader];
    BOOL willShowQRCodeReader = NO;
    [self updateStatusLabel:SSLocalizedString(@"smart_card_status_activating", nil)];
    if (!reader.isRegistered) {
        SmartCardDevice* device = [SmartCardController getDeviceWithDeviceId:[self getDeviceId:reader]];
        if (!device) { //Cihazın kaydı hiç yapılmamış
            willShowQRCodeReader = YES;
        }else{
            @try{
                willShowQRCodeReader = ![self.cardReader activateWithQRCode:device.qrCode];
            }
            @catch(NSException* exception){
                NSLog(@"Error Activating Device: %@",[exception reason]);
                UIAlertController* alertCon = [UIAlertController alertControllerWithTitle:SSLocalizedString(@"error", nil) message:SSLocalizedString(@"sign_smart_card_error_cannot_activate_show_qr_code", nil) preferredStyle:UIAlertControllerStyleAlert];
                [alertCon addAction:[UIAlertAction actionWithTitle:SSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [SmartCardController removeDeviceWithDeviceId:[self getDeviceId:reader]];
                    [self showQRCodeReader];
                }]];
                [self presentViewController:alertCon animated:YES completion:nil];
            }
        }
    }else{
        SmartCardDevice* device = [SmartCardController getDeviceWithDeviceId:[self getDeviceId:reader]];
        BOOL activation =  [self.cardReader activateWithQRCode:device.qrCode];
        NSLog(@"Register with QRCode status: %i",activation);
    }
    if (willShowQRCodeReader) {
        self.selectedDeviceIdToRegister = [self getDeviceId:reader];
        [self showQRCodeReader];
    }else{
        SSLocalizedString(@"smart_card_status_getting_certificates", nil);
        [self setActivityViewHidden:YES];
        NSMutableArray* certArray = @[].mutableCopy;
        NSLog(@"Cert Array : %li",[certArray count]);
        @try {
            [self.cardReader listCertificates:certArray];
            NSLog(@"Cert Array Count 2 : %li",[certArray count]);
        } @catch (NSException *exception) {
            NSLog(@"!!! Cannot list certificates devices due to %@", [exception reason]);
            UIAlertController* alertCon = [UIAlertController alertControllerWithTitle:SSLocalizedString(@"error", nil) message:[exception reason] preferredStyle:UIAlertControllerStyleAlert];
            [alertCon addAction:[UIAlertAction actionWithTitle:SSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [SmartCardController removeDeviceWithDeviceId:[self getDeviceId:reader]];
                [self showQRCodeReader];
            }]];
            [self presentViewController:alertCon animated:YES completion:nil];
        }
        
        for (ArkX509Certificate* certificate in certArray) {
            if (
                [certificate isQualified] &&
                certificate.serialNumber &&
                certificate.serialNumber.length > 0 &&
                [certificate.notAfter compare:[NSDate date]] == NSOrderedDescending)
            {
                BOOL doesHaveCert = NO;
                for (ArkX509Certificate* cert in self.signingCertificates) {
                    if ([cert.serialNumber isEqualToString:certificate.serialNumber]) {
                        NSLog(@">>>>>DOES HAVE CERT!!!!");
                        doesHaveCert = YES;
                        break;
                    }else{
                        NSLog(@">>>>>Certs does not match: CERT: %@ - CERTIFICATE: %@",cert.serialNumber, certificate.serialNumber);
                    }
                }
                if (!doesHaveCert) {
                    [self.signingCertificates addObject:certificate];
                }
            }else{
                NSLog(@"Kriterleri sağlamayan sertifika: NotAfter:%@\nCertificate serial:%@\nisQualified:%i", certificate.notAfter, certificate.serialNumber, certificate.isQualified);
            }
        }
        if(self.signingCertificates.count > 0){
            
            if (_isBatchOperation && self.lastCertSerial) {
                ArkX509Certificate* batchCert;
                for (ArkX509Certificate* cert in self.signingCertificates) {
                    if ([cert.serialNumber isEqualToString:self.lastCertSerial]) {
                        batchCert = cert;
                        break;
                    }
                }
                if (batchCert) {
                    [self selectCertificate:batchCert];
                }else{
                    if (self.signingCertificates.count == 1) {
                        [self selectCertificate:self.signingCertificates[0]];
                    }else{
                        [self updateStatusLabel:SSLocalizedString(@"smart_card_select_a_certificate", nil)];
                    }
                }
            }else{
                if (self.signingCertificates.count == 1) {
                    [self selectCertificate:self.signingCertificates[0]];
                }else{
                    [self updateStatusLabel:SSLocalizedString(@"smart_card_select_a_certificate", nil)];
                }
            }
            
            
        }else{
            [self showAlert:SSLocalizedString(@"error", nil) description:SSLocalizedString(@"sign_smart_cart_certificate_not_found", nil) actions:
             @[
               [MDCAlertAction actionWithTitle:SSLocalizedString(@"ok", nil) handler:^(MDCAlertAction * _Nonnull action) {}]
               ]
             ];
        }
        __weak ESignViewController* weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf setActivityViewHidden:YES];
            [weakSelf.tableView reloadData];
            [weakSelf recalculateViewHeight];
        });
        
    }
}

- (void)recalculateViewHeight{
    CGFloat default_height = 168.0f;
    CGFloat height = default_height + ((self.signingCertificates.count <= 1) ? 0 : self.signingCertificates.count + 1) * 44.0f;
    [UIView animateWithDuration:0.25f animations:^{
        self.consViewHeight.constant = height;
        [self.view layoutIfNeeded];
    }];
}

- (void)showQRCodeReader{
    __weak ESignViewController* weakSelf = self;
    [self showAlert:SSLocalizedString(@"e_sign", nil) description:SSLocalizedString(@"e_sign_alert_register_device_message", nil)
            actions:@[
                      [MDCAlertAction
                       actionWithTitle:SSLocalizedString(@"e_sign_alert_register_device_button_scan_qr_code", nil)
                       handler:^(MDCAlertAction * _Nonnull action) {
                            QRCodeReaderViewController* vc = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Vazgeç" codeReader:weakSelf.reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
                            vc.delegate = weakSelf;
                            [weakSelf presentViewController:vc animated:YES completion:nil];
                       }],
                      [MDCAlertAction
                       actionWithTitle:SSLocalizedString(@"ok", nil)
                       handler:nil]
                      ]
     ];
}
    
- (void)selectCertificate:(ArkX509Certificate*)certificate{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableString* certTitle = certificate.subjectDN.commonName.mutableCopy;
        if (certificate.subjectDN.organizationName && certificate.subjectDN.organizationName.length > 0) {
            [certTitle appendString:[NSString stringWithFormat:@" / %@",certificate.subjectDN.organizationName]];
        }
        
        NSMutableAttributedString* attrStatus = [[NSAttributedString alloc] initWithString:SSLocalizedString(@"smart_card_selected_certificate", nil)].mutableCopy;
        NSAttributedString* attrSelectedCert = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",certTitle] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16 weight:UIFontWeightSemibold],NSForegroundColorAttributeName:[UIColor darkTextColor]}];
        [attrStatus appendAttributedString:attrSelectedCert];
        [self updateStatusLabelWithAtributedString:attrStatus];
        self.txtUsername.text = certificate.subjectDN.commonName;
        self.signingCertificate = certificate;
        [self.btnSign setEnabled:YES animated:YES];
        
        if (self.isBatchOperation && self.lastPinCode) {
            self.txtPin.text = self.lastPinCode;
            [self signDocument:nil];
        }else{
            //26.05.2019 Eğer son kullanılan pin başarılı ise burada saklanıyor
            if (SessionManager.current.lastUsedPin && SessionManager.current.lastUsedPin.length > 0) {
                self.txtPin.text = SessionManager.current.lastUsedPin;
            }else{
                [self.txtPin becomeFirstResponder];
            }
        }
        if ([self.parentVC respondsToSelector:@selector(didSelectCertificateWithSerialNumber:andWithPinCode:andWithIdentity:)]) {
            [self.parentVC didSelectCertificateWithSerialNumber:self.signingCertificate.serialNumber andWithPinCode:self.txtPin.text andWithIdentity:self.signingCertificate.subjectDN.serialNumber];
        }
    });
}

#pragma mark - <QRCodeReaderDelegate>
- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [reader stopScanning];
    
    [self showAlert:SSLocalizedString(@"qr_code", nil) description:result actions:
     @[[MDCAlertAction actionWithTitle:SSLocalizedString(@"cancel", nil) handler:^(MDCAlertAction * action){
            [reader dismissViewControllerAnimated:YES completion:nil];
        }],
        [MDCAlertAction actionWithTitle:SSLocalizedString(@"read_again", nil) handler:^(MDCAlertAction * _Nonnull action) {
            [reader startScanning];
        }],
        [MDCAlertAction actionWithTitle:SSLocalizedString(@"save", nil) handler:^(MDCAlertAction * _Nonnull action) {
        [reader dismissViewControllerAnimated:YES completion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"DeviceId: %@, qrCode:%@",self.selectedDeviceIdToRegister, result);
                [SmartCardController addDeviceWithDeviceId:self.selectedDeviceIdToRegister qrCode:result];
                self.selectedDeviceIdToRegister = nil;
//                [self didSelectSmartCard:self.cardReader];
            });
        }];
    }]
       ] parentVC:reader];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [reader dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <UITableViewDatasource,UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.signingCertificates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    ArkX509Certificate* cert = self.signingCertificates[indexPath.row];
    cell.textLabel.text = cert.subjectDN.commonName;
    cell.detailTextLabel.text = cert.subjectDN.organizationName ? cert.subjectDN.organizationName : @"";
    cell.imageView.image = [UIImage imageNamed:@"certificate"];
    return cell;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ArkX509Certificate* cert = self.signingCertificates[indexPath.row];
    [self selectCertificate:cert];
}


#pragma mark - ReaderInterfaceDelegate

- (void) cardInterfaceDidDetach:(BOOL)attached
{

    if (attached) { //Smart Card inserted
            [self connectToSmartCard];
    }else{
        self.signingCertificate = nil;
        self.signingCertificates = nil;
    }
    NSLog(@"cardInterfaceDidDetach: %i",attached);
}

- (void) readerInterfaceDidChange:(BOOL)attached
{
    NSLog(@"readerInterfaceDidChange: %i",attached);
    if (!attached) {
        self.selectedDeviceId = @"";
        self.cardReader = nil;
        self.signingCertificate = nil;
    }
}

#pragma mark - GestureRecogniserDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return touch.view == gestureRecognizer.view;
}
@end
