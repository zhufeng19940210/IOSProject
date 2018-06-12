//  RunLoopVC.m
//  iosProject2
//  Created by bailing on 2018/6/9.
//  Copyright © 2018年 zhufeng. All rights reserved.

#import "RunLoopVC.h"

@interface RunLoopVC ()

@end

@implementation RunLoopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //https://www.cnblogs.com/jiangzzz/p/5619512.html
    /*
    1.runloop是什么／runloop的概念？
    2.NSRunLoop 和 CFRunLoopRef？
    3.runloop和线程的关系？
    4.runloop对外接口／runloop的几个类？
    5.runloop内部逻辑？
    6.runloop应用场景？
    */
    //详解说明
    /*
      1.runloop的概念
         Run loops是线程相关的的基础框架的一部分。一个run loop就是一个事件处理的循环，
         用来不停的调度工作以及处理输入事件。其实内部就是do－while循环，这个循环内部不
         断地处理各种任务（比 如Source，Timer，Observer）。使用run loop的目的是让
         你的线程在有工作的时候忙于工作，而没工作的时候处于休眠状态。
     2.NSRunLoop 和 CFRunLoopRef？
         我们不能再一个线程中去操作另外一个线程的run loop对象，那很可能会造成意想不到的后
         果。不过幸运的是CoreFundation中的不透明类CFRunLoopRef是线程安全的，而且两种
         类型的run loop完全可以混合使用。Cocoa中的NSRunLoop类可以通过实例方法：
         - (CFRunLoopRef)getCFRunLoop;
        获取对应的CFRunLoopRef类，来达到线程安全的目的。
        CFRunLoopRef 是在 CoreFoundation 框架内的，它提供了纯 C 函数的 API，
         所有这些 API 都是线程安全的。
        NSRunLoop 是基于 CFRunLoopRef 的封装，提供了面向对象的 API，但是这些 API
        不是线程安全的。
     3.runloop和线程的关系是什么？
            Run loop，正如其名，loop表示某种循环，和run放在一起就表示一直在运行着的循环。
            实际上，run loop和线程是紧密相连的，可以这样说run loop是为了线程而生，没有线程
            它就没有存在的必要。Run loops是线程的基础架构部分，Cocoa和CoreFundation都
            提供了run loop对象方便配置和管理线程的run loop（以下都已Cocoa为例）。
            每个线程，包括程序的主线程（main thread）都有与之相应的run loop对象。
        3.1 主线程的run loop默认是启动的。
        iOS的应用程序里面，程序启动后会有一个如下的main()函数：
        复制代码
        int main(int argc,char *argv[])
        {
        @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([appDelegate class]));
        }
        }
     复制代码
     重点是UIApplicationMain()函数，这个方法会为main thread设置一个NSRunLoop对象，这就解释了本文开始说的为什么我们的应用可以在无人操作的时候休息，需要让它干活的时候又能立马响应。
     
     3.2 对其它线程来说，run loop默认是没有启动的，如果你需要更多的线程交互则可以手动配置和启动，如果线程只是去执行一个长时间的已确定的任务则不需要。
     3.3 在任何一个Cocoa程序的线程中，都可以通过：
     NSRunLoop   *runloop = [NSRunLoopcurrentRunLoop];
     来获取到当前线程的run loop。

     4.runloop对外接口／runloop的几个类？
        CFRunLoopRef
        CFRunLoopModeRef
        CFRunLoopSourceRef
        CFRunLoopTimerRef
        CFRunLoopObserverRef
        一个 RunLoop 包含若干个 Mode，每个 Mode 又包含若干个 Source/Timer/Observer。每次调用 RunLoop 的主函数时，只能指定其中一个 Mode，这个Mode被称作 CurrentMode。如果需要切换 Mode，只能退出 Loop，再重新指定一个 Mode 进入。这样做主要是为了分隔开不同组的 Source/Timer/Observer，让其互不影响。
     CFRunLoopSourceRef 是事件产生的地方。Source有两个版本：Source0 和 Source1。
     • Source0 只包含了一个回调（函数指针），它并不能主动触发事件。使用时，你需要先调用 CFRunLoopSourceSignal(source)，将这个 Source 标记为待处理，然后手动调用 CFRunLoopWakeUp(runloop) 来唤醒 RunLoop，让其处理这个事件。
     • Source1 包含了一个 mach_port 和一个回调（函数指针），被用于通过内核和其他线程相互发送消息。这种 Source 能主动唤醒 RunLoop 的线程，其原理在下面会讲到。
     
     CFRunLoopTimerRef 是基于时间的触发器，它和 NSTimer 是toll-free bridged 的，可以混用。其包含一个时间长度和一个回调（函数指针）。当其加入到 RunLoop 时，RunLoop会注册对应的时间点，当时间点到时，RunLoop会被唤醒以执行那个回调。
     
     CFRunLoopObserverRef 是观察者，每个 Observer 都包含了一个回调（函数指针），当 RunLoop 的状态发生变化时，观察者就能通过回调接受到这个变化。可以观测的时间点有以下几个：
     6.runloop的使用场景:
     1AutoreleasePool
     App启动后，苹果在主线程 RunLoop 里注册了两个 Observer，其回调都是 _wrapRunLoopWithAutoreleasePoolHandler()。
     
     第一个 Observer 监视的事件是 Entry(即将进入Loop)，其回调内会调用 _objc_autoreleasePoolPush() 创建自动释放池。其 order 是-2147483647，优先级最高，保证创建释放池发生在其他所有回调之前。
     
     第二个 Observer 监视了两个事件： BeforeWaiting(准备进入休眠) 时调用_objc_autoreleasePoolPop() 和 _objc_autoreleasePoolPush() 释放旧的池并创建新池；Exit(即将退出Loop) 时调用 _objc_autoreleasePoolPop() 来释放自动释放池。这个 Observer 的 order 是 2147483647，优先级最低，保证其释放池子发生在其他所有回调之后。
     
     在主线程执行的代码，通常是写在诸如事件回调、Timer回调内的。这些回调会被 RunLoop 创建好的 AutoreleasePool 环绕着，所以不会出现内存泄漏，开发者也不必显示创建 Pool 了。
     
     6.2定时器
     NSTimer 其实就是 CFRunLoopTimerRef，他们之间是 toll-free bridged 的。一个 NSTimer 注册到 RunLoop 后，RunLoop 会为其重复的时间点注册好事件。例如 10:00, 10:10, 10:20 这几个时间点。RunLoop为了节省资源，并不会在非常准确的时间点回调这个Timer。Timer 有个属性叫做 Tolerance (宽容度)，标示了当时间点到后，容许有多少最大误差。
     
     如果某个时间点被错过了，例如执行了一个很长的任务，则那个时间点的回调也会跳过去，不会延后执行。就比如等公交，如果 10:10 时我忙着玩手机错过了那个点的公交，那我只能等 10:20 这一趟了。
     
     CADisplayLink 是一个和屏幕刷新率一致的定时器（但实际实现原理更复杂，和 NSTimer 并不一样，其内部实际是操作了一个 Source）。如果在两次屏幕刷新之间执行了一个长任务，那其中就会有一帧被跳过去（和 NSTimer 相似），造成界面卡顿的感觉。在快速滑动TableView时，即使一帧的卡顿也会让用户有所察觉。Facebook 开源的 AsyncDisplayLink 就是为了解决界面卡顿的问题，其内部也用到了 RunLoop，这个稍后我会再单独写一页博客来分析。
     
     6.3PerformSelecter
     当调用 NSObject 的 performSelecter:afterDelay: 后，实际上其内部会创建一个 Timer 并添加到当前线程的 RunLoop 中。所以如果当前线程没有 RunLoop，则这个方法会失效。
     
     当调用 performSelector:onThread: 时，实际上其会创建一个 Timer 加到对应的线程去，同样的，如果对应线程没有 RunLoop 该方法也会失效。
     
     6.4事件响应
     苹果注册了一个 Source1 (基于 mach port 的) 用来接收系统事件，其回调函数为 __IOHIDEventSystemClientQueueCallback()。
     
     当一个硬件事件(触摸/锁屏/摇晃等)发生后，首先由 IOKit.framework 生成一个 IOHIDEvent 事件并由 SpringBoard 接收。SpringBoard 只接收按键(锁屏/静音等)，触摸，加速，接近传感器等几种 Event，随后用 mach port 转发给需要的App进程。随后苹果注册的那个 Source1 就会触发回调，并调用 _UIApplicationHandleEventQueue() 进行应用内部的分发。
     
     _UIApplicationHandleEventQueue() 会把 IOHIDEvent 处理并包装成 UIEvent 进行处理或分发，其中包括识别 UIGesture/处理屏幕旋转/发送给 UIWindow 等。通常事件比如 UIButton 点击、touchesBegin/Move/End/Cancel 事件都是在这个回调中完成的。
     
     6.5手势识别
     当上面的 _UIApplicationHandleEventQueue() 识别了一个手势时，其首先会调用 Cancel 将当前的 touchesBegin/Move/End 系列回调打断。随后系统将对应的 UIGestureRecognizer 标记为待处理。
     
     苹果注册了一个 Observer 监测 BeforeWaiting (Loop即将进入休眠) 事件，这个Observer的回调函数是 _UIGestureRecognizerUpdateObserver()，其内部会获取所有刚被标记为待处理的 GestureRecognizer，并执行GestureRecognizer的回调。
     
     当有 UIGestureRecognizer 的变化(创建/销毁/状态改变)时，这个回调都会进行相应处理。
     
     6.6界面更新
     当在操作 UI 时，比如改变了 Frame、更新了 UIView/CALayer 的层次时，或者手动调用了 UIView/CALayer 的 setNeedsLayout/setNeedsDisplay方法后，这个 UIView/CALayer 就被标记为待处理，并被提交到一个全局的容器去。
     
     苹果注册了一个 Observer 监听 BeforeWaiting(即将进入休眠) 和 Exit (即将退出Loop) 事件，回调去执行一个很长的函数：
     _ZN2CA11Transaction17observer_callbackEP19__CFRunLoopObservermPv()。这个函数里会遍历所有待处理的 UIView/CAlayer 以执行实际的绘制和调整，并更新 UI 界面。
     
     这个函数内部的调用栈大概是这样的：
     
     复制代码
     _ZN2CA11Transaction17observer_callbackEP19__CFRunLoopObservermPv()
     QuartzCore:CA::Transaction::observer_callback:
     CA::Transaction::commit();
     CA::Context::commit_transaction();
     CA::Layer::layout_and_display_if_needed();
     CA::Layer::layout_if_needed();
     [CALayer layoutSublayers];
     [UIView layoutSubviews];
     CA::Layer::display_if_needed();
     [CALayer display];
     [UIView drawRect];
     复制代码
     6.7关于GCD
     实际上 RunLoop 底层也会用到 GCD 的东西。但同时 GCD 提供的某些接口也用到了 RunLoop， 例如 dispatch_async()。
     
     当调用 dispatch_async(dispatch_get_main_queue(), block) 时，libDispatch 会向主线程的 RunLoop 发送消息，RunLoop会被唤醒，并从消息中取得这个 block，并在回调 __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__() 里执行这个 block。但这个逻辑仅限于 dispatch 到主线程，dispatch 到其他线程仍然是由 libDispatch 处理的。
     
     6.8关于网络请求
     iOS 中，关于网络请求的接口自下至上有如下几层:
     
     CFSocket
     CFNetwork       ->ASIHttpRequest
     NSURLConnection ->AFNetworking
     NSURLSession    ->AFNetworking2, Alamofire
     • CFSocket 是最底层的接口，只负责 socket 通信。
     • CFNetwork 是基于 CFSocket 等接口的上层封装，ASIHttpRequest 工作于这一层。
     • NSURLConnection 是基于 CFNetwork 的更高层的封装，提供面向对象的接口，AFNetworking 工作于这一层。
     • NSURLSession 是 iOS7 中新增的接口，表面上是和 NSURLConnection 并列的，但底层仍然用到了 NSURLConnection 的部分功能 (比如 com.apple.NSURLConnectionLoader 线程)，AFNetworking2 和 Alamofire 工作于这一层。
     
     下面主要介绍下 NSURLConnection 的工作过程。
     
     通常使用 NSURLConnection 时，你会传入一个 Delegate，当调用了 [connection start] 后，这个 Delegate 就会不停收到事件回调。实际上，start 这个函数的内部会会获取 CurrentRunLoop，然后在其中的 DefaultMode 添加了4个 Source0 (即需要手动触发的Source)。CFMultiplexerSource 是负责各种 Delegate 回调的，CFHTTPCookieStorage 是处理各种 Cookie 的。
     
     当开始网络传输时，我们可以看到 NSURLConnection 创建了两个新线程：com.apple.NSURLConnectionLoader 和 com.apple.CFSocket.private。其中 CFSocket 线程是处理底层 socket 连接的。NSURLConnectionLoader 这个线程内部会使用 RunLoop 来接收底层 socket 的事件，并通过之前添加的 Source0 通知到上层的 Delegate。
     
     RunLoop_network
     
     NSURLConnectionLoader 中的 RunLoop 通过一些基于 mach port 的 Source 接收来自底层 CFSocket 的通知。当收到通知后，其会在合适的时机向 CFMultiplexerSource 等 Source0 发送通知，同时唤醒 Delegate 线程的 RunLoop 来让其处理这些通知。CFMultiplexerSource 会在 Delegate 线程的 RunLoop 对 Delegate 执行实际的回调。
     */
}


@end
