$destroy = $false

# Docker backend
Write-Output "Build docker backend"
Set-Location -Path "./app/backend"
docker build -t cubos/backend .
Read-Host -Prompt "Pressione Enter para continuar..."

# Docker frontend
Write-Output "Build docker frontend"
Set-Location -Path "../frontend"
docker build -t cubos/frontend .
Read-Host -Prompt "Pressione Enter para continuar..."

# Terraform init
Write-Output "Terraform init"
Set-Location -Path "../../infraestrutura/terraform"
terraform init
Start-Sleep -Seconds 3

# Terraform plan
Write-Output "Terraform plan"
$planResult = terraform plan -var-file="values.tfvars"
Write-Output $planResult

# Loop do menu de escolha
$validChoice = $false
while (-not $validChoice) {
    Write-Output "Escolha uma opcao:"
    Write-Output "1: Terraform apply"
    Write-Output "2: Exit"
    $choice_apply = Read-Host -Prompt "Digite sua escolha"

    if ($choice_apply -eq "1") {
        Write-Output "Executando terraform apply..."
        terraform apply -var-file="values.tfvars" -auto-approve
        $validChoice = $true

        # Submenu para sair ou destruir a orquestracao
        $subChoiceValid = $false
        while (-not $subChoiceValid) {
            Write-Output "Escolha uma opcao:"
            Write-Output "1: Sair"
            Write-Output "2: Destruir a orquestracao"
            $choice = Read-Host -Prompt "Digite sua escolha"

            if ($choice -eq "1") {
                Set-Location -Path "../../"
                exit
            } elseif ($choice -eq "2") {
                terraform destroy -var-file="values.tfvars" -auto-approve
                $subChoiceValid = $true
            } else {
                Write-Output "Escolha invalida. Tente novamente."
            }
        }

    } elseif ($choice_apply -eq "2") {
        Set-Location -Path "../../"
        exit
    } else {
        Write-Output "Escolha invalida. Tente novamente."
    }
}
