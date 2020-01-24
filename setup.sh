#! /usr/bin/env bash

set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Missing meta argument"
  exit 1
fi

META="$1"

if ! nix-channel --list | grep home-manager; then
  nix-channel --add https://github.com/rycee/home-manager/archive/release-19.09.tar.gz home-manager
  nix-channel --update
fi

if [ ! -f /etc/nixos/meta.nix ]; then
  [ -f /etc/nixos/configuration.nix ] && sudo mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.old
  sudo ln -s "$(realpath nixos/configuration.nix)" /etc/nixos/configuration.nix
  sudo ln -s "$(realpath nixos/meta)" /etc/nixos/meta
  sudo ln -s "$(realpath nixos/meta/$META.nix)" /etc/nixos/meta.nix
fi

PKGS="$HOME/.config/nixpkgs"
if [ ! -L "$PKGS" ]; then
  [ -d "$PKGS" ] && mv "$PKGS" "$PKGS.old"
  ln -s "$(realpath nixpkgs)" "$PKGS"
fi
