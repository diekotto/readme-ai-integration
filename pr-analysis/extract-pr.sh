#!/bin/bash

# Uso: ./analyze-pr.sh <owner> <repo> <pr_number>
# Ejemplo: ./analyze-pr.sh microsoft vscode 123456

if [ "$#" -ne 3 ]; then
    echo "Uso: $0 <owner> <repo> <pr_number>"
    exit 1
fi

OWNER=$1
REPO=$2
PR_NUMBER=$3

# Validar que gh está instalado
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) no está instalado"
    exit 1
fi

# Validar que jq está instalado
if ! command -v jq &> /dev/null; then
    echo "Error: jq no está instalado"
    exit 1
fi

# Obtener metadata del PR
echo "Obteniendo metadata del PR..."
PR_METADATA=$(gh pr view $PR_NUMBER \
    --repo $OWNER/$REPO \
    --json title,body,author,createdAt,changedFiles,additions,deletions)

# Obtener los diffs
echo "Obteniendo diffs..."
PR_DIFF=$(gh pr diff $PR_NUMBER --repo $OWNER/$REPO)

# Crear estructura JSON con toda la información
echo "Estructurando datos..."
JSON_OUTPUT=$(cat << EOF
{
  "metadata": $PR_METADATA,
  "diff": $(echo "$PR_DIFF" | jq -R -s '.')
}
EOF
)

# Guardar en un archivo temporal
echo "$JSON_OUTPUT" | jq '.' > pr_analysis.json

# Crear el prompt para la IA
cat << EOF > prompt.txt
Por favor, revisa este Pull Request y proporciona feedback sobre:
- Posibles problemas de seguridad
- Calidad del código
- Posibles bugs
- Sugerencias de mejora

La información del PR es:
$(cat pr_analysis.json)
EOF

echo "Archivos generados:"
echo "- pr_analysis.json: Contiene la estructura JSON completa"
echo "- prompt.txt: Contiene el prompt preparado para la IA"
