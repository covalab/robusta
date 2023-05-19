---
id: tutorial
title: Tutorial
sidebar_position: 2
---

### 1. Your first Robusta Project

To create a completely new Flutter Project, simply run:

```sh
robusta new [project name]
```

![hello_robusta](https://github.com/qu0cquyen/robusta/assets/28641819/b36e54b9-602f-4b19-aa56-8a488692bf0e)

After running the above command we will end up with project structure below:

```sh
├── lib
│ ├── presentation
│ │ ├── screens
│ │ │ ├── counter
│ │ │ │ ├── provider.dart
│ │ │ │ ├── screen.dart
│ │ │ ├── custom_error
│ │ │ │ ├── screen.dart
│ ├── robusta
│ │ ├── app.dart
│ │ ├── boot.dart
│ │ ├── error_handle.dart
│ │ ├── event.dart
│ ├── main.dart
```

### 2. Runner

#### 2.1 main.dart

```js title="main.dart"
Future<void> main() async {
  final runner = Runner(
    defineBoot: defineBoot,
    extensions: [
      ImplementingCallbackExtension(),
      appExtension(),
      eventExtension(),
    ],
  );

  await runner.run();
}
```

- **Runner**: A wrap around class in which it's responsible for booting extensions and running our main application.
- **defineBoot**: Defines any functionalities needed to be run before running into main application.
- **extensions**: Takes in a list of extensions which give us the capability of expanding our app with 3rd library.

:::info
Extension is an interface class which is in charge of loading any defined initialization.
:::

:::info
There are 2 ways of adding extensions:

1. Call directly **Extension Constructor**
2. Use **command line** to generate built-in **Extension** - Refer to **Robusta CLI** and **built-in extensions**

:::

#### 2.2 app.dart

In Robusta ecosystem, everything starts with `Extension`. Therefore, unlike convention main app entry point - `runApp(MyApp())`, in Robusta our main app entry point will be `FlutterAppExtension appExtension()` - which is default generated when we create a new Robusta Project.

Your flutter app can be either `MaterialApp` or `CupertinoApp` by defining settings through given optional params in `FlutterAppExtension`

Screens/Pages will be declared inside `screenFactories` through `RouterSettings`

:::info
Screens/Pages in Robusta are created with the help of `GoRouter`
:::

:::info
If you want to specify which screen/page should be shown up first, you need to **implement** `InitialScreen`
:::

```js title="counter/screen.dart"
class CounterScreen extends Screen implements InitialScreen {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _CounterScreenWidget();
  }

  @override
  String get routeName => 'counter';

  @override
  String get routePath => '/counter';
}
```

#### 2.3 event.dart

Since Robusta is designed based on `Event Driven Architecture`. Therefore, `EventExtension` is where you would want to add `Event Listeners` or `Dispatch Events`

```js title="robusta/event.dart"
EventExtension eventExtension() {
  return EventExtension(
    configurator: (em, container) {
      em.addEventListener<ErrorEvent>(onError);
    },
  );
}
```
