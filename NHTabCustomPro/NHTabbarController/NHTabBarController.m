//
//  NHTabBarController.m
//  NHTabCustomPro
//
//  Created by hu jiaju on 15/11/11.
//  Copyright © 2015年 hu jiaju. All rights reserved.
//

#import "NHTabBarController.h"

// Default height of the tab bar
static const int kDefaultTabBarHeight = 50;
// Default Push animation duration
static const float kPushAnimationDuration = 0.35;

typedef NS_ENUM(NSUInteger, NHTabBarShowHideDirection) {
    NHTabBarShowHideDirectionLeft = 0,
    NHTabBarShowHideDirectionRight = 1
};

NSString *const kTabItemInfoTitleKey = @"kTabItemInfoTitleKey";
NSString *const kTabItemInfoNormalImageKey = @"kTabItemInfoNormalImageKey";
NSString *const kTabItemInfoSelectImageKey = @"kTabItemInfoSelectImageKey";

NSString *const kTabBarItemFontName = @"kTabBarItemFontName";
NSString *const kTabBarItemIconFont = @"kTabBarItemIconFont";
NSString *const kTabBarItemIconInfo = @"kTabBarItemIconInfo";
NSString *const kTabBarItemTitleFont = @"kTabBarItemTitleFont";
NSString *const kTabBarItemTitleInfo = @"kTabBarItemTitleInfo";

@interface NHTabBarController ()<NHTabBarViewDelegate,UINavigationControllerDelegate,UITabBarControllerDelegate>{
    NSArray *prevViewControllers;
    BOOL visible;
    
    // Content view
    NHTabBarContentView *tabBarView;
    
    // Tab Bar height
    NSUInteger tabBarHeight;
}
@end

@implementation NHTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        tabBarHeight = kDefaultTabBarHeight;
        // default settings
        _iconShadowOffset = CGSizeMake(0, -1);
        
    }
    return self;
}

- (id)initWithTabBarHeight:(NSUInteger)height {
    self = [super init];
    if (self) {
        tabBarHeight = kDefaultTabBarHeight;
        
        // default settings
        _iconShadowOffset = CGSizeMake(0, -1);
    };
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Creating and adding the tab bar view
    tabBarView = [[NHTabBarContentView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = tabBarView;
    
    // Creating and adding the tab bar
    CGRect tabBarRect = CGRectMake(0.0, CGRectGetHeight(self.view.bounds) - tabBarHeight, CGRectGetWidth(self.view.frame), tabBarHeight);
    _tabBar = [[NHTabBarView alloc] initWithFrame:tabBarRect];
    _tabBar.delegate = self;
    
    tabBarView.tabBar = _tabBar;
    tabBarView.contentView = _selectedViewController.view;
    [[self navigationItem] setTitle:[_selectedViewController title]];
    [self loadTabs];
}

- (void)loadTabs {
    NSMutableArray *tabs = [[NSMutableArray alloc] init];
    for (int i= 0;i<[self.viewControllers count];i++){
        UIViewController *vc = [self.viewControllers objectAtIndex:i];
        NSDictionary *vcInfo = [self.tabItemsInfo objectAtIndex:i];
        [[tabBarView tabBar] setBackgroundImageName:[self backgroundImageName]];
        [[tabBarView tabBar] setTabColors:[self tabCGColors]];
        [[tabBarView tabBar] setEdgeColor:[self tabEdgeColor]];
        [[tabBarView tabBar] setTopEdgeColor:[self topEdgeColor]];
        
        NHTabBarItem *tab = [[NHTabBarItem alloc] init];
        [tab setFontName:[vcInfo objectForKey:kTabBarItemFontName]];
        [tab setIconInfo:[vcInfo objectForKey:kTabBarItemIconInfo]];
        [tab setTitleInfo:[vcInfo objectForKey:kTabBarItemTitleInfo]];
        
        if ([[vc class] isSubclassOfClass:[UINavigationController class]])
            ((UINavigationController *)vc).delegate = self;
        
        [tabs addObject:tab];
    }
    
    [_tabBar setTabs:tabs];
    
    // Setting the first view controller as the active one
    if ([tabs count] > 0) [_tabBar setSelectedTab:(_tabBar.tabs)[_selectedIndex]];
}

- (NSArray *) selectedIconCGColors {
    return _selectedIconColors ? @[(id)[_selectedIconColors[0] CGColor], (id)[_selectedIconColors[1] CGColor]] : nil;
}

- (NSArray *) iconCGColors {
    return _iconColors ? @[(id)[_iconColors[0] CGColor], (id)[_iconColors[1] CGColor]] : nil;
}

- (NSArray *) tabCGColors {
    return _tabColors ? @[(id)[_tabColors[0] CGColor], (id)[_tabColors[1] CGColor]] : nil;
}

- (NSArray *) selectedTabCGColors {
    return _selectedTabColors ? @[(id)[_selectedTabColors[0] CGColor], (id)[_selectedTabColors[1] CGColor]] : nil;
}

#pragma - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!prevViewControllers)
        prevViewControllers = [navigationController viewControllers];
    
    
    // We detect is the view as been push or popped
    BOOL pushed;
    
    if ([prevViewControllers count] <= [[navigationController viewControllers] count])
        pushed = YES;
    else
        pushed = NO;
    
    if (pushed) {
        // Logic to know when to show or hide the tab bar
        BOOL isPreviousHidden, isNextHidden;
        
        isPreviousHidden = [[prevViewControllers lastObject] hidesBottomBarWhenPushed];
        isNextHidden = [viewController hidesBottomBarWhenPushed];
        
        prevViewControllers = [navigationController viewControllers];
        
        if (!isPreviousHidden && !isNextHidden)
            return;
        
        else if (!isPreviousHidden && isNextHidden)
            [self hideTabBar:(pushed ? NHTabBarShowHideDirectionRight : NHTabBarShowHideDirectionLeft) animated:animated];
        
        else if (isPreviousHidden && !isNextHidden)
            [self showTabBar:(pushed ? NHTabBarShowHideDirectionRight : NHTabBarShowHideDirectionLeft) animated:animated];
        
        else if (isPreviousHidden && isNextHidden)
            return;
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!prevViewControllers)
        prevViewControllers = [navigationController viewControllers];
    
    
    // We detect is the view as been push or popped
    BOOL pushed;
    
    if ([prevViewControllers count] <= [[navigationController viewControllers] count])
        pushed = YES;
    else
        pushed = NO;
    
    if (!pushed) {
        // Logic to know when to show or hide the tab bar
        BOOL isPreviousHidden, isNextHidden;
        
        isPreviousHidden = [[prevViewControllers lastObject] hidesBottomBarWhenPushed];
        isNextHidden = [viewController hidesBottomBarWhenPushed];
        
        prevViewControllers = [navigationController viewControllers];
        
        if (!isPreviousHidden && !isNextHidden)
            return;
        
        else if (!isPreviousHidden && isNextHidden)
            [self hideTabBar:(pushed ? NHTabBarShowHideDirectionRight : NHTabBarShowHideDirectionLeft) animated:animated];
        
        else if (isPreviousHidden && !isNextHidden)
            [self showTabBar:(pushed ? NHTabBarShowHideDirectionRight : NHTabBarShowHideDirectionLeft) animated:animated];
        
        else if (isPreviousHidden && isNextHidden)
            return;
    }
}

- (void)showTabBar:(NHTabBarShowHideDirection )showHideFrom animated:(BOOL)animated {
    
    CGFloat directionVector;
    
    switch (showHideFrom) {
        case NHTabBarShowHideDirectionLeft:
            directionVector = -1.0;
            break;
        case NHTabBarShowHideDirectionRight:
            directionVector = 1.0;
            break;
        default:
            break;
    }
    
    _tabBar.hidden = NO;
    _tabBar.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.view.bounds) * directionVector, 0);
    // when the tabbarview is resized we can see the view behind
    
    [UIView animateWithDuration:((animated) ? kPushAnimationDuration : 0) animations:^{
        _tabBar.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        tabBarView.isTabBarHidding = NO;
        [tabBarView setNeedsLayout];
    }];
}

- (void)hideTabBar:(NHTabBarShowHideDirection )showHideFrom animated:(BOOL)animated {
    
    CGFloat directionVector;
    switch (showHideFrom) {
        case NHTabBarShowHideDirectionLeft:
            directionVector = 1.0;
            break;
        case NHTabBarShowHideDirectionRight:
            directionVector = -1.0;
            break;
        default:
            break;
    }
    
    tabBarView.isTabBarHidding = YES;
    
    CGRect tmpTabBarView = tabBarView.contentView.frame;
    tmpTabBarView.size.height = tabBarView.bounds.size.height;
    tabBarView.contentView.frame = tmpTabBarView;
    
    [UIView animateWithDuration:((animated) ? kPushAnimationDuration : 0) animations:^{
        _tabBar.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.view.bounds) * directionVector, 0);
    } completion:^(BOOL finished) {
        _tabBar.hidden = YES;
        _tabBar.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - Setters

- (void)setViewControllers:(NSMutableArray *)viewControllers {
    _viewControllers = viewControllers;
    
    // Add the view controllers as child view controllers, so they can find this controller
    if([self respondsToSelector:@selector(addChildViewController:)]) {
        for(UIViewController* vc in _viewControllers) {
            [self addChildViewController:vc];
        }
    }
    
    // When setting the view controllers, the first vc is the selected one;
    if ([viewControllers count] > 0) [self setSelectedViewController:viewControllers[0]];
    
    // Load the tabs on the go
    [self loadTabs];
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController {
    UIViewController *previousSelectedViewController = _selectedViewController;
    NSInteger selectedIndex = [self.viewControllers indexOfObject:selectedViewController];
    
    if (_selectedViewController != selectedViewController && selectedIndex != NSNotFound){
        
        _selectedViewController = selectedViewController;
        _selectedIndex = selectedIndex;
        
        if ((self.childViewControllers == nil || !self.childViewControllers.count) && visible){
            [previousSelectedViewController viewWillDisappear:NO];
            [selectedViewController viewWillAppear:NO];
        }
        
        [tabBarView setContentView:selectedViewController.view];
        
        if ((self.childViewControllers == nil || !self.childViewControllers.count) && visible){
            [previousSelectedViewController viewDidDisappear:NO];
            [selectedViewController viewDidAppear:NO];
        }
        
        [_tabBar setSelectedTab:(_tabBar.tabs)[selectedIndex]];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self setSelectedViewController:(self.viewControllers)[selectedIndex]];
}

#pragma mark - Hide / Show Methods

- (void)showTabBarAnimated:(BOOL)animated {
    [self showTabBar:NHTabBarShowHideDirectionLeft animated:animated];
}

- (void)hideTabBarAnimated:(BOOL)animated {
    [self hideTabBar:NHTabBarShowHideDirectionRight animated:animated];
}

#pragma mark - Required Protocol Method

-(void)tabBar:(NHTabBarView *)FLTabbarView DidSelectTabAtIndex:(NSInteger)index {
    UIViewController *vc = (self.viewControllers)[index];
    
    if (self.selectedViewController == vc){
        if ([vc isKindOfClass:[UINavigationController class]])
            [(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:YES];
    }else{
        [[self navigationItem] setTitle:[vc title]];
        self.selectedViewController = vc;
        if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)]){
            [self.delegate tabBarController:self didSelectViewController:self.selectedViewController];
        }
    }
}

#pragma mark - ViewController Life cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ((self.childViewControllers == nil || !self.childViewControllers.count))
        [self.selectedViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ((self.childViewControllers == nil || !self.childViewControllers.count))
        [self.selectedViewController viewDidAppear:animated];
    
    visible = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ((self.childViewControllers == nil || !self.childViewControllers.count))
        [self.selectedViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (![self respondsToSelector:@selector(addChildViewController:)])
        [self.selectedViewController viewDidDisappear:animated];
    
    visible = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
