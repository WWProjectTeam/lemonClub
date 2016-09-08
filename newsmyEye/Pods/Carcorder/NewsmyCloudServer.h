//
//  NewsmyCloudServer.h
//  Carcorder
//
//  Created by EthanZhang on 15/12/8.
//  Copyright © 2015年 L. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AccountResult;
@class AccountInformation;
@class Device;
@class OBDInformation;
@class DeviceMessage;

@protocol NewsmyCloudServer <NSObject>

/**
 *
 */
-(AccountResult *) verifyAccountID(NSString * accountID);

/**
 *
 */
-(AccountResult *) getCheckCode(NSString * accountID);


/**
 *
 */
-(AccountResult *) registerAccount(NSString * accountID, NSString * passwd);


/**
 *
 */
-(AccountResult *) loginAccount(AccountInformation * accountInfo);


/**
 *
 */
-(AccountResult *) resetPasswd(AccountInformation * accountInfo);

/**
 *
 */
-(AccountInformation *) getAccountInfo(AccountInformation * accountInfo);


/**
 *
 */
-(AccountResult *) accountBindDevice( AccountInformation * accountInfo,
                                     NSString * deviceIMEI);


/**
 *
 */
-(AccountResult *) accountUnBindDevice(AccountInformation * accountInfo,
                                       NSString * deviceIMEI);

/**
 *
 */
-(AccountResult *) accountCreateZone(AccountInformation * accountInfo,  Zone * zone);

/**
 *
 */
-(AccountResult *) accountDestroyZone(AccountInformation * accountInfo, Zone * zone);

/**
 *
 */
-(AccountResult *) deviceAddZone(AccountInformation * accountInfo, Zone * zone);

/**
 *
 */
-(AccountResult *) deviceRemoveZone(Device * device, Zone * zone);

/**
 *
 */
-(AccountResult *) deviceSendMessage(Device * device, DeviceMessage * message);

/**
 *
 */
-(NSArray *) accountQueryDeviceList(AccountInformation * accountInfo );

/**
 *
 */
-(NSArray *) deviceQueryZoneList(Device * device);

/**
 *
 */
-(NSArray *) deviceQueryZoneList(Device * device );

/**
 *
 */
-(OBDInformation *) deviceQueryOBDInfo(Device * device );

/**
 *
 */
-(OBDInformation *) deviceQuerySessionID(Device * device);

@end
