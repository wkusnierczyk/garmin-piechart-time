# Garmin Piechart Time

A minimalist, elegant, nerdy, typography-focused Garmin Connect IQ watch face that displays the current time as pie charts.

![Piechart Time](resources/graphics/PiechartTimeHero-small.png)

Available from [Garmin Connect IQ Developer portal](https://apps.garmin.com/apps/{blank:app-id}) or through the Connect IQ mobile app.

> **Note**  
> Piechart Time is part of a [collection of unconventional Garmin watch faces](https://github.com/wkusnierczyk/garmin-watch-faces). It has been developed for fun, as a proof of concept, and as a learning experience.
> It is shared _as is_ as an open source project, with no commitment to long term maintenance and further feature development.
>
> Please use [issues](https://github.com/wkusnierczyk/garmin-piechart-time/issues) to provide bug reports or feature requests.  
> Please use [discussions](https://github.com/wkusnierczyk/garmin-piechart-time/discussions) for any other comments.
>
> All feedback is wholeheartedly welcome.

## Contents

* [Piechart time](#piechart-time)
* [Features](#features)
* [Fonts](#fonts)
* [Build, test, deploy](#build-test-deploy)

## Piechart time

Piechart Time employes the idea of visualizing the passage of time as growing slices of a pie chart.
It shows three (hour, minutes, seconds) or two (hour, minutes) pie charts, depending on a customizable user setting.
An empty slice indicates noon or midnight (12 hours; 12/24h time toggle might be implemented as a user steting in a future version), a full hour (60 minutes) or a full minute (60 seconds).
A 1/4 slice is 3 hours, 15 minutes, or 15 seconds.

While reading time from a pie chart may lack precision, it does give a visually pleasing indication of what the time is approximately.
If needed, the time can be optionally displayed in the standard form below the pie charts.

## Features

The Piechart Time watch face supports the following features:

|Screenshot|Description|
|-|:-|
|![](resources/graphics/PiechartTimeHorizontal.png)|**Horizontal layout**<br/> Time shown as three or two piecharts besides each other.|
|![](resources/graphics/PiechartTimeConcentric.png)|**Concentric layout**<br/> The shown as three or two concentric picharts, with hour as the smallest pie chart in the front, and minutes and seconds as larger pie charts at the back.|
|![](resources/graphics/PiechartTimeStacked.png)|**Stacked layout**<br/> The shown as three or two picharts forming a cluster, with hour as the largest pie chart on the left, and minutes and seconds as smaller pie charts at aligned to its right edge.|
|![](resources/graphics/PiechartTimeDminishing.png)|**Diminishing layout**<br/> The shown as three or two picharts placed horizontally, with decreasing diameters from hour as the largest pie chart on the left, towards seconds as the smallest pie charts on the right.|
|![](resources/graphics/PiechartTimeItalian.png)|**Color themes**<br/> Several color themes are available: Monochrome, French flag colors, Italian flag colors, Red, Orange, Ocean.|
|![](resources/graphics/PiechartTimeSeconds.png)|**Seconds**<br/> The time may be displayed as three or two pie charts, with or without seconds.|
|![](resources/graphics/PiechartTimeStandard.png)|**Standard time**<br/> In addition to pie charts, standard time display may be enabled to show the time in dimmed, small font at the bottom of the screen.|

## Fonts

The Piechart Time watch face uses custom fonts:

* [Ubuntu](https://fonts.google.com/specimen/SUSE+Mono) for standard time (Ubuntu-Regular).

> The development of Garmin watch faces motivated the implementation of two useful tools:
> * A TTF to FNT+PNG converter ([`ttf2bmp`](https://github.com/wkusnierczyk/ttf2bmp)).  
> Garmin watches use non-scalable fixed-size bitmap fonts, and cannot handle variable size True Type fonts directly.
> * An font scaler automation tool ([`garmin-font-scaler`](https://github.com/wkusnierczyk/garmin-font-scaler)).  
> Garmin watches come in a variety of shapes and resolutions, and bitmap fonts need to be scaled for each device proportionally to its resolution.

The font development proceeded as follows:

* The fonts were downloaded from [Google Fonts](https://fonts.google.com/) as True Type  (`.ttf`) fonts.
* The fonts were converted to bitmaps as `.fnt` and `.png` pairs using the open source command-line [`ttf2bmp`](https://github.com/wkusnierczyk/ttf2bmp) converter.
* The font sizes were established to match the Garmin Fenix 7X Solar watch 280x280 pixel screen resolution.
* The fonts were then scaled proportionally to match other screen sizes available on Garmin watches using the [`garmin-font-scaler`](https://github.com/wkusnierczyk/garmin-font-scaler) tool.


The table below lists all font sizes provided for the supported screen resolutions.

| Resolution |    Shape     |    Element    |      Font      | Size |
| ---------: | :----------- | :------------ | :------------- | ---: |
|  148 x 205 | rectangle    | Standard time | Ubuntu regular |   16 |
|  176 x 176 | semi-octagon | Standard time | Ubuntu regular |   19 |
|  215 x 180 | semi-round   | Standard time | Ubuntu regular |   19 |
|  218 x 218 | round        | Standard time | Ubuntu regular |   23 |
|  240 x 240 | round        | Standard time | Ubuntu regular |   26 |
|  240 x 240 | rectangle    | Standard time | Ubuntu regular |   26 |
|  260 x 260 | round        | Standard time | Ubuntu regular |   28 |
|  280 x 280 | round        | Standard time | Ubuntu regular |   30 |
|  320 x 360 | rectangle    | Standard time | Ubuntu regular |   34 |
|  360 x 360 | round        | Standard time | Ubuntu regular |   39 |
|  390 x 390 | round        | Standard time | Ubuntu regular |   42 |
|  416 x 416 | round        | Standard time | Ubuntu regular |   45 |
|  454 x 454 | round        | Standard time | Ubuntu regular |   49 |

## Build, test, deploy

To modify and build the sources, you need to have installed:

* [Visual Studio Code](https://code.visualstudio.com/) with [Monkey C extension](https://developer.garmin.com/connect-iq/reference-guides/visual-studio-code-extension/).
* [Garmin Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/).

Consult [Monkey C Visual Studio Code Extension](https://developer.garmin.com/connect-iq/reference-guides/visual-studio-code-extension/) for how to execute commands such as `build` and `test` to the Monkey C runtime.

You can use the included `Makefile` to conveniently trigger some of the actions from the command line.

```bash
# build binaries from sources
make build

# run unit tests -- note: requires the simulator to be running
make test

# run the simulation
make run

# clean up the project directory
make clean
```

To sideload your application to your Garmin watch, see [developer.garmin.com/connect-iq/connect-iq-basics/your-first-app](https://developer.garmin.com/connect-iq/connect-iq-basics/your-first-app/).
