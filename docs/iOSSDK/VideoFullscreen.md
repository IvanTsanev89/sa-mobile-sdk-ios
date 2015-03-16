If you just want to display a fullscreen video ad and not to worry about the delegate protocol, this is the easiest way to show a video ad:

```
SAVideoAdViewController *vc = [[SAVideoAdViewController alloc] initWithAppID:@"__APP_ID__" placementID:@"__PLACEMENT_ID__"];
[vc setParentalGateEnabled:YES];
[self presentViewController:vc animated:YES completion:nil];
```

Do not forget to replace the `__YOUR_APP_ID__` and the `__YOUR_PLACEMENT_ID__` strings with your app ID and placement ID.

The view controller will handle all the errors and will dismiss itself when the ad finishes.