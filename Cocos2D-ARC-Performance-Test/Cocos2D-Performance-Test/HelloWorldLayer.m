//
//  HelloWorldLayer.m
//  Cocos2D-Performance-Test
//
//  Copyright Steffen Itterheim 2011. Distributed under MIT License.
//

#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"

static HelloWorldLayer* instance;

@interface HelloWorldLayer (PrivateMethods)
-(void) test:(ccTime)delta;
@end

@implementation HelloWorldLayer

@synthesize testNode;

+(HelloWorldLayer*) sharedLayer
{
	return instance;
}

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	HelloWorldLayer *layer = [HelloWorldLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if ((self = [super init]))
	{
		instance = self;
		
		testNode = [CCNode node];
		[self addChild:testNode];
		
		SimpleAudioEngine* simpleAudio = [SimpleAudioEngine sharedEngine];
		[simpleAudio preloadEffect:@"dp2.caf"];
		
		CGSize winSize = [CCDirector sharedDirector].winSize;

		CCLabelTTF* label = [CCLabelTTF labelWithString:@"Testing ... be patient!" fontName:@"Arial" fontSize:30];
		label.position = CGPointMake(winSize.width / 2, winSize.height / 2);
		label.color = ccYELLOW;
		[self addChild:label];

		CCLabelTTF* label2 = [CCLabelTTF labelWithString:@"Enable Xcode Debug Console to see progress:" fontName:@"Arial" fontSize:16];
		label2.position = CGPointMake(winSize.width / 2, winSize.height / 2 - 35);
		label2.color = ccGREEN;
		[self addChild:label2];
		
		CCLabelTTF* label3 = [CCLabelTTF labelWithString:@"View -> Debug Area -> Activate Console" fontName:@"Arial" fontSize:16];
		label3.position = CGPointMake(winSize.width / 2, winSize.height / 2 - 60);
		label3.color = ccGREEN;
		[self addChild:label3];

		[self schedule:@selector(test:) interval:0.2f];
	}
	return self;
}

// Test done in onEnter to make sure Cocos2D is fully initialized
-(void) test:(ccTime)delta
{
	[self unschedule:_cmd];

	pt = [[PerfTester alloc] init];
	pt.quickTest = NO;
	
	[pt test:kkPerformanceTestARCvsMRC_Messaging];
	[pt test:kkPerformanceTestARCvsMRC_AllocInit];
	[pt test:kkPerformanceTestARCvsMRC_Autorelease];
	[pt test:kkPerformanceTestARCvsMRC_Algorithm];
	
	[pt test:KKPerformanceTestTextureLoading];
	[pt test:kkPerformanceTestNodeHierarchy];
	[pt test:kkPerformanceTestArray];
	[pt test:KKPerformanceTestObjectCreation];
	[pt test:KKPerformanceTestMessaging];
	[pt test:kkPerformanceTestObjectCompare];
	[pt test:kkPerformanceTestArithmetic];
	[pt test:kkPerformanceTestMemory];
	[pt test:KKPerformanceTestIO];
	[pt test:kkPerformanceTestMisc];
	
	[pt printResultsToStandardOutput];
	[pt showResultsInView:[CCDirector sharedDirector].view];
	
	NSLog(@"Tests finishiablyed!");
	[[SimpleAudioEngine sharedEngine] playEffect:@"dp2.caf"];
	
	self.touchEnabled = YES;
}

-(void) dealloc
{
	instance = nil;
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[[pt webView] goBack];
	
}
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[[pt webView] goBack];
}

@end
