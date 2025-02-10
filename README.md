# logs_spotter

Open source log engine plugin for Flutter

<p align="center">
<a href="https://pub.dev/packages/logs_spotter"><img src="https://img.shields.io/pub/v/logs_spotter.svg" alt="version"></a>
<a href="https://pub.dev/packages/logs_spotter/score"><img src="https://img.shields.io/pub/likes/logs_spotter?logo=dart" alt="popularity"></a>
<a><img src="https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square" alt="all contributors"></a>
</p>

## Setup

Add the following to your "pubspec.yaml" file:

```yaml
  logs_spotter: ^0.1.0
```

## Usage

Call this to configure spotter engine
 
```dart
  await Spotter().initializeEngine();
```

#### initializeEngine() Params descriptions
<table>
<tr><td>Argument</td><td>Type</td><td>Required</td><td>Details</td></tr>
<tr><td>customId</td><td>String?</td><td>No</td><td>custom app, device or user identifier Ex : 518739839</td></tr>
<tr><td>fileName</td><td>String</td><td>No</td><td>Local file name</td></tr>
<tr><td>writeToFile</td><td>bool</td><td>No</td><td>Enable in file writing Ex : true</td></tr>
<tr><td>writeToFirebase</td><td>bool</td><td>No</td><td>enable remote writing (Firebase) Ex : true</td></tr>
</table>

To log messages

```dart
//To log an message
  "initState".spot();

//add TAG
  "incrementCounter: $_counter".spot(tag: CLICK);
```
By default this method write log on console 



> [!NOTE]  
>The defaut values for tag property are: `click 🖱️`, `error 🚨`, `warning 🚧`, `debug 🐞`, `request 📤`, `response 📥`

----------------------------------------------------------------