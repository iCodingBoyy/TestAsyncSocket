//
//  TestUdpClientAppDelegate.h
//  TestUdpClient
//
//  Created by Xie Wei on 11-6-5.
//  Copyright 2011年 e-linkway.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AsyncUdpSocket.h"
#import "AsyncSocket.h"
@interface TestUdpClientAppDelegate : NSObject <UIApplicationDelegate> 
{
    AsyncUdpSocket             *_udpSocket;
    
    UIButton *_sendButton;

    AsyncSocket  *_listenSocket;
    
    NSMutableArray *_connectedSockets;
    
}

@property (nonatomic, retain)AsyncSocket  *listenSocket;
@property (nonatomic, retain) IBOutlet UIWindow *window;


@end
