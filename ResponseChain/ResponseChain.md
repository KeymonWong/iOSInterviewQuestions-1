UIResponder 一般响应4种事件：

## 触摸事件 touch handling

```
- (void)touchesBegan:(NSSet *)touches withEvent:(nullable UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(nullable UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(nullable UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(nullable UIEvent *)event;
- (void)touchesEstimatedPropertiesUpdated:(NSSet *)touches NS_AVAILABLE_IOS(9_1);
```

## 点击事件 press handling NS_AVAILABLE_IOS(9_0)

```
- (void)pressesBegan:(NSSet *)presses withEvent:(nullable UIPressesEvent *)event NS_AVAILABLE_IOS(9_0);
- (void)pressesChanged:(NSSet *)presses withEvent:(nullable UIPressesEvent *)event NS_AVAILABLE_IOS(9_0);
- (void)pressesEnded:(NSSet *)presses withEvent:(nullable UIPressesEvent *)event NS_AVAILABLE_IOS(9_0);
- (void)pressesCancelled:(NSSet *)presses withEvent:(nullable UIPressesEvent *)event NS_AVAILABLE_IOS(9_0);
```

## 加速事件

```
- (void)motionBegan:(UIEventSubtype)motion withEvent:(nullable UIEvent *)event NS_AVAILABLE_IOS(3_0);
- (void)motionEnded:(UIEventSubtype)motion withEvent:(nullable UIEvent *)event NS_AVAILABLE_IOS(3_0);
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(nullable UIEvent *)event NS_AVAILABLE_IOS(3_0);
```

## 远程事件

```
- (void)remoteControlReceivedWithEvent:(nullable UIEvent *)event NS_AVAILABLE_IOS(4_0);
```
