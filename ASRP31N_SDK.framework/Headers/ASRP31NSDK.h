//
//  ASRP31NSDK.h
//  ASRP31NSDK
//
//  Created by Yasutaka Oshiro on 2019/01/29.
//  Copyright © 2019年 Robin. All rights reserved.
//

#import <Foundation/Foundation.h>

//----------------------------------------------
#pragma mark - enum
//----------------------------------------------
typedef NS_ENUM(NSUInteger, ASRP31NSDKNetworkState) {
    ASRP31NSDKNetworkStateUnknown,
    ASRP31NSDKNetworkStateConnected,
    ASRP31NSDKNetworkStateDisconnected,
    ASRP31NSDKNetworkStateError,
};

typedef NS_ENUM(NSUInteger, ASRP31NSDKCommonStatus) {
    ASRP31NSDKCommonStatusNone,
    ASRP31NSDKCommonStatusSuccess,
    ASRP31NSDKCommonStatusFailure,
};


//----------------------------------------------
#pragma mark - interface ASRP31NSDKSDK
//----------------------------------------------
@interface ASRP31NSDK : NSObject

+ (ASRP31NSDK *)sharedInstance;

@property(nonatomic, assign)id delegate;
/* Common */
- (NSString *)getSDKVersion;
- (NSError *)getRFIDMoudleVersion;

/* UDP */
- (NSError *)startSearchDevice;
- (NSError *)stopSearchDevice;

/* TCP */
- (NSError *)connectServer:(NSString*)ip port:(int)port;
- (NSError *)disconnectServer;
- (BOOL)getConnectionStatus;

/* RFID */
// 各アンテナのOutputPowerを同じ値で一括設定
- (NSError *)setOutputPowerLevel:(uint16_t)powerLevel;
// 各アンテナの毎にOutputPowerを個別で設定
- (NSError *)setOutputPowerLevelAntenna1:(uint16_t)powerLevel1
                                Antenna2:(uint16_t)powerLevel2
                                Antenna3:(uint16_t)powerLevel3
                                Antenna4:(uint16_t)powerLevel4
                                Antenna5:(uint16_t)powerLevel5
                                Antenna6:(uint16_t)powerLevel6
                                Antenna7:(uint16_t)powerLevel7
                                Antenna8:(uint16_t)powerLevel8;
- (NSError *)updateRegistry;
- (NSError *)getOutputPowerLevel;
- (NSError *)setSession:(uint8_t)session;
- (NSError *)getSession;
- (NSError *)getFHLBTParam;
- (NSError *)setFHLBTParamRFLevel:(int)rfLevel
                         readTime:(uint16_t)rTime
                         idleTime:(uint16_t)iTime
                 carrierSenseTime:(uint16_t)cTime
                 frequencyHopping:(uint8_t)fh
                 listenBeforeTalk:(uint8_t)lbt
                   continuousWave:(uint8_t)cw;

- (NSError *)startMultiReadTags:(uint8_t)mtnu
                          mtime:(uint8_t)mtime
                    repeatCycle:(uint16_t)repeatCycle
                  Antenna1Enable:(BOOL)enable1
                  Antenna2Enable:(BOOL)enable2
                  Antenna3Enable:(BOOL)enable3
                  Antenna4Enable:(BOOL)enable4
                  Antenna5Enable:(BOOL)enable5
                  Antenna6Enable:(BOOL)enable6
                  Antenna7Enable:(BOOL)enable7
                  Antenna8Enable:(BOOL)enable8
                  RSSIEnable:(BOOL)isOnRSSI;

- (NSError *)stopReadTags;

/* 20190410 Added by Robin */
- (NSError *)getRegion;
- (NSError *)getReaderInfo;
- (NSError *)getChannel;
- (NSError *)getOutputPowerLevelForMultiAntenna;
- (NSError *)getReadTimeForMultiAntenna;
- (NSError *)setChannel:(uint8_t)channel;
// 各アンテナのReadTimeを同じ値で一括設定
- (NSError *)setReadTime:(uint16_t)readTime;
// 各アンテナのReadTimeを個別に設定
- (NSError *)setReadTimeForMultiAntenna1:(uint16_t)readTime1
                                Antenna2:(uint16_t)readTime2
                                Antenna3:(uint16_t)readTime3
                                Antenna4:(uint16_t)readTime4
                                Antenna5:(uint16_t)readTime5
                                Antenna6:(uint16_t)readTime6
                                Antenna7:(uint16_t)readTime7
                                Antenna8:(uint16_t)readTime8;

- (NSError *)getFreqHoppingTable;
- (NSError *)getAnticollision;
- (NSError *)setAnticollision:(uint8_t)mode;
- (NSError *)getSmartHoppingOnOff;
- (NSError *)setSmartHoppingOnOff:(BOOL)isOn;
- (NSError *)setOptimumFrequencyHoppingTable;
- (NSError *)setKillTag:(uint32_t)killPassword epc:(NSData*)epc;

- (NSError *)setLockTagMemory:(uint32_t)accessPassword
                          epc:(NSData*)epc
                     lockData:(uint32_t)lockData;

- (NSError *)setWriteToTagMemory:(uint32_t)accessPassword
                             epc:(NSData*)epc
                      memoryBank:(uint8_t)memoryBank
                    startAddress:(uint16_t)startAddress
                     dataToWrite:(NSData*)dataToWrite;

- (NSError *)readFromTagMemory:(uint32_t)accessPassword
                          epc:(NSData*)epc
                   memoryBank:(uint8_t)memoryBank
                 startAddress:(uint16_t)startAddress
                   dataLength:(uint16_t)dataLength;


-(BOOL) setDHCPOnMac:(NSString*)macAddr;
-(BOOL) setDHCPOffMac:(NSString*)macAddr IP:(NSString*)ip Subnet:(NSString*)subnet GateWay:(NSString*)gateWay DNSServer:(NSString*)dnsServer;


@end

//----------------------------------------------
#pragma mark - protocol ASRP31NSDKDelegate
//----------------------------------------------
@protocol ASRP31NSDKDelegate <NSObject>

@optional
/* Common */
- (void)ASRP31N:(ASRP31NSDK *)ASRP31N updatedRegistryStatus:(uint8_t)statusCode;
- (void)ASRP31N:(ASRP31NSDK *)ASRP31N receivedSession:(uint8_t)session;
- (void)ASRP31N:(ASRP31NSDK *)ASRP31N receivedDidSetSessionState:(ASRP31NSDKCommonStatus)statusCode;
- (void)ASRP31N:(ASRP31NSDK *)ASRP31N readerConnectedStatus:(ASRP31NSDKCommonStatus)statusCode;

/* Network */
/* TCP */
- (void)ASRP31N:(ASRP31NSDK *)ASRP31N changeNetworkState:(ASRP31NSDKNetworkState)state error:(NSError *)error;

/* UDP */
- (void)ASRP31N:(ASRP31NSDK *)ASRP31N searchingIP:(NSString *)ip isFinish:(BOOL)isFinish;
- (void)ASRP31N:(ASRP31NSDK *)ASRP31N searchedUPDSearchingDeviceInfo:(NSArray *)arrInfos;

/* RFID */
- (void)ASRP31N:(ASRP31NSDK *)ASRP31N didSetOutputPowerForMultiAntenna:(ASRP31NSDKCommonStatus)statusCode;

/* Not use for Multi Antenna */
//- (void)ASRP31:(ASRP31NSDK *)ASRP31 outputPowerLevelReceived:(uint16_t)pLevel maxPower:(uint16_t)max minPower:(uint16_t)min;

- (void)ASRP31N:(ASRP31NSDK *)ASRP31N receivedFHLBT:(NSData *)fhlb;
- (void)ASRP31N:(ASRP31NSDK *)ASRP31N receivedDidSetFHLBT:(ASRP31NSDKCommonStatus)statusCode;
- (void)ASRP31N:(ASRP31NSDK *)ASRP31N receivedPCEPCData:(NSData *)pcEpc selectAntena:(int)antenna;
- (void)ASRP31N:(ASRP31NSDK *)ASRP31N receivedPCEPCData:(NSData *)pcEpc selectAntena:(int)antenna rssi:(int)rssiVal;
- (void)ASRP31N:(ASRP31NSDK *)ASRP31N receivedWritedStatus:(ASRP31NSDKCommonStatus)statusCode;
- (void)ASRP31N:(ASRP31NSDK *)ASRP31N receivedStoppedReadTagsStatus:(ASRP31NSDKCommonStatus)statusCode;


/* 20190410 Added by Robin */
- (void)ASRP31N:(ASRP31NSDK *)ASRP31N receivedTagMemory:(NSData *)data;
- (void)ASRP31N:(ASRP31NSDK *)ASRP31N receivedRegion:(uint8_t)region;
- (void)ASRP31N:(ASRP31NSDK *)ASRP31N receivedRfidModuleVersion:(NSString *)version;
- (void)ASRP31N:(ASRP31NSDK *)ASRP31N receivedChannel:(uint8_t)channel offset:(uint8_t)offset;

- (void)ASRP31N:(ASRP31NSDK *)ASRP31N receivedReadTimeAntenna1:(uint16_t)antenna1
                                                      Antenna2:(uint16_t)antenna2
                                                      Antenna3:(uint16_t)antenna3
                                                      Antenna4:(uint16_t)antenna4
                                                      Antenna5:(uint16_t)antenna5
                                                      Antenna6:(uint16_t)antenna6
                                                      Antenna7:(uint16_t)antenna7
                                                      Antenna8:(uint16_t)antenna8;

- (void)ASRP31N:(ASRP31NSDK *)ASRP31N receivedOuputPowerAntenna1:(uint16_t)antenna1
                                                        Antenna2:(uint16_t)antenna2
                                                        Antenna3:(uint16_t)antenna3
                                                        Antenna4:(uint16_t)antenna4
                                                        Antenna5:(uint16_t)antenna5
                                                        Antenna6:(uint16_t)antenna6
                                                        Antenna7:(uint16_t)antenna7
                                                        Antenna8:(uint16_t)antenna8
                                                        Min:(uint16_t)min
                                                        Max:(uint16_t)max;

- (void)ASRP31N:(ASRP31NSDK *)ASRP31N didSetReadTimeForMultiAntenna:(ASRP31NSDKCommonStatus)statusCode;
- (void)ASRP31N:(ASRP31NSDK *)ASRP31N receivedHoppingTable:(NSData *)table;
- (void)ASRP31N:(ASRP31NSDK *)ASRP31N receivedDidSetChParam:(uint8_t)statusCode;
- (void)ASRP31N:(ASRP31NSDK *)ASRP31N receivedAnticollison:(uint8_t)param;

- (void)ASRP31N:(ASRP31NSDK *)ASRP31N receivedDidSetAntiCollision:(uint8_t)statusCode;
- (void)ASRP31N:(ASRP31NSDK *)ASRP31N receivedDidSetOptiFreqHPTable:(uint8_t)statusCode;
- (void)ASRP31N:(ASRP31NSDK *)ASRP31N receivedSmartHopping:(BOOL)isON;

- (void)ASRP31N:(ASRP31NSDK *)ASRP31N receivedDidKilled:(uint8_t)statusCode;
- (void)ASRP31N:(ASRP31NSDK *)ASRP31N receivedDidSetSmartHopping:(uint8_t)statusCode;
- (void)ASRP31N:(ASRP31NSDK *)ASRP31N receivedDidWriteTag:(uint8_t)statusCode;
- (void)ASRP31N:(ASRP31NSDK *)ASRP31N receivedDidLocked:(uint8_t)statusCode;

- (void)ASRP31N:(ASRP31NSDK *)ASRP31N receivedErrDetail:(NSData *)errCode;
@end
