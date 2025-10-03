@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM Script para executar testes ADB + YAML
REM Automação Android sem dependência do Appium Server

echo 🚀 Executando Testes ADB + YAML
echo =================================

REM Verificar se há dispositivo conectado
echo 📱 Verificando dispositivos conectados...

adb devices > temp_devices.txt 2>&1
if %errorlevel% neq 0 (
    echo ❌ ADB não encontrado! Verifique se o Android SDK está instalado.
    pause
    exit /b 1
)

REM Contar dispositivos conectados
findstr /c:"device$" temp_devices.txt > connected_devices.txt
set device_count=0
for /f %%i in ('type connected_devices.txt ^| find /c /v ""') do set device_count=%%i

if !device_count! equ 0 (
    echo ❌ Nenhum dispositivo Android conectado!
    echo 💡 Conecte um dispositivo via USB e ative a Depuração USB
    del temp_devices.txt connected_devices.txt 2>nul
    pause
    exit /b 1
)

echo ✅ !device_count! dispositivo^(s^) conectado^(s^)
del temp_devices.txt connected_devices.txt 2>nul

REM Ativar ambiente virtual se existir
if exist ".venv" (
    echo 🐍 Ativando ambiente virtual...
    call .venv\Scripts\activate.bat
)

REM Criar diretórios necessários
if not exist "screenshots" mkdir screenshots
if not exist "logs" mkdir logs

echo.
echo 🎯 Escolha qual teste executar:
echo 1^) Testes básicos ADB ^(Iniciante^)
echo 2^) Configurações ADB + YAML ^(Recomendado^)
echo 3^) Sistema YAML Locators ^(Avançado^)
echo 4^) Detecção de Dispositivos
echo 5^) Rede e Dispositivos Conectados
echo 6^) Automações Completas - Menu Configurações ^(NOVO!^)
echo 7^) Todos os testes
echo.
set /p opcao="Digite sua opção (1-7): "

if "!opcao!"=="1" (
    echo 🚀 Executando testes básicos ADB...
    robot tests\adb_basic_tests.robot
) else if "!opcao!"=="2" (
    echo 🎯 Executando configurações ADB + YAML...
    robot tests\configuracoes_adb_yaml_test.robot
) else if "!opcao!"=="3" (
    echo 🔬 Executando sistema YAML Locators...
    robot tests\yaml_locators_test.robot
) else if "!opcao!"=="4" (
    echo 📱 Executando detecção de dispositivos...
    robot tests\device_detection_tests.robot
) else if "!opcao!"=="5" (
    echo 🌐 Executando testes de Rede e Dispositivos...
    robot tests\rede_dispositivos_test.robot
) else if "!opcao!"=="6" (
    echo 🎯 Executando Automações Completas do Menu Configurações...
    echo 📋 Este teste inclui:
    echo    • Rede e Internet → Internet
    echo    • Rede e Internet → Modo Avião ^(habilitar/desabilitar^)
    echo    • Dispositivos Conectados → Parear novo dispositivo
    echo    • Bateria → Gerenciador de bateria
    echo    • Som e Vibração → Volume de mídia ^(0%% e 50%%^)
    echo    • Acessibilidade → Densidade de impressão
    echo.
    robot tests\automacoes_completas_test.robot
) else if "!opcao!"=="7" (
    echo 📊 Executando todos os testes...
    robot tests\
) else (
    echo ❌ Opção inválida!
    pause
    exit /b 1
)

echo.
echo ✅ Execução concluída!
echo 📄 Relatórios salvos em logs/
echo 📸 Screenshots salvos em screenshots/
pause