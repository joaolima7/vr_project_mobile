# VR Project Mobile - Flutter

Sistema de notificações mobile desenvolvido em Flutter para o teste técnico VR.

## Tecnologias

- Flutter 3.x
- BLoC Pattern (State Management)
- GetIt (Dependency Injection)
- Dio (HTTP Client)
- Clean Architecture

## Pré-requisitos

- Flutter SDK 3.0.0+
- Dart 3.0.0+
- Android Studio / Xcode (para emuladores)
- Backend rodando (vr_project_back)

## Configuração

### 1. Instalar dependências

```bash
flutter pub get
```

### 2. Configurar IP do Backend

Edite o arquivo `lib/core/network/api_endpoints.dart`:

```dart
static const String baseUrl = 'http://SEU_IP_LOCAL:8080';
```

Para descobrir seu IP:

**Mac/Linux:**
```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```

**Windows:**
```bash
ipconfig
```

### 3. Gerar código (DTOs)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Executar

### Emulador/Dispositivo

```bash
flutter run
```

### Modo Release

```bash
flutter run --release
```

## Funcionalidades

- Enviar notificações para o backend
- Visualizar lista de notificações
- Atualização automática de status (polling a cada 3s)
- Interface responsiva e intuitiva
- Indicadores visuais de status

## Estrutura

```
lib/
├── config/          # Tema e constantes
├── core/            # Componentes compartilhados
│   ├── di/         # Dependency Injection
│   ├── network/    # Cliente HTTP
│   └── components/ # Widgets reutilizáveis
└── features/
    └── notification/
        ├── data/        # DTOs, DataSources, Repositories
        ├── domain/      # Entities, UseCases, Interfaces
        └── presentation/# BLoC, Screens, Widgets
```

## Testar

### Unit Tests

```bash
flutter test
```

### Widget Tests

```bash
flutter test test/widget/
```

## Status da Notificação

- **Enfileirado**: Notificação enviada ao backend
- **Aguardando Processamento**: Backend recebeu, aguardando processamento
- **Processado com Sucesso**: Processamento concluído (verde)
- **Falha no Processamento**: Erro no processamento (vermelho)

## Troubleshooting

**Erro de conexão:**
- Verifique se o backend está rodando
- Confirme o IP em `api_endpoints.dart`
- Teste com: `curl http://SEU_IP:8080/health`

**Erro ao gerar código:**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```