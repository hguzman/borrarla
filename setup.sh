#!/bin/bash

# Asegurarse de que el script tiene permisos de ejecución
if [ ! -x "$0" ]; then
  chmod +x "$0"
  echo "✅ Se asignaron los permisos de ejecución a $0"
fi

HOOKS_DIR=".hooks"
GIT_HOOKS_DIR=".git/hooks"
HOOKS=("commit-msg" "pre-commit" "pre-push")

if [ ! -d "$GIT_HOOKS_DIR" ]; then
  echo "❌ Este no parece ser un repositorio Git"
  exit 1
fi

for HOOK in "${HOOKS[@]}"; do
  if [ ! -f "$HOOKS_DIR/$HOOK" ]; then
    echo "⚠️  No se encontró '$HOOK' en $HOOKS_DIR, se omite"
    continue
  fi

  TARGET="$GIT_HOOKS_DIR/$HOOK"

  if [ -L "$TARGET" ]; then
    echo "🔁 $HOOK ya enlazado"
  elif [ -f "$TARGET" ]; then
    echo "⚠️  $HOOK ya existe como archivo. No se sobrescribirá."
  else
    ln -s "../../$HOOKS_DIR/$HOOK" "$TARGET"
    echo "✅ Hook '$HOOK' enlazado"
  fi
done

# Asegurarse de que los hooks tengan permisos de ejecución
echo "🔑 Asignando permisos de ejecución a los archivos de hook..."
chmod +x .hooks/*

echo "✅ Permisos de ejecución asignados"
