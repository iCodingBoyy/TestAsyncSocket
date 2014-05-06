//
//  TestUdpClientAppDelegate.h
//  TestUdpClient
//
//  Created by Xie Wei on 11-6-5.
//  Copyright 2011年 e-linkway.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AsyncUdpSocket.h"

@interface TestUdpClientAppDelegate : NSObject <UIApplicationDelegate> 
{
    AsyncUdpSocket             *_udpSocket;
    
    UIButton *_sendButton;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) AsyncUdpSocket *udpSocket;


@end
