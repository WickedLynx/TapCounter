#import <Foundation/Foundation.h>
#import <IOKit/hid/IOHIDEventSystemClient.h>
#import <IOKit/hid/IOHIDEventSystem.h>
#import <notify.h>

static long long taps = 0;
NSString *const TapCountFilePath = @"/var/mobile/Library/Preferences/com.lbs.tapCounter";

IOHIDEventSystemClientRef IOHIDEventSystemClientCreate(CFAllocatorRef allocator);

void writeTapsToFile();

void handle_event(void* target, void* refcon, IOHIDEventQueueRef queue, IOHIDEventRef event) {
    if (IOHIDEventGetType(event) == kIOHIDEventTypeDigitizer) {
        uint32_t flags = IOHIDEventGetEventFlags(event);
        if (flags == 524307) {
            NSLog(@"taps: %llu", taps);
            taps++;
            notify_post("com.laughing-buddha-software.tapCounter.changed");
            writeTapsToFile();
        }
    }
}

void writeTapsToFile() {
    NSString *tapString = [NSString stringWithFormat:@"%lld", taps];
    [tapString writeToFile:TapCountFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

int main (int argc, const char * argv[]) {
    
    @autoreleasepool {
        IOHIDEventSystemClientRef ioHIDEventSystem = IOHIDEventSystemClientCreate(kCFAllocatorDefault);
        IOHIDEventSystemClientScheduleWithRunLoop(ioHIDEventSystem, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
        IOHIDEventSystemClientRegisterEventCallback(ioHIDEventSystem, handle_event, NULL, NULL);
        
        int resetToken;
        notify_register_dispatch("com.laughing-buddha-software.tapCounter.reset",
                                 &resetToken,
                                 dispatch_get_main_queue(), ^(int t) {
                                     taps = 0;
                                     writeTapsToFile();
                                 });
        
        CFRunLoopRun();
    }
    
}

// vim:ft=objc
