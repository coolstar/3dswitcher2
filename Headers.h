#import <objc/runtime.h>

@protocol SBIconViewDelegate <NSObject>
@optional
-(float)iconLabelWidth;
-(BOOL)iconViewDisplaysCloseBox:(id)box;
-(BOOL)iconViewDisplaysBadges:(id)badges;
-(void)iconCloseBoxTapped:(id)tapped;
-(void)icon:(id)icon openFolder:(id)folder animated:(BOOL)animated;
-(BOOL)icon:(id)icon canReceiveGrabbedIcon:(id)icon2;
-(void)iconTapped:(id)tapped;
-(BOOL)iconShouldAllowTap:(id)icon;
-(void)icon:(id)icon touchEnded:(BOOL)ended;
-(void)icon:(id)icon touchMoved:(id)moved;
-(void)iconTouchBegan:(id)began;
-(void)iconHandleLongPress:(id)press;
@end

@interface SBIcon : NSObject
@property (nonatomic, assign) NSString *applicationBundleID;
- (void)launchFromLocation:(id)location;
- (void)setLaunchEnabled:(BOOL)enabled;
- (BOOL)isLeafIcon;
- (NSString *)leafIdentifier;
@end

@interface SBIconView : UIView
- (SBIconView *)initWithContentType:(int)contentType;
@property (nonatomic, assign) BOOL allowJitter;
@property (nonatomic, weak) NSObject<SBIconViewDelegate> *delegate;
@property (nonatomic, strong) SBIcon *icon;
- (void)setHighlighted:(BOOL)highlighted;
- (void)setIsEditing:(BOOL)editing animated:(BOOL)animated;
- (void)setLabelHidden:(BOOL)hidden;
@end

@interface SBDisplayItem : NSObject <NSCopying> {
	NSString* _uniqueStringRepresentation;
	NSString* _type;
	NSString* _displayIdentifier;
}
@property(readonly, assign, nonatomic) NSString* displayIdentifier;
@property(readonly, assign, nonatomic) NSString* type;
+(id)displayItemWithType:(NSString*)type displayIdentifier:(id)identifier;
-(id)plistRepresentation;
-(id)initWithPlistRepresentation:(id)plistRepresentation;
-(id)initWithType:(NSString*)type displayIdentifier:(id)identifier;
@end

@interface SBDisplayLayout : NSObject <NSCopying> {
	int _layoutSize;
	NSMutableArray* _displayItems;
	NSString* _uniqueStringRepresentation;
}
@property(readonly, assign, nonatomic) NSArray* displayItems;
@property(readonly, assign, nonatomic) int layoutSize;
@end

@class SBDisplayItem;
@interface SBAppSwitcherModel : NSObject {
	NSMutableArray *_recentDisplayItems;
}
+ (SBAppSwitcherModel *)sharedInstance;
- (void)remove:(SBDisplayItem *)item;
- (NSArray *)snapshotOfFlattenedArrayOfAppIdentifiersWhichIsOnlyTemporary;
@end

@interface SBDeckSwitcherItemContainer : UIView
- (instancetype)initWithFrame:(CGRect)arg1 displayItem:(SBDisplayItem *)displayItem delegate:(id)delegate;
@end

@interface SBDeckSwitcherPageViewProvider : NSObject
- (UIView *)_snapshotViewForDisplayItem:(SBDisplayItem *)displayItem preferringDownscaledSnapshot:(BOOL)preferringDownscaledSnapshot synchronously:(BOOL)synchronously;
- (UIView *)pageViewForDisplayItem:(SBDisplayItem *)displayItem synchronously:(BOOL)synchronously;
@end

@interface SBMainSwitcherViewController : UIViewController {
	NSMutableArray *_displayItems;
}
+ (instancetype)sharedInstance;
- (void)_removeDisplayItem:(SBDisplayItem *)displayItem updateScrollPosition:(BOOL)arg2 forReason:(NSInteger)arg3 completion:(id)arg4;
- (void)_removeDisplayItem:(SBDisplayItem *)displayItem forReason:(NSInteger)arg3 completion:(id)arg4;

- (SBDisplayItem *)_returnToDisplayItem;
- (void)_setReturnToDisplayItem:(SBDisplayItem *)displayItem;
@end

@interface SBDeckSwitcherViewController : UIViewController {
	NSMutableArray *_displayItems;
	UIScrollView *_scrollView;
}
- (NSMutableArray *)displayItems;
- (UIView *)pageForDisplayItem:(SBDisplayItem *)displayItem;
- (void)selectedDisplayItemOfContainer:(SBDeckSwitcherItemContainer *)container;
- (void)removeDisplayItem:(id)displayItem updateScrollPosition:(BOOL)arg2 forReason:(NSInteger)arg3 completion:(id)arg4;
- (void)removeDisplayItem:(id)displayItem forReason:(NSInteger)arg3 completion:(id)arg4;
@end

@interface SBApplication : NSObject
- (BOOL)isRunning;
@property(readonly, nonatomic) int pid;
@property (readonly, nonatomic) NSString* displayIdentifier;
@property (readonly, nonatomic) NSString* bundleIdentifier;
@property (readonly, nonatomic) NSString* path;
@end

@interface SBApplicationController : NSObject
+ (SBApplicationController *)sharedInstance;
- (NSArray *) applicationsWithBundleIdentifier:(NSString *)bundleIdentifier;
- (SBApplication *)applicationWithBundleIdentifier:(NSString *)bundleIdentifier;
@end

@interface SBApplicationIcon : SBIcon
- (SBApplicationIcon *) initWithApplication:(SBApplication *)application;
@end

@interface SBMediaController : NSObject
+ (SBMediaController *)sharedInstance;
- (SBApplication *)nowPlayingApplication;
- (BOOL)togglePlayPause;
- (BOOL)pause;
- (BOOL)play;
- (BOOL)isPaused;
- (BOOL)isPlaying;
- (BOOL)isLastTrack;
- (BOOL)isFirstTrack;
- (NSString *)nowPlayingAlbum;
- (NSString *)nowPlayingTitle;
- (NSString *)nowPlayingArtist;
- (void)changeTrack:(int)track;
@end

@interface FBSystemApp : NSObject
+ (instancetype) sharedApplication;
- (void)sendActionsToBackboard:(NSSet *)actions;
@end

@interface BKSRestartAction : NSObject
+ (instancetype)actionWithOptions:(NSInteger)options;
@end

@interface ASJJHandler : NSObject
+ (NSString *)clearCache;
+ (NSString *)cacheData;
- (void)runSynchronously:(NSString *)str;
@end