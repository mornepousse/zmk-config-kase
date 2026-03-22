# KaSe — ZMK Split Keyboard (ESB)

Split keyboard firmware using [ZMK](https://zmk.dev) with [zmk-feature-split-esb](https://github.com/badjeff/zmk-feature-split-esb) for Enhanced ShockBurst (ESB) wireless transport.

## Architecture

```
Left half (nice!nano v2)  ──ESB──►  Dongle (nRF52840 dongle)  ──USB HID──►  PC
Right half (nice!nano v2) ──ESB──►
```

- **Halves**: 5×7 key matrix, BAT54C diodes, LiPo battery
- **Dongle**: USB HID output, no physical keys
- **Transport**: Nordic ESB (2.4 GHz, ~1 ms latency)
- **Remapping**: [ZMK Studio](https://zmk.studio) via USB (live keymap editing, no recompile)

## Build

```bash
nix-shell   # sets up toolchain, west, nrfutil

west build -s zmk/app -b "nice_nano//zmk" -p -- -DSHIELD=kase_left
west build -s zmk/app -b "nice_nano//zmk" -p -- -DSHIELD=kase_right
west build -s zmk/app -b "nrf52840dongle//zmk" -p -- -DSHIELD=kase_dongle
```

### ST-Link flash (no bootloader)

```bash
west build -s zmk/app -b "nice_nano//zmk" -p -- \
  -DSHIELD=kase_left \
  -DDTC_OVERLAY_FILE="$(pwd)/boards/shields/kase/kase_left_stlink.overlay"

openocd -f interface/stlink.cfg -f target/nrf52.cfg \
  -c "init" -c "halt" -c "nrf5 mass_erase" \
  -c "program build/zephyr/zmk.hex verify reset exit"
```

### Dongle flash (Nordic DFU)

```bash
nrfutil nrf5sdk-tools pkg generate \
  --hw-version 52 --sd-req 0x00 \
  --application build/zephyr/zmk.hex \
  --application-version 1 build/kase_dongle.zip

nrfutil device program --firmware build/kase_dongle.zip --traits nordicDfu
```

## Layout

```
Left:                                       Right:
  ESC  1    2    3    4    5    6     |     7    8    9    0    -    =    BSPC
  TAB  Q    W    E    R    T    ·     |     Y    U    I    O    P    [    ]
  CAP  A    S    D    F    G    ·     |     H    J    K    L    ;    '    ENT
  SFT  Z    X    C    V    ·    ·     |     N    M    ,    .    /    SFT  ·
  CTL  GUI  ALT  LYR1 SPC  ·    ·     |     ·    ·    SPC  LYR2 ALT  GUI  CTL
```

3 layers: Base (QWERTY), Nav (F-keys + arrows), Sym (symbols + numpad).
