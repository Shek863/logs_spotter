# logs_spotter

Spotter is a open source log engine plugin for Flutter.
There allow developer to see what happen whenever or remotely debug their application

<p align="center">
<a href="https://pub.dev/packages/logs_spotter"><img src="https://img.shields.io/pub/v/logs_spotter.svg" alt="version"></a>
<a href="https://pub.dev/packages/logs_spotter/score"><img src="https://img.shields.io/pub/likes/logs_spotter?logo=dart" alt="popularity"></a>
<a><img src="https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square" alt="all contributors"></a>
</p>

## Setup

Add the following to your "pubspec.yaml" file:

```yaml
  logs_spotter: ^0.1.2
```

## Usage

You need to encapscul you main code with spotterScope() like this
This will automatically catch FlutterError
```dart
      await spotterScope(() async {
        runApp(const MyApp());
      });
```

You can also specify spotter engine configuration
Please see a github example 
 
```dart
     await Spotter().initializeEngine(
fileName: "my_app_logs",
writeToFile: true,
writeToConsole: true,
writeToFirebase: true,
customId: "spotter_example_emulator_1024020",
remoteObserveDefaultValue: false,
exportLocal: true );
```

#### initializeEngine() Params descriptions
<table>
<tr><td>Argument</td><td>Type</td><td>Required</td><td>Details</td></tr>
<tr><td>customId</td><td>String?</td><td>No</td><td>custom app, device or user identifier Ex : 518739839</td></tr>
<tr><td>fileName</td><td>String</td><td>No</td><td>Local file name</td></tr>
<tr><td>writeToConsole</td><td>bool</td><td>No</td><td>Show log on console Ex : true</td></tr>
<tr><td>writeToFile</td><td>bool</td><td>No</td><td>Enable in file writing Ex : true</td></tr>
<tr><td>writeToFirebase</td><td>bool</td><td>No</td><td>Enable remote writing (Firebase) Ex : true</td></tr>
<tr><td>exportLocal</td><td>bool</td><td>No</td><td>Export local logs on remote observe (Firebase) Ex : true</td></tr>
<tr><td>remoteObserveDefaultValue</td><td>bool</td><td>No</td><td>set remote writing [Firebase] defaultValue Ex : false</td></tr>
</table>

To log messages

```dart
//To log an message
// Log level method : Level.WARNING
"warningMessage".w.spot();
// Log level method : Level.ERROR
"errorMessage".e.spot();

//add TAG
// Log level method : Level.CLICK
"incrementCounter: $_counter".c.spot(tag: click);
// Log level method : Level.FINE
"goodJob".f.spot(tag: tag);
// Log level method : Level.INFO
"yourMessage".i.spot(tag: tag);
```
By default this method write log on console 



> [!NOTE]  
>The defaut values for tag property are: `click 🖱️`, `error 🚨`, `warning 🚧`, `debug 🐞`, `request 📤`, `response 📥`

----------------------------------------------------------------