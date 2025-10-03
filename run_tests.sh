#!/bin/bash

# Script para executar testes ADB + YAML
# Automação Android sem dependência do Appium Server

echo "🚀 Executando Testes ADB + YAML"
echo "================================="

# Verificar se há dispositivo conectado
echo "📱 Verificando dispositivos conectados..."
ADB_DEVICES=$(adb devices | grep -v "List of devices" | grep "device$" | wc -l)

if [ "$ADB_DEVICES" -eq 0 ]; then
    echo "❌ Nenhum dispositivo Android conectado!"
    echo "💡 Conecte um dispositivo via USB e ative a Depuração USB"
    exit 1
fi

echo "✅ $ADB_DEVICES dispositivo(s) conectado(s)"

# Ativar ambiente virtual se existir
if [ -d ".venv" ]; then
    echo "🐍 Ativando ambiente virtual..."
    source .venv/bin/activate
fi

# Criar diretórios necessários
mkdir -p screenshots logs

echo ""
echo "🎯 Escolha qual teste executar:"
echo "1) Testes básicos ADB (Iniciante)"
echo "2) Configurações ADB + YAML (Recomendado)"
echo "3) Sistema YAML Locators (Avançado)"
echo "4) Detecção de Dispositivos"
echo "5) Rede e Dispositivos Conectados"
echo "6) Automações Completas - Menu Configurações (NOVO!)"
echo "7) Todos os testes"
echo ""
read -p "Digite sua opção (1-7): " opcao

case $opcao in
    1)
        echo "🚀 Executando testes básicos ADB..."
        robot tests/adb_basic_tests.robot
        ;;
    2)
        echo "🎯 Executando configurações ADB + YAML..."
        robot tests/configuracoes_adb_yaml_test.robot
        ;;
    3)
        echo "🔬 Executando sistema YAML Locators..."
        robot tests/yaml_locators_test.robot
        ;;
    4)
        echo "📱 Executando detecção de dispositivos..."
        robot tests/device_detection_tests.robot
        ;;
    5)
        echo "🌐 Executando testes de Rede e Dispositivos..."
        robot tests/rede_dispositivos_test.robot
        ;;
    6)
        echo "🎯 Executando Automações Completas do Menu Configurações..."
        echo "📋 Este teste inclui:"
        echo "   • Rede e Internet → Internet"
        echo "   • Rede e Internet → Modo Avião (habilitar/desabilitar)"
        echo "   • Dispositivos Conectados → Parear novo dispositivo"
        echo "   • Bateria → Gerenciador de bateria"
        echo "   • Som e Vibração → Volume de mídia (0% e 50%)"
        echo "   • Acessibilidade → Densidade de impressão"
        echo ""
        robot tests/automacoes_completas_test.robot
        ;;
    7)
        echo "📊 Executando todos os testes..."
        robot tests/
        ;;
    *)
        echo "❌ Opção inválida!"
        exit 1
        ;;
esac

echo ""
echo "✅ Execução concluída!"
echo "📄 Relatórios salvos em logs/"
echo "📸 Screenshots salvos em screenshots/"