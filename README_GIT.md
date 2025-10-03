# 🤖 Automação Android - ADB + YAML

[![Robot Framework](https://img.shields.io/badge/Robot%20Framework-7.0-blue.svg)](https://robotframework.org/)
[![ADB](https://img.shields.io/badge/ADB-Direct-green.svg)](https://developer.android.com/studio/command-line/adb)
[![YAML](https://img.shields.io/badge/Locators-YAML-orange.svg)](https://yaml.org/)

Automação de dispositivos Android usando **Robot Framework** com **ADB direto** e sistema inteligente de **locators YAML**. Sem dependência do Appium Server!

## 🚀 Quick Start

```bash
# 1. Clonar repositório
git clone <seu-repositorio>
cd automacao-adb

# 2. Criar ambiente virtual
python3 -m venv .venv
source .venv/bin/activate

# 3. Instalar dependências
pip install -r requirements.txt

# 4. Conectar dispositivo Android e executar
./run_tests.sh
```

## ✨ Características

- **🚀 Zero configuração**: Sem Appium Server
- **📱 Multi-dispositivo**: Samsung, Xiaomi, Google, Huawei
- **🎯 YAML Inteligente**: Locators adaptativos
- **📸 Screenshots**: Captura automática
- **🔧 Modular**: Sistema base.resource

## 📁 Estrutura

```
automacao-adb/
├── tests/                    # Testes ADB + YAML
├── resources/               # Locators e keywords
├── base.resource           # Sistema modular
└── run_tests.sh           # Script interativo
```

## 🎯 Testes Disponíveis

| Arquivo | Descrição | Testes |
|---------|-----------|--------|
| `adb_basic_tests.robot` | 🚀 Básico | 6 |
| `configuracoes_adb_yaml_test.robot` | 🎯 Principal | 9 |
| `yaml_locators_test.robot` | 🔬 Avançado | 5 |
| `device_detection_tests.robot` | 📱 Detecção | 3 |

## 📋 Pré-requisitos

- **Android SDK** com ADB
- **Python 3.8+**
- **Dispositivo Android** com USB Debug

## 🔧 Setup Detalhado

### 1. Ambiente Python
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### 2. Android SDK
```bash
# Ubuntu/Debian
sudo apt install android-sdk-platform-tools

# Verificar ADB
adb version
```

### 3. Dispositivo Android
1. **Configurações** → **Sobre o telefone**
2. Tocar 7x em **Número da versão**
3. **Configurações** → **Opções do desenvolvedor**
4. Ativar **Depuração USB**

### 4. Verificar Conexão
```bash
adb devices
# Deve mostrar: device
```

## 🚀 Execução

### Script Interativo (Recomendado)
```bash
./run_tests.sh
```

### Comandos Diretos
```bash
# Teste básico
robot tests/adb_basic_tests.robot

# Teste principal (ADB + YAML)
robot tests/configuracoes_adb_yaml_test.robot

# Todos os testes
robot tests/
```

## 📊 Resultados

- **Screenshots**: `screenshots/`
- **Logs**: `logs/`
- **Relatórios**: `output.xml`, `log.html`, `report.html`

## 🛠️ Desenvolvimento

### Adicionar Novos Testes
1. Criar arquivo em `tests/`
2. Usar `Resource ../base.resource`
3. Implementar com keywords YAML

### Configurar Novo Dispositivo
1. Editar `resources/locators.yml`
2. Adicionar seção do fabricante
3. Testar com `device_detection_tests.robot`

## 📚 Documentação

- [BASE_RESOURCE.md](BASE_RESOURCE.md) - Sistema modular
- [YAML_LOCATORS.md](YAML_LOCATORS.md) - Sistema de locators

## 🤝 Contribuindo

1. Fork do projeto
2. Criar branch feature
3. Commit das mudanças
4. Push para branch
5. Abrir Pull Request

## 📝 Licença

Este projeto está sob licença MIT.

---

**Feito com ❤️ para automação Android eficiente**