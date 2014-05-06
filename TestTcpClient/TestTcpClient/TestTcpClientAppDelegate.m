//
//  TestUdpClientAppDelegate.m
//  TestUdpClient
//
//  Created by Xie Wei on 11-6-5.
//  Copyright 2011年 e-linkway.com. All rights reserved.
//

#import "TestTcpClientAppDelegate.h"
#import "AsyncUdpSocket.h"
#import "AsyncSocket.h"
#define SERVER_IP    @"192.168.0.100"
//#define SERVER_IP    @"127.0.0.1"

#define SERVER_PORT  9527


@implementation TestUdpClientAppDelegate


@synthesize window = _window;
@synthesize sendSocket = _sendSocket;

//发送短消息
-(IBAction)sendString
{    
    NSData *data = [@"12345678" dataUsingEncoding: NSUTF8StringEncoding]; 

    static BOOL connectOK = NO;

    if (!_sendSocket)
    {
        self.sendSocket = [[[AsyncSocket alloc] initWithDelegate: self] autorelease];

        NSError *error;
        connectOK = [_sendSocket connectToHost: SERVER_IP onPort: SERVER_PORT error: &error];

        if (!connectOK)
        {
            NSLog(@"connect error: %@", error);
        }

        [_sendSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }

    if (connectOK) 
    {
        [_sendSocket writeData: data withTimeout: -1 tag: 0];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    float button_center_y = 20;
    float button_center_offset = 50;

    _sendButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    _sendButton.frame = CGRectMake(0, 0, 200, 30);
    _sendButton.center = CGPointMake(320 / 2, button_center_y += button_center_offset);
    [_sendButton addTarget: self action: @selector(sendString) forControlEvents: UIControlEventTouchUpInside];
    [_sendButton setTitle: @"Send String" forState: UIControlStateNormal];
    [self.window addSubview: _sendButton];

    [self.window makeKeyAndVisible];

    return YES;
}

#pragma mark - tcp


- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	NSLog(@"%s %d", __FUNCTION__, __LINE__);

    [_sendSocket readDataWithTimeout: -1 tag: 0];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"%s %d, tag = %ld", __FUNCTION__, __LINE__, tag);

    [_sendSocket readDataWithTimeout: -1 tag: 0];
}

// 这里必须要使用流式数据
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *msg = [[[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding] autorelease];

    NSLog(@"%s %d, msg = %@", __FUNCTION__, __LINE__, msg);

    [_sendSocket readDataWithTimeout: -1 tag: 0];
}

//- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
//{
//    NSLog(@"%s %d, err = %@", __FUNCTION__, __LINE__, err);
//}
//
- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);

    self.sendSocket = nil;
}


#pragma mark -

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
