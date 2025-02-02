# logs_spotter

Open source log engine plugin for Flutter

## Setup

Add the following to your "pubspec.yaml" file:

```yaml
  logs_spotter: ^0.0.1
```

## Usage

Call this to configure spotter environment
 
```dart
  await Spotter().start();
```

To log messages

```dart
//To log an message
  "initState".spot();

//add TAG
  "incrementCounter: $_counter".spot(tag: CLICK);
```

> [!NOTE]  
>The defaut values for tag property are: `CLICK`, `ERROR`, `WARNING`, `DEBUG`,`RESPONSE`, `REQUEST`

----------------------------------------------------------------