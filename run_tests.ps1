# Script PowerShell para executar testes ADB + YAML
# Automação Android sem dependência do Appium Server

param(
    [string]$TestOption = ""
)

# Configurar encoding UTF-8
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "🚀 Executando Testes ADB + YAML" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green

# Verificar se há dispositivo conectado
Write-Host "📱 Verificando dispositivos conectados..." -ForegroundColor Yellow

try {
    $adbDevices = adb devices 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ ADB não encontrado! Verifique se o Android SDK está instalado." -ForegroundColor Red
        Read-Host "Pressione Enter para sair"
        exit 1
    }
    
    $connectedDevices = $adbDevices | Where-Object { $_ -match "device$" }
    $deviceCount = $connectedDevices.Count
    
    if ($deviceCount -eq 0) {
        Write-Host "❌ Nenhum dispositivo Android conectado!" -ForegroundColor Red
        Write-Host "💡 Conecte um dispositivo via USB e ative a Depuração USB" -ForegroundColor Yellow
        Read-Host "Pressione Enter para sair"
        exit 1
    }
    
    Write-Host "✅ $deviceCount dispositivo(s) conectado(s)" -ForegroundColor Green
} catch {
    Write-Host "❌ Erro ao verificar dispositivos: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "Pressione Enter para sair"
    exit 1
}

# Ativar ambiente virtual se existir
if (Test-Path ".venv") {
    Write-Host "🐍 Ativando ambiente virtual..." -ForegroundColor Cyan
    & ".venv\Scripts\Activate.ps1"
}

# Criar diretórios necessários
if (!(Test-Path "screenshots")) { New-Item -ItemType Directory -Path "screenshots" -Force | Out-Null }
if (!(Test-Path "logs")) { New-Item -ItemType Directory -Path "logs" -Force | Out-Null }

# Menu de opções se não foi passado parâmetro
if ([string]::IsNullOrEmpty($TestOption)) {
    Write-Host ""
    Write-Host "🎯 Escolha qual teste executar:" -ForegroundColor Cyan
    Write-Host "1) Testes básicos ADB (Iniciante)" -ForegroundColor White
    Write-Host "2) Configurações ADB + YAML (Recomendado)" -ForegroundColor White
    Write-Host "3) Sistema YAML Locators (Avançado)" -ForegroundColor White
    Write-Host "4) Detecção de Dispositivos" -ForegroundColor White
    Write-Host "5) Rede e Dispositivos Conectados" -ForegroundColor White
    Write-Host "6) Automações Completas - Menu Configurações (NOVO!)" -ForegroundColor White
    Write-Host "7) Todos os testes" -ForegroundColor White
    Write-Host ""
    $TestOption = Read-Host "Digite sua opção (1-7)"
}

switch ($TestOption) {
    "1" {
        Write-Host "🚀 Executando testes básicos ADB..." -ForegroundColor Green
        robot tests\adb_basic_tests.robot
    }
    "2" {
        Write-Host "🎯 Executando configurações ADB + YAML..." -ForegroundColor Green
        robot tests\configuracoes_adb_yaml_test.robot
    }
    "3" {
        Write-Host "🔬 Executando sistema YAML Locators..." -ForegroundColor Green
        robot tests\yaml_locators_test.robot
    }
    "4" {
        Write-Host "📱 Executando detecção de dispositivos..." -ForegroundColor Green
        robot tests\device_detection_tests.robot
    }
    "5" {
        Write-Host "🌐 Executando testes de Rede e Dispositivos..." -ForegroundColor Green
        robot tests\rede_dispositivos_test.robot
    }
    "6" {
        Write-Host "🎯 Executando Automações Completas do Menu Configurações..." -ForegroundColor Green
        Write-Host "📋 Este teste inclui:" -ForegroundColor Yellow
        Write-Host "   • Rede e Internet → Internet" -ForegroundColor White
        Write-Host "   • Rede e Internet → Modo Avião (habilitar/desabilitar)" -ForegroundColor White
        Write-Host "   • Dispositivos Conectados → Parear novo dispositivo" -ForegroundColor White
        Write-Host "   • Bateria → Gerenciador de bateria" -ForegroundColor White
        Write-Host "   • Som e Vibração → Volume de mídia (0% e 50%)" -ForegroundColor White
        Write-Host "   • Acessibilidade → Densidade de impressão" -ForegroundColor White
        Write-Host ""
        robot tests\automacoes_completas_test.robot
    }
    "7" {
        Write-Host "📊 Executando todos os testes..." -ForegroundColor Green
        robot tests\
    }
    default {
        Write-Host "❌ Opção inválida!" -ForegroundColor Red
        Read-Host "Pressione Enter para sair"
        exit 1
    }
}

Write-Host ""
Write-Host "✅ Execução concluída!" -ForegroundColor Green
Write-Host "📄 Relatórios salvos em logs/" -ForegroundColor Cyan
Write-Host "📸 Screenshots salvos em screenshots/" -ForegroundColor Cyan
Read-Host "Pressione Enter para sair"