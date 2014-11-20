
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
  AllAroundPullViewStateNormal = 0,
  AllAroundPullViewStateReady,
  AllAroundPullViewStateLoading,
  AllAroundPullViewStateNone
} AllAroundPullViewState;

typedef enum {
  AllAroundPullViewPositionTop = 1 << 0,
  AllAroundPullViewPositionBottom = 1 << 1,
  AllAroundPullViewPositionLeft = 1 << 2,
  AllAroundPullViewPositionRight = 1 << 3
} AllAroundPullViewPosition;

@interface AllAroundPullView : UIView

@property (nonatomic, assign) NSTimeInterval timeout;
@property (nonatomic, assign) CGFloat threshold;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, readonly) BOOL isSideView;
@property (nonatomic, readonly) AllAroundPullViewPosition position;

- (void)finishedLoading;
- (void)hideAllAroundPullViewIfNeed:(BOOL)disable;
- (id)initWithScrollView:(UIScrollView *)scroll position:(AllAroundPullViewPosition)position action:(void (^)(AllAroundPullView *view))actionHandler;

@end
