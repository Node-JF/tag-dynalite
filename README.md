# Dynalite Envision Gateway

This is a Q-SYS Plugin for Dynalite Envision Gateways. This Plugin can use either ***DyNet 2*** or the ***DyNet Text Protocol***.

> Bug reports and feature requests should be sent to Jason Foord (jf@tag.com.au).

## How do I get set up?

See [Q-SYS Online Help File - Plugins](https://q-syshelp.qsc.com/#Schematic_Library/plugins.htm)

## Properties

#### Protocol

The protocol to use.

> DyNet 2 | DyNet Text

>> The Protocol of the Envision Gateway is set under the *Port Editor* tabe in *Dynalite System Builder*

#### Port

#### Area Slots

Each area slot will generate a new page.

> Each page configures a single area, or can be left on area '0' (none).

#### Presets

The number of preset slots available in each area slot.

#### Enable Logical Channels

Whether to show logical channel controls.

#### Logical Channels

The number of logical channel controls to show in each area slot.

> For DyNet Text, the value range is ***0 - 100%***

> For DyNet 2, the value range is ***255 - 0***

#### Enable Polling

Whether the plugin will poll current presets and levels.

#### Poll Rate (s)

The polling interval.

## Controls

### Area Slot
![Area Slot](./Screenshots/Dynalite%20Plugin.jpg)

#### IP Address

The IP Address of the device.

> This is a global control that displays on every page.

#### Device Status

Displays the device's status.

> This is a global control that displays on every page.

#### Connect

Toggles the connection to the device.

> This is a global control that displays on every page.

#### Area Controls

> ##### Number

> The Area to control. Leave at '0' if unallocated.

>> Area information is configured in the *Dynalite System Builder* software.

> #### Presets

>> ##### Fade Time

>> The fade time to recall the preset with when loaded.

>> ##### Load

>> Recalls the preset.

>> ##### Match

>> Indicates if the preset is currently active.

>>> Adjusting a logical channel level manually will clear all preset match indicators.

> ##### Channels

>> ##### Level

>> Control of the logical channel level.

>>> Can either be used in real-time, or snapshotted in Q-SYS to achieve 'preset' functionality.