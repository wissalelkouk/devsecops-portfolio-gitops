#!/bin/bash
# Usage : scripts/promote.sh <source> <cible>   (ex : dev staging)
# Copie les digests d'images de l'overlay source vers l'overlay cible.
# Aucune image n'est reconstruite : seul le digest signé change.
set -e
SRC="overlays/$1/kustomization.yaml"
DST="overlays/$2/kustomization.yaml"
for img in api frontend; do
  NAME="172.19.145.50:30500/portfolio/$img"
  DIG=$(grep -A1 "name: $NAME" "$SRC" | grep digest | awk '{print $2}')
  [ -n "$DIG" ] || { echo "digest introuvable pour $img dans $SRC"; exit 1; }
  sed -i "\|name: $NAME\$|{n;s|digest: .*|digest: $DIG|}" "$DST"
  echo "$img -> $DIG"
done
