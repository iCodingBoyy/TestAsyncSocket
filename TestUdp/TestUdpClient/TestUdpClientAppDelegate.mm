//
//  TestUdpClientAppDelegate.m
//  TestUdpClient
//
//  Created by Xie Wei on 11-6-5.
//  Copyright 2011年 e-linkway.com. All rights reserved.
//

#import "TestUdpClientAppDelegate.h"
#import "AsyncUdpSocket.h"

#define SERVER_IP    @"10.0.1.1"
#define SERVER_PORT  9527


@implementation TestUdpClientAppDelegate


@synthesize window = _window;

@synthesize udpSocket = _udpSocket;

//发送短消息
-(IBAction)sendString
{
    static int i = 0;

    NSString *messageStr = [NSString stringWithFormat: @"发送的内容%d", i++];

	//开始发送
	BOOL res = [self.udpSocket sendData: [messageStr dataUsingEncoding: NSUTF8StringEncoding] 
								 toHost: SERVER_IP 
								   port: SERVER_PORT 
							withTimeout: -1 
									tag: i++];
    
	if (!res)
    {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"提示"
														message: @"发送失败"
													   delegate: self
											  cancelButtonTitle: @"取消"
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //初始化udp    
    self.udpSocket = [[[AsyncUdpSocket alloc] initWithDelegate: self] autorelease];

    NSError *error = nil;

    [self.udpSocket bindToPort: 9527 error: &error];
    [_udpSocket receiveWithTimeout: -1 tag: 0];

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


#pragma mark -

/**
 * Called when the datagram with the given tag has been sent.
 **/
- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}

/**
 * Called if an error occurs while trying to send a datagram.
 * This could be due to a timeout, or something more serious such as the data being too large to fit in a sigle packet.
 **/
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}

/**
 * Called when the socket has received the requested datagram.
 * 
 * Due to the nature of UDP, you may occasionally receive undesired packets.
 * These may be rogue UDP packets from unknown hosts,
 * or they may be delayed packets arriving after retransmissions have already occurred.
 * It's important these packets are properly ignored, while not interfering with the flow of your implementation.
 * As an aid, this delegate method has a boolean return value.
 * If you ever need to ignore a received packet, simply return NO,
 * and AsyncUdpSocket will continue as if the packet never arrived.
 * That is, the original receive request will still be queued, and will still timeout as usual if a timeout was set.
 * For example, say you requested to receive data, and you set a timeout of 500 milliseconds, using a tag of 15.
 * If rogue data arrives after 250 milliseconds, this delegate method would be invoked, and you could simply return NO.
 * If the expected data then arrives within the next 250 milliseconds,
 * this delegate method will be invoked, with a tag of 15, just as if the rogue data never appeared.
 * 
 * Under normal circumstances, you simply return YES from this method.
 **/
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    NSString *s = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] autorelease];
    NSLog(@"didReceiveData, host = %@, tag = %ld, s = %@", host, tag, s);

    return NO;
}
/**
 * Called if an error occurs while trying to receive a requested datagram.
 * This is generally due to a timeout, but could potentially be something else if some kind of OS error occurred.
 **/
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}

/**
 * Called when the socket is closed.
 * A socket is only closed if you explicitly call one of the close methods.
 **/
- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}

#pragma mark -

- (void)dealloc
{
    self.udpSocket = nil;

    [_window release];
    [super dealloc];
}

@end
