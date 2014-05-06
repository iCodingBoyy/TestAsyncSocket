//
//  TestUdpClientAppDelegate.m
//  TestUdpClient
//
//  Created by Xie Wei on 11-6-5.
//  Copyright 2011年 e-linkway.com. All rights reserved.
//

#import "TestTcpServerAppDelegate.h"
#import "AsyncSocket.h"

#define SERVER_PORT  9527


@implementation TestUdpClientAppDelegate

@synthesize window = _window;
@synthesize listenSocket = _listenSocket;

bool isRunning= NO;

//发送短消息
- (void)startStop{
	if(!isRunning)
	{
		
		NSError *error = nil;
		if(![_listenSocket acceptOnPort:9527 error:&error])
		{

			return;
		}
		NSLog(@"开始监听");

		isRunning = YES;

	}
	else
	{	NSLog(@"删除重新监听");
		// Stop accepting connections
		[_listenSocket disconnect];
        
		// Stop any client connections
		int i;
		for(i = 0; i < [_connectedSockets count]; i++)
		{

			[[_connectedSockets objectAtIndex:i] disconnect];
		}
		

		isRunning = false;
		
	}
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    float button_center_y = 20;
    float button_center_offset = 50;
//    
    _sendButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    _sendButton.frame = CGRectMake(0, 0, 200, 30);
    _sendButton.center = CGPointMake(320 / 2, button_center_y += button_center_offset);
    [_sendButton addTarget: self action: @selector(sendString) forControlEvents: UIControlEventTouchUpInside];
    [_sendButton setTitle: @"Send String" forState: UIControlStateNormal];
    [self.window addSubview: _sendButton];

    self.listenSocket = [[AsyncSocket alloc] initWithDelegate: self]; 

    [self startStop];
    _connectedSockets = [[NSMutableArray alloc] initWithCapacity:1];
    
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
	[_connectedSockets addObject:newSocket];
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	NSLog(@"%s %d", __FUNCTION__, __LINE__);
	
	NSString *welcomeMsg = @"Welcome to the AsyncSocket Echo Server\r\n";
	NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
	
	[sock writeData:welcomeData withTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	//[sock readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:0];        // 这句话仅仅接收\r\n的数据
   
    [sock readDataWithTimeout: -1 tag: 0];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	NSString *msg = [[[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding] autorelease];
	if(msg)
	{
        NSLog(@"message--->收到---%@",msg);
	}
	else
	{
		NSLog(@"Error converting received data into UTF-8 String");
	}
	
	// Even if we were unable to write the incoming data to the log,
	// we're still going to echo it back to the client.
	[sock writeData:data withTimeout:-1 tag:1];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
	[_connectedSockets removeObject:sock];
}


#pragma mark -

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
