.SHELLFLAGS := -eu -o pipefail -c
SHELL := bash

DEVICE_ID ?= 5200d78bfa479449
PORT ?= 8081

.PHONY: help reverse r build-runner br generate-keys gk gen g scrcpy s clean c analyze a check dev-setup d diff

help: ## Lista komend
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

# --- GŁÓWNE TARGETY I ALIASE ---

reverse: ## ADB reverse (8081)
	adb -s $(DEVICE_ID) reverse tcp:$(PORT) tcp:$(PORT)
r: reverse

diff: ## Zapisz różnice git do pliku roznice.patch
	git diff > roznice.patch

build-runner: ## Run build_runner (JIT mode)
	dart run build_runner build --force-jit
br: build-runner

generate-keys: ## Generuj i18n keys
	dart run scripts/generate_locale_keys.dart
gk: generate-keys

gen: generate-keys build-runner ## Generuj wszystko (gk + br)
g: gen

scrcpy: ## Odpal podgląd scrcpy
	scrcpy -s $(DEVICE_ID)
s: scrcpy

clean: ## Flutter clean & pub get
	flutter clean
	flutter pub get
c: clean

analyze: ## Flutter analyze
	flutter analyze
a: analyze

dev-setup: reverse gen ## ADB reverse + gen na raz
d: dev-setup