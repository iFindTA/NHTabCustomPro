# NHTabCustomPro
### 自定义UITabBarController，UITabBarItem支持iconfont显示，并支持BadgeValue以圆点显示
##### 效果：
![image](https://github.com/iFindTA/screenshots/blob/master/tabbar_cus_0.png)

##### Usage:
```
	_tabBarController = [[NHTabBarController alloc] initWithTabBarHeight:NHTabBarHeight];
    _tabBarController.delegate = self;
    _tabBarController.viewControllers = [[NSMutableArray alloc] initWithObjects:msgNavi,mallNavi,caifuNavi,meNavi, nil];
    _tabBarController.tabItemsInfo = [[NSArray alloc] initWithObjects:msgInfo,mallInfo,caifuInfo,meInfo, nil];
    self.window.rootViewController = _tabBarController;
//    self.window.rootViewController = naviRoot;
    [self.window makeKeyAndVisible];

```