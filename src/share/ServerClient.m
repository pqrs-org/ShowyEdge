#import "ServerClient.h"
#import "SharedKeys.h"
#import "weakify.h"

@interface ServerClient ()

@property dispatch_queue_t connectionQueue;
@property NSDistantObject<ServerClientProtocol>* connection;
@property(readonly) NSDistantObject<ServerClientProtocol>* proxy;

@end

@implementation ServerClient

- (NSDistantObject<ServerClientProtocol>*)proxy {
  @weakify(self);

  dispatch_sync(self.connectionQueue, ^{
    @strongify(self);
    if (!self) return;

    if (!self.connection) {
      // We should catch NSInvalidReceivePortException in block.
      @try {
        self.connection = (NSDistantObject<ServerClientProtocol>*)([NSConnection rootProxyForConnectionWithRegisteredName:kShowyEdgeConnectionName host:nil]);
        [self.connection setProtocolForProxy:@protocol(ServerClientProtocol)];
      } @catch (...) {
        //NSLog(@"catch exception in [ServerClient proxy]");
        self.connection = nil;
      }
    }
  });
  return self.connection;
}

- (void)observer_NSConnectionDidDieNotification:(NSNotification*)__unused notification {
  @weakify(self);

  dispatch_sync(self.connectionQueue, ^{
    @strongify(self);
    if (!self) return;

    NSLog(@"observer_NSConnectionDidDieNotification is called");
    self.connection = nil;
  });
}

- (instancetype)init {
  self = [super init];

  if (self) {
    _connectionQueue = dispatch_queue_create("org.pqrs.ShowyEdge.ServerClient.connectionQueue", NULL);

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(observer_NSConnectionDidDieNotification:)
                                                 name:NSConnectionDidDieNotification
                                               object:nil];
  }

  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - ServerClientProtocol

/*
  Ignore NSInvalidReceivePortException.
  We have to catch NSInvalidReceivePortException in both [ServerClient proxy] and here.
*/
#define NOEXCEPTION(CODE)                           \
  @try {                                            \
    CODE;                                           \
  } @catch (...) {                                  \
    /* NSLog(@"catch exception in NOEXCEPTION"); */ \
  }

- (NSString*)bundleVersion {
  NOEXCEPTION(return [self.proxy bundleVersion]);
  return nil;
}

- (bycopy PreferencesModel*)preferencesModel {
  NOEXCEPTION(return [self.proxy preferencesModel]);
  return nil;
}

- (void)savePreferencesModel:(bycopy PreferencesModel*)preferencesModel processIdentifier:(int)processIdentifier {
  NOEXCEPTION(return [self.proxy savePreferencesModel:preferencesModel processIdentifier:processIdentifier]);
}

- (void)updateStartAtLogin {
  NOEXCEPTION([self.proxy updateStartAtLogin]);
}

- (NSString*)currentInputSourceID {
  NOEXCEPTION(return [self.proxy currentInputSourceID]);
  return nil;
}

- (NSString*)currentInputModeID {
  NOEXCEPTION(return [self.proxy currentInputModeID]);
  return nil;
}

- (void)terminateServerProcess {
  NOEXCEPTION([self.proxy terminateServerProcess]);
}

- (void)checkForUpdatesStableOnly {
  NOEXCEPTION([self.proxy checkForUpdatesStableOnly]);
}

- (void)checkForUpdatesWithBetaVersion {
  NOEXCEPTION([self.proxy checkForUpdatesWithBetaVersion]);
}

@end
