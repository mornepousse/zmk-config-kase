# KaSe ZMK — Plan de migration

## Phase 1 — Faire marcher le clavier (priorite haute)

- [ ] Initialiser le repo git + west init
- [ ] Verifier que le build passe pour les 3 targets (dongle, left, right)
- [ ] Valider le pinout GPIO (rows/cols) sur le PCB reel
  - Verifier l'ordre des colonnes inversees cote droit (PCB flip)
  - Tester chaque touche une par une
- [ ] Flasher le dongle (nrf52840dongle via nrfutil DFU)
- [ ] Flasher left + right (nice!nano via UF2)
- [ ] Confirmer que les 2 halves communiquent avec le dongle via ESB
- [ ] Confirmer que le host recoit les frappes USB HID

## Phase 2 — Keymap et behaviors (priorite haute)

- [ ] Ajuster la keymap au layout physique reel
- [ ] Ajouter hold-tap (mod-tap) sur les touches qui en ont besoin
- [ ] Ajouter les layers manquantes (symboles, numpad, etc.)
- [ ] Tester debounce (3ms press / 5ms release)

## Phase 3 — Power management (priorite moyenne)

- [ ] Valider deep sleep (30 min idle)
- [ ] Valider le wake-up (appui touche)
- [ ] Mesurer la consommation reelle (idle, active, sleep)
- [ ] Valider le battery reporting via ESB

## Phase 4 — Adapter le transport ESB (priorite moyenne)

- [ ] Analyser le code de zmk-feature-split-esb en detail
- [ ] Identifier les points de latence (MPSL timeslot overhead)
- [ ] Si besoin : forker et optimiser pour polling 1000 Hz
- [ ] Si besoin : reduire la latence sous 1ms (retirer MPSL, ESB direct)

## Phase 5 — Peripheriques (priorite basse, phase 2 du projet)

- [ ] E-ink display SSD1680 (left half, SPI)
- [ ] Trackpad Cirque Pinnacle (right half, SPI)
- [ ] PWM backlight (TPS61169 sur P1.01)

## Notes

- Le module badjeff/zmk-feature-split-esb utilise le sdk-nrf fork de badjeff (v3.1-branch+zmk-fixes)
- Le dongle utilise le bootloader DFU Nordic (pas UF2) — flasher avec nrfutil
- Les nice!nano gardent leur bootloader UF2 Adafruit
- NFC pins (P0.09, P0.10) doivent etre desactivees via CONFIG_NFCT_PINS_AS_GPIOS=y
