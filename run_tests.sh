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
echo "1) Rede e Internet (Cenários 2-5, 14-15, 17-18)"
echo "2) Detalhes da Rede (Cenários de detalhes de rede conectada)"
echo "3) Dispositivos Conectados (Cenários 20-23)"
echo "4) Configurações completas (Todos os cenários)"
echo "5) Todos os testes individuais"
echo "6) Execução customizada"
echo ""
read -p "Digite sua opção (1-6): " opcao

case $opcao in
    1)
        echo "🌐 Executando testes de Rede e Internet..."
        echo "   📋 Cenários: 2-5 (Rede e Internet), 14-15 (Wi-Fi), 17-18 (Detalhes Rede)"
        robot tests/redeEInternet.robot
        ;;
    2)
        echo "🔍 Executando testes de Detalhes da Rede..."
        echo "   📋 Cenários: Detalhes da rede Wi-Fi conectada"
        robot tests/detalhesRede.robot
        ;;
    3)
        echo "� Executando testes de Dispositivos Conectados..."
        echo "   📋 Cenários: 20 (Dispositivos), 21 (Parear), 22-23 (Preferências)"
        robot tests/dispositivosConectados.robot
        ;;
    4)
        echo "⚙️ Executando configurações completas..."
        echo "   📋 Todos os cenários de configuração do Android"
        robot --include configuracoes tests/
        ;;
    5)
        echo "📊 Executando TODOS os testes..."
        robot tests/
        ;;
    6)
        echo "� Execução customizada - Escolha o arquivo de teste:"
        echo "   1. redeEInternet.robot"
        echo "   2. detalhesRede.robot" 
        echo "   3. dispositivosConectados.robot"
        read -p "   Digite o número (1-3): " teste_custom
        case $teste_custom in
            1) robot tests/redeEInternet.robot ;;
            2) robot tests/detalhesRede.robot ;;
            3) robot tests/dispositivosConectados.robot ;;
            *) echo "❌ Opção inválida!"; exit 1 ;;
        esac
        ;;
    *)
        echo "❌ Opção inválida!"
        exit 1
        ;;
esac

echo ""
echo "✅ Execução concluída!"
echo "================================="
echo "� Arquivos gerados:"
echo "   �📄 Relatórios: log.html, report.html, output.xml"
echo "   📸 Screenshots: screenshots/"
echo "   🔍 Dumps UI: dumps/"
echo "   📋 Logs: logs/"
echo ""
echo "🔗 Cenários implementados:"
echo "   📡 Rede e Internet: 2-5, 14-15, 17-18"
echo "   📱 Dispositivos Conectados: 20, 21, 22-23"
echo "   🔍 Detalhes da Rede: Análise de redes Wi-Fi"
echo ""
echo "💡 Dica: Abra log.html no navegador para ver relatório detalhado"