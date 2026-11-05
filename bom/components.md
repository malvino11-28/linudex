# Bill of Materials

[Português](components.pt.md)

This bill of materials (BOM) records the components purchased for the physical integration of Linudex v0.4.0, their purposes, validation status and costs. The build uses an already-owned Samsung Galaxy S10+, so the phone's value is excluded from the documented incremental spending.

## Main device

| Component  | Model                          | Status        | Incremental cost |
| ---------- | ------------------------------ | ------------- | ---------------: |
| Smartphone | Samsung Galaxy S10+ (SM-G975F) | Already owned |          R$ 0.00 |

## Purchased components

| Component                                | Description / purpose                                                        | Classification | Status                                                           |      Cost |
| ---------------------------------------- | ---------------------------------------------------------------------------- | -------------- | ---------------------------------------------------------------- | --------: |
| 80 mm cooling fans (2 units)             | Active airflow inside the enclosure                                          | v0.4 build     | Purchased; both running in a 20-minute test                      |  R$ 31.30 |
| Wireless keyboard and mouse kit          | Input peripherals with a USB receiver                                        | v0.4 build     | Purchased and in use                                             |  R$ 39.98 |
| 8-in-1 USB-C hub                         | Video, USB, network and card-reader connectivity                             | v0.4 build     | Purchased and tested                                             |  R$ 36.51 |
| Power strip / surge-filter accessory     | Power distribution for the setup                                             | **Optional**   | Purchased                                                        |  R$ 32.24 |
| Nano mini enclosure — Brothers Repair    | Physical housing and component organization                                  | **Optional**   | Purchased and in use                                             | R$ 237.38 |
| DC5521 → 4-pin fan header adapter        | Connects to the fan assembly's small connector; not the large IDE Molex plug | v0.4 build     | Received and functional in test; electrical verification pending |  R$ 18.58 |
| USB-C PD → DC5521 cable (nominal 12 V)   | Cooling fan supply                                                           | v0.4 build     | Received and operating in test; actual voltage not measured      |  R$ 17.59 |
| Multiport PD/QC charger + two USB cables | System power; USB-C/USB-C and USB-A/USB-C cables                             | v0.4 build     | Purchased                                                        |  R$ 64.88 |
| USB-C male-to-female extension cable     | Extends the smartphone USB-C connection                                      | **Optional**   | Purchased and tested with the hub                                |  R$ 44.98 |
| 3.5 mm audio extension — 50 cm           | Accessible rear audio jack                                                   | **Optional**   | Purchased, installed and tested                                  |  R$ 22.71 |
| HDMI cable — 2 m                         | Video connection from the hub to an external display                         | v0.4 build     | Purchased and tested                                             |  R$ 32.90 |

**Optional** means the component is not required for the basic operation of Linudex, although it is part of this documented physical build. Exact product models and purchase links will be added after the product listings are reviewed.

<!-- Add individual product links after reviewing the listings. -->

## Peripherals and expansions not purchased

| Component                                  | Purpose                   | Status                  |
| ------------------------------------------ | ------------------------- | ----------------------- |
| Dedicated Full HD (1920×1080) HDMI monitor | Dedicated Linudex display | Not purchased           |
| SD and/or microSD card                     | Storage expansion         | Optional; not purchased |

## Costs

| Metric                                            |        Amount |
| ------------------------------------------------- | ------------: |
| Purchased components — total incremental spending | **R$ 579.05** |
| Portion corresponding to purchased optional items |     R$ 337.31 |
| Portion corresponding to other purchased items    |     R$ 241.74 |
| Already-owned smartphone                          |  Not included |
| Dedicated monitor not yet purchased               |  Not included |

Costs for reused mounting supplies or materials with no reported price have not been estimated.

## Cost policy and reproducibility

For build comparisons, the documentation distinguishes:

1. **Incremental spending** — actual cost of adapting the already-owned phone.
2. **Full replacement value** — a possible future estimate including the phone and other already-owned equipment.

The enclosure, power strip, USB-C extension and audio extension are part of this build, but can be omitted or replaced in other implementations. Likewise, any compatible HDMI monitor or TV and equivalent input peripherals can be used.
