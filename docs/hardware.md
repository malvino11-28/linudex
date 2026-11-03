# Hardware

[Português](hardware.pt.md)

Linudex uses a Samsung Galaxy S10+ with a damaged display as the foundation of an ARM desktop environment. Version v0.4.0 extends the original hardware documentation to cover physical integration of the smartphone, USB-C hub, external connections and cooling inside a compact enclosure.

## Main device

The main device remains a **Samsung Galaxy S10+ (SM-G975F)** with a damaged built-in display but functional core hardware for this project.

| Component               | Specification / status                       |
| ----------------------- | -------------------------------------------- |
| SoC                     | Samsung Exynos 9820                          |
| Architecture            | ARM64 / AArch64                              |
| RAM                     | 8 GB nominal                                 |
| Internal storage        | 128 GB                                       |
| USB                     | USB-C                                        |
| External desktop output | Samsung DeX through a USB-C video connection |
| Built-in display        | Physically damaged                           |

<p align="center">
  <img src="../images/build/s10-front.png" alt="Galaxy S10+ front view" width="263">
  <img src="../images/build/s10-back.png" alt="Galaxy S10+ rear view" width="263">
  <img src="../images/build/s10-damaged-display.png" alt="Damaged Galaxy S10+ display" width="250">
</p>

## Hardware history and initial testing

In v0.1, the Linux environment was validated using an external display through Samsung DeX and external input devices as needed. The models of the peripherals used in the initial tests were not recorded.

Android reported battery health as `GOOD` during the baseline; charging was limited to 85% for stationary use. RAM Plus was set to 8 GB and represents storage-backed virtual memory rather than additional physical RAM.

Previously documented desktop tests recorded **battery** temperatures between **27.8 °C and 33.0 °C**. The most noticeable early heating was associated with the damaged internal display remaining on; the device cooled when the display was turned off during DeX use. These readings are not SoC temperatures and do not establish a cooling benefit from the v0.4 fans.

## Physical integration — v0.4.0

Version v0.4.0 integrates the device into a **Brothers Repair Nano mini enclosure**. The goal is to house the smartphone, hub and wiring neatly while keeping external interfaces accessible and preparing active airflow.

The build uses an 8-in-1 USB-C hub, USB-C extension, 3.5 mm audio extension, HDMI cable, input peripherals and two 80 mm fans. A dedicated monitor has not yet been purchased.

<!-- Future images: enclosure overview, internal layout and rear panel (../images/build/). -->

## Connectivity and USB-C hub

The hub connects the Galaxy S10+ to peripherals and the external display. According to its manual, its interfaces include:

| Interface                          | Reported function / specification                                   |
| ---------------------------------- | ------------------------------------------------------------------- |
| USB-C connector for computer/phone | Connection to the Galaxy S10+                                       |
| USB-C female port 1                | PD input, `20V@3A`; manual states support for up to an 87 W adapter |
| USB-C female port 2                | USB-C data port, up to 4.5 W supplied to peripherals                |
| USB-A (2 ports)                    | Keyboard, mouse, storage and other peripherals                      |
| HDMI                               | External display output                                             |
| Ethernet                           | Wired network                                                       |
| SD and TF/microSD                  | Memory card readers                                                 |

The hub ports were tested working simultaneously. The second USB-C port is **not a PD charging input**: connecting a charger there may illuminate the hub's indicator without charging the phone.

The hub and its video path are functional in the current build.

<!-- Future diagram: connection layout and physical placement (../images/build/). -->

## Smartphone positioning and USB-C extension

The original S10+ mounting orientation placed the power button against an internal case support. Tightening the support could keep the button pressed, risking unintended activation.

A **USB-C male-to-female extension cable** allowed the phone to be mounted in the reverse orientation while preserving a working connection to the hub and Samsung DeX. The Power button is now clear; however, the volume and Bixby buttons may still be partly pressed. This should be monitored and corrected if it causes unintended inputs.

The adjustment addresses this particular enclosure geometry and is not a general requirement for Linudex. Details of the mechanical constraint will be recorded in the v0.4.0 [Troubleshooting](troubleshooting/README.md).

<!-- Future images: before/after positioning and USB-C extension routing. -->

## Rear 3.5 mm audio jack

The Galaxy S10+'s built-in 3.5 mm audio output was extended using a **50 cm audio extension cable** to an available rear opening above the hub's Ethernet port.

The initial electrical-tape mounting did not prevent the jack from being pushed inside the case when plugging in headphones. The final solution used rubber washers of different diameters bonded together with cyanoacrylate adhesive. A paintbrush served as an improvised mandrel to gradually adjust the washers' inner diameter until the jack formed a tight interference fit. The assembly was glued to the internal case wall, allowed to cure for approximately 24 hours, and finished externally with electrical tape to conceal excess adhesive.

The jack now stays in place during insertion, while remaining removable with some force. The extension is **optional**: Linudex does not depend on it to operate.

<!-- Future images: materials, washer assembly, internal mounting and finished jack. -->

## Electrical power

The build uses a multiport charger with USB-C PD and USB-A QC ports. The intended main connection is a charger PD output to the hub's PD input, supplying power to the smartphone.

For the fans, the planned connection chain is:

```text
Compatible charger
       │
USB → 12 V DC5521 cable
       │
DC5521 → Molex adapter
       │
   Two 80 mm fans
```

The fan power cables were purchased again and are awaiting delivery and testing. **The 12 V circuit is not yet validated.** Before connecting it permanently, the charger's specifications, the cable's voltage negotiation, DC5521 polarity and fan current ratings should be checked. The charger's advertised total wattage alone does not confirm that a 12 V profile is available on the chosen output.

The power strip/filter accessory is optional external power distribution equipment, not part of the phone's internal electrical circuit.

<!-- Future electrical diagram: hub PD input and fan power connections (../images/build/). -->

## Active cooling

The build includes **two 80 mm fans** intended to increase air movement inside the enclosure and reduce heat accumulation during sustained workloads.

The fans have been purchased, but the final functional test with the replacement power cables is pending. The airflow direction and definitive fan placement will be documented after installation and testing. An intake/exhaust arrangement may be used depending on case geometry and openings; no thermal improvement should be assumed before measurement.

Version v0.4 benchmarking should compare repeatable workloads while recording battery temperatures, stability, workload conditions and fan-on/fan-off behavior. See [Benchmarks](benchmarks.md) for results from earlier versions.

<!-- Future images: fan mounting locations, airflow direction and final wiring. -->

## Video and peripherals

The hub provides HDMI output to an external monitor. The **2 m HDMI cable has already been purchased and tested successfully** using a temporary monitor. Video output is therefore functional even though a dedicated monitor has not yet been purchased.

The wireless keyboard and mouse kit is in use; the hub also supports wired USB input devices. Its SD and microSD slots are available, but purchasing memory cards remains an optional future storage expansion.

## Pending v0.4.0 validation

- Receive and inspect the replacement fan power cables.
- Validate the electrical connection and simultaneous operation of both fans.
- Record the final fan layout, airflow direction and cable organization.
- Run thermal tests comparable to the existing benchmarks, without claiming improvements before measurements.
- Curate and add the final build photographs and connection diagrams.

A dedicated monitor is not required to complete the physical integration: HDMI output has already been validated using an existing display.

Component costs are recorded in the [bill of materials](../bom/components.md).
