# Define a estrutura de diretórios
$baseDir = "."

$directories = @(
    "$baseDir\infraestrutura\terraform",
    "$baseDir\infraestrutura\ansible",
    "$baseDir\infraestrutura\scripts",
    "$baseDir\app\frontend\src",
    "$baseDir\app\frontend\public",
    "$baseDir\app\backend\service-1\src",
    "$baseDir\app\backend\service-2\src",
    "$baseDir\docs",
    "$baseDir\scripts",
    "$baseDir\.github"
)

# Cria os diretórios
foreach ($dir in $directories) {
    if (-Not (Test-Path -Path $dir)) {
        New-Item -Path $dir -ItemType Directory | Out-Null
        Write-Host "Criado: $dir"
    } else {
        Write-Host "Já existe: $dir"
    }
}

# Cria um arquivo README.md em cada diretório principal
$readmeDirs = @(
    "$baseDir",
    "$baseDir\infraestrutura",
    "$baseDir\app\frontend",
    "$baseDir\app\backend\service-1",
    "$baseDir\app\backend\service-2"
)

foreach ($readmeDir in $readmeDirs) {
    $readmePath = "$readmeDir\README.md"
    if (-Not (Test-Path -Path $readmePath)) {
        New-Item -Path $readmePath -ItemType File -Force | Out-Null
        Write-Host "README.md criado em: $readmeDir"
    } else {
        Write-Host "README.md já existe em: $readmeDir"
    }
}

Write-Host "Estrutura de diretórios criada com sucesso."
