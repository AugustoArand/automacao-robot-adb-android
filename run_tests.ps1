# Script PowerShell para executar testes ADB + YAML
# Automação Android sem dependência do Appium Server

Write-Host "🚀 Executando Testes ADB + YAML" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green

# Verificar se há dispositivo conectado
Write-Host "📱 Verificando dispositivos conectados..." -ForegroundColor Yellow
$adbDevices = (adb devices | Where-Object { $_ -match "device$" }).Count

if ($adbDevices -eq 0) {
    Write-Host "❌ Nenhum dispositivo Android conectado!" -ForegroundColor Red
    Write-Host "💡 Conecte um dispositivo via USB e ative a Depuração USB" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ $adbDevices dispositivo(s) conectado(s)" -ForegroundColor Green

# Ativar ambiente virtual se existir
if (Test-Path ".venv") {
    Write-Host "🐍 Ativando ambiente virtual..." -ForegroundColor Yellow
    & ".\.venv\Scripts\Activate.ps1"
}

# Criar diretórios necessários
New-Item -ItemType Directory -Force -Path "screenshots", "logs" | Out-Null

Write-Host ""
Write-Host "🎯 Escolha qual teste executar:" -ForegroundColor Cyan
Write-Host "1) Rede e Internet (Cenários 2-5, 14-15, 17-18)" -ForegroundColor White
Write-Host "2) Detalhes da Rede (Cenários de detalhes de rede conectada)" -ForegroundColor White
Write-Host "3) Dispositivos Conectados (Cenários 20-23)" -ForegroundColor White
Write-Host "4) Configurações completas (Todos os cenários)" -ForegroundColor White
Write-Host "5) Todos os testes individuais" -ForegroundColor White
Write-Host "6) Execução customizada" -ForegroundColor White
Write-Host ""

$opcao = Read-Host "Digite sua opção (1-6)"

switch ($opcao) {
    1 {
        Write-Host "🌐 Executando testes de Rede e Internet..." -ForegroundColor Green
        Write-Host "   📋 Cenários: 2-5 (Rede e Internet), 14-15 (Wi-Fi), 17-18 (Detalhes Rede)" -ForegroundColor Yellow
        robot tests/redeEInternet.robot
    }
    2 {
        Write-Host "🔍 Executando testes de Detalhes da Rede..." -ForegroundColor Green  
        Write-Host "   📋 Cenários: Detalhes da rede Wi-Fi conectada" -ForegroundColor Yellow
        robot tests/detalhesRede.robot
    }
    3 {
        Write-Host "📱 Executando testes de Dispositivos Conectados..." -ForegroundColor Green
        Write-Host "   📋 Cenários: 20 (Dispositivos), 21 (Parear), 22-23 (Preferências)" -ForegroundColor Yellow
        robot tests/dispositivosConectados.robot
    }
    4 {
        Write-Host "⚙️ Executando configurações completas..." -ForegroundColor Green
        Write-Host "   📋 Todos os cenários de configuração do Android" -ForegroundColor Yellow
        robot --include configuracoes tests/
    }
    5 {
        Write-Host "📊 Executando TODOS os testes..." -ForegroundColor Green
        robot tests/
    }
    6 {
        Write-Host "🔧 Execução customizada - Escolha o arquivo de teste:" -ForegroundColor Cyan
        Write-Host "   1. redeEInternet.robot" -ForegroundColor White
        Write-Host "   2. detalhesRede.robot" -ForegroundColor White
        Write-Host "   3. dispositivosConectados.robot" -ForegroundColor White
        $testeCustom = Read-Host "   Digite o número (1-3)"
        switch ($testeCustom) {
            1 { robot tests/redeEInternet.robot }
            2 { robot tests/detalhesRede.robot }
            3 { robot tests/dispositivosConectados.robot }
            default { 
                Write-Host "❌ Opção inválida!" -ForegroundColor Red
                exit 1 
            }
        }
    }
    default {
        Write-Host "❌ Opção inválida!" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "✅ Execução concluída!" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green
Write-Host "📁 Arquivos gerados:" -ForegroundColor Cyan
Write-Host "   📄 Relatórios: log.html, report.html, output.xml" -ForegroundColor White
Write-Host "   📸 Screenshots: screenshots/" -ForegroundColor White
Write-Host "   🔍 Dumps UI: dumps/" -ForegroundColor White
Write-Host "   📋 Logs: logs/" -ForegroundColor White
Write-Host ""
Write-Host "🔗 Cenários implementados:" -ForegroundColor Cyan
Write-Host "   📡 Rede e Internet: 2-5, 14-15, 17-18" -ForegroundColor White
Write-Host "   📱 Dispositivos Conectados: 20, 21, 22-23" -ForegroundColor White
Write-Host "   🔍 Detalhes da Rede: Análise de redes Wi-Fi" -ForegroundColor White
Write-Host ""
Write-Host "💡 Dica: Abra log.html no navegador para ver relatório detalhado" -ForegroundColor Yellow