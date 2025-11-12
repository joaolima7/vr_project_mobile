# 🏗️ Flutter Clean Architecture + BLoC - AI Implementation Guide

> **Guia completo de arquitetura para assistentes de IA**  
> Padrão: Clean Architecture + BLoC Pattern + GetIt DI  
> Plataforma: Flutter (Mobile & Web)  
> Versão: 2.0.0

---

## 📋 Índice

1. [Visão Geral da Arquitetura](#visão-geral-da-arquitetura)
2. [Estrutura de Camadas](#estrutura-de-camadas)
3. [Padrões Obrigatórios](#padrões-obrigatórios)
4. [Fluxo de Implementação](#fluxo-de-implementação)
5. [Stack Tecnológica](#stack-tecnológica)
6. [Guia de Implementação por Feature](#guia-de-implementação-por-feature)
7. [Dependency Injection com GetIt](#dependency-injection-com-getit)
8. [State Management com BLoC](#state-management-com-bloc)
9. [Network Layer](#network-layer)
10. [Error Handling](#error-handling)
11. [Storage & Persistence](#storage--persistence)
12. [Testing Strategy](#testing-strategy)
13. [Code Review Checklist](#code-review-checklist)
14. [Anti-Patterns (O que NÃO fazer)](#anti-patterns-o-que-não-fazer)

---

## 🎯 Visão Geral da Arquitetura

### Princípios Fundamentais

```
CLEAN ARCHITECTURE + SOLID + DRY + KISS

┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                   │
│  (UI, Widgets, Screens, BLoCs, States, Events)         │
│  - Depende apenas do DOMAIN                             │
│  - Não conhece DATA ou INFRASTRUCTURE                   │
└─────────────────────────────────────────────────────────┘
                          ↓ ↑
┌─────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                       │
│  (Entities, UseCases, Repository Interfaces)           │
│  - Núcleo da aplicação                                  │
│  - ZERO dependências externas                           │
│  - Define contratos (interfaces)                        │
└─────────────────────────────────────────────────────────┘
                          ↓ ↑
┌─────────────────────────────────────────────────────────┐
│                       DATA LAYER                        │
│  (DTOs, Mappers, Repository Implementations)           │
│  - Implementa contratos do DOMAIN                       │
│  - Depende de DOMAIN e INFRASTRUCTURE                   │
└─────────────────────────────────────────────────────────┘
                          ↓ ↑
┌─────────────────────────────────────────────────────────┐
│                  INFRASTRUCTURE LAYER                   │
│  (Network, Database, External APIs, DI, Services)      │
│  - Detalhes de implementação                            │
│  - Frameworks, Packages, APIs                           │
└─────────────────────────────────────────────────────────┘
```

### Regras de Dependência

1. ✅ **Dependências fluem de FORA para DENTRO**
2. ✅ **Domain NÃO depende de nada** (exceto Dart puro)
3. ✅ **Data implementa interfaces do Domain**
4. ✅ **Presentation usa apenas Domain**
5. ✅ **Infrastructure é isolada**

---

## 📁 Estrutura de Camadas

### Estrutura Completa de Pastas

```
lib/
├── config/                           # Configurações globais
│   ├── theme/                       # Temas, cores, tipografia
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_theme.dart
│   ├── constants/                   # Constantes da aplicação
│   │   └── app_constants.dart
│   └── environment/                 # Variáveis de ambiente
│       └── .env.example
│
├── core/                             # Núcleo compartilhado
│   ├── common/                      # Utilitários compartilhados
│   │   ├── extensions/             # Extensions do Dart
│   │   ├── validators/             # Validações comuns
│   │   └── utils/                  # Helpers genéricos
│   │
│   ├── components/                  # Widgets reutilizáveis
│   │   ├── buttons/
│   │   ├── inputs/
│   │   ├── dialogs/
│   │   ├── loaders/
│   │   └── cards/
│   │
│   ├── di/                          # Dependency Injection
│   │   ├── dependencies_imports.dart
│   │   ├── dependency_injection.blocs.dart
│   │   ├── dependency_injection.repositories.dart
│   │   ├── dependency_injection.usecases.dart
│   │   ├── dependency_injection.services.dart
│   │   └── inject_dependencies.dart
│   │
│   ├── error/                       # Error Handling
│   │   ├── failures.dart           # Failure classes
│   │   └── exceptions.dart         # Exception classes
│   │
│   ├── network/                     # Network Layer
│   │   ├── network_client.dart     # Interface
│   │   ├── network_client_impl.dart
│   │   ├── network_request.dart
│   │   ├── network_response.dart
│   │   ├── network_interceptor.dart
│   │   └── api_endpoints.dart
│   │
│   ├── storage/                     # Local Storage
│   │   ├── local_storage.dart      # Interface
│   │   ├── secure_storage_impl.dart
│   │   └── shared_prefs_impl.dart
│   │
│   ├── router/                      # Navigation
│   │   ├── app_router.dart
│   │   └── route_guards.dart
│   │
│   └── types/                       # Type Definitions
│       └── typedefs.dart
│
├── features/                         # Features (módulos)
│   └── [feature_name]/              # Exemplo: auth, user, product
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── remote/
│       │   │   │   └── [feature]_remote_datasource.dart
│       │   │   └── local/
│       │   │       └── [feature]_local_datasource.dart
│       │   ├── dtos/
│       │   │   ├── [entity].dto.dart
│       │   │   └── [entity].dto.g.dart
│       │   ├── mappers/
│       │   │   └── [entity].mapper.dart
│       │   └── repositories/
│       │       └── [repository]_impl.dart
│       │
│       ├── domain/
│       │   ├── entities/
│       │   │   └── [entity].entity.dart
│       │   ├── repositories/
│       │   │   └── [repository].dart
│       │   └── usecases/
│       │       └── [action]_[entity].usecase.dart
│       │
│       └── presentation/
│           ├── blocs/
│           │   └── [feature]/
│           │       ├── [feature].bloc.dart
│           │       ├── [feature].event.dart
│           │       └── [feature].state.dart
│           ├── screens/
│           │   └── [screen_name]_screen.dart
│           ├── widgets/
│           │   └── [widget_name].dart
│           └── components/
│               └── [component_name].dart
│
├── main.dart                         # Entry point
└── app.dart                          # MaterialApp wrapper

.env                                  # Environment variables (git ignored)
.env.example                          # Template de .env
pubspec.yaml                          # Dependencies
```

---

## 📐 Padrões Obrigatórios

### 1. Nomenclatura de Arquivos

```dart
// ✅ CORRETO - snake_case
user.entity.dart
login_user.usecase.dart
user.dto.dart
user.dto.g.dart              // Generated file
auth.bloc.dart
auth.event.dart
auth.state.dart
login_screen.dart
user_card_widget.dart
auth_repository.dart         // Interface
auth_repository_impl.dart    // Implementation
```

### 2. Nomenclatura de Classes

```dart
// ✅ Classes: PascalCase
class UserEntity { }
class LoginUserUseCase { }
class AuthBloc extends Bloc { }
class LoginScreen extends StatelessWidget { }

// ✅ Variáveis e Funções: camelCase
final userName = 'João';
void loginUser() { }
Future<void> fetchData() async { }

// ✅ Constantes: SCREAMING_SNAKE_CASE ou lowerCamelCase
const String API_BASE_URL = 'https://api.example.com';
const primaryColor = Color(0xFF6200EE);

// ✅ Privados: underscore prefix
class AuthBloc {
  final LoginUserUseCase _loginUserUseCase;
  void _handleLogin() { }
}

// ✅ Interfaces: Sem prefixo/sufixo especial
abstract class UserRepository { }      // Interface
class UserRepositoryImpl implements UserRepository { } // Implementation
```

### 3. Imports Organization

```dart
// ✅ ORDEM CORRETA
// 1. Dart SDK
import 'dart:async';
import 'dart:convert';

// 2. Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Packages (terceiros)
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dartz/dartz.dart';

// 4. Projeto (absolute imports)
import 'package:my_app/core/error/failures.dart';
import 'package:my_app/features/auth/domain/entities/user.entity.dart';

// 5. Relativos (evitar quando possível)
import '../utils/validators.dart';
```

---

## 🔄 Fluxo de Implementação

### Ordem OBRIGATÓRIA para implementar uma Feature

```
1. DOMAIN LAYER (Business Logic)
   ├─ 1.1. Criar Entity
   ├─ 1.2. Criar Repository Interface
   └─ 1.3. Criar UseCase

2. DATA LAYER (Data Management)
   ├─ 2.1. Criar DTO
   ├─ 2.2. Criar Mapper (DTO ↔ Entity)
   ├─ 2.3. Criar DataSource (se necessário)
   └─ 2.4. Implementar Repository

3. PRESENTATION LAYER (UI)
   ├─ 3.1. Criar States (sealed classes)
   ├─ 3.2. Criar Events
   ├─ 3.3. Criar BLoC
   ├─ 3.4. Criar Screen/Widgets
   └─ 3.5. Integrar com BLoC

4. DEPENDENCY INJECTION
   ├─ 4.1. Registrar DataSources
   ├─ 4.2. Registrar Repositories
   ├─ 4.3. Registrar UseCases
   └─ 4.4. Registrar BLoCs

5. TESTING (em paralelo)
   ├─ 5.1. Unit Tests (UseCases)
   ├─ 5.2. Widget Tests (UI)
   └─ 5.3. Integration Tests
```

---

## 🔧 Stack Tecnológica

### Dependencies Obrigatórias

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management (OBRIGATÓRIO)
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5              # Para comparação de estados

  # Dependency Injection (OBRIGATÓRIO)
  get_it: ^7.6.4

  # Functional Programming (OBRIGATÓRIO)
  dartz: ^0.10.1                 # Either, Option, etc

  # Networking (OBRIGATÓRIO)
  dio: ^5.4.0
  
  # JSON Serialization (OBRIGATÓRIO)
  json_annotation: ^4.8.1

  # Environment Variables (RECOMENDADO)
  flutter_dotenv: ^5.1.0

  # Storage (escolher conforme necessidade)
  shared_preferences: ^2.2.2     # Dados simples
  flutter_secure_storage: ^9.0.0 # Dados sensíveis
  hive: ^2.2.3                   # NoSQL local
  sqflite: ^2.3.0                # SQL local

  # UI Utilities (RECOMENDADO)
  responsive_framework: ^1.1.1   # Responsive design
  intl: ^0.18.1                  # Internationalization
  cached_network_image: ^3.3.0   # Image caching

dev_dependencies:
  # Code Generation (OBRIGATÓRIO)
  build_runner: ^2.4.6
  json_serializable: ^6.7.1

  # Testing (OBRIGATÓRIO)
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.5
  mocktail: ^1.0.1

  # Linting (OBRIGATÓRIO)
  flutter_lints: ^3.0.0
```

---

## 🎨 Guia de Implementação por Feature

### Template Completo de Feature

#### 1. DOMAIN LAYER

##### 1.1. Entity (domain/entities/)

```dart
// filepath: lib/features/[feature]/domain/entities/user.entity.dart

import 'package:equatable/equatable.dart';

/// Representa um usuário do sistema
/// 
/// [Entity] é um objeto de domínio puro, sem dependências de frameworks
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, email, createdAt];

  @override
  bool get stringify => true;
}
```

##### 1.2. Repository Interface (domain/repositories/)

```dart
// filepath: lib/features/[feature]/domain/repositories/user.repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/types/typedefs.dart';
import '../entities/user.entity.dart';

/// Interface do repositório de usuários
/// 
/// Define os contratos que a camada de DATA deve implementar
abstract class UserRepository {
  /// Busca todos os usuários
  ResultFuture<List<UserEntity>> getUsers();

  /// Busca um usuário por ID
  ResultFuture<UserEntity> getUserById(String id);

  /// Cria um novo usuário
  ResultFuture<UserEntity> createUser({
    required String name,
    required String email,
  });

  /// Atualiza um usuário existente
  ResultFuture<UserEntity> updateUser({
    required String id,
    String? name,
    String? email,
  });

  /// Deleta um usuário
  ResultVoid deleteUser(String id);
}
```

##### 1.3. UseCase (domain/usecases/)

```dart
// filepath: lib/features/[feature]/domain/usecases/get_users.usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/types/typedefs.dart';
import '../entities/user.entity.dart';
import '../repositories/user.repository.dart';

/// Caso de uso: Buscar todos os usuários
/// 
/// Regra de negócio: Cada UseCase deve ter UMA única responsabilidade
class GetUsersUseCase {
  final UserRepository _repository;

  const GetUsersUseCase({required UserRepository repository})
      : _repository = repository;

  /// Executa o caso de uso
  /// 
  /// Retorna Either<Failure, List<UserEntity>>:
  /// - Left: Em caso de erro
  /// - Right: Em caso de sucesso
  ResultFuture<List<UserEntity>> call() async {
    return await _repository.getUsers();
  }
}
```

```dart
// filepath: lib/features/[feature]/domain/usecases/create_user.usecase.dart

import '../../../../core/types/typedefs.dart';
import '../entities/user.entity.dart';
import '../repositories/user.repository.dart';

/// Caso de uso: Criar novo usuário
class CreateUserUseCase {
  final UserRepository _repository;

  const CreateUserUseCase({required UserRepository repository})
      : _repository = repository;

  /// Executa a criação de usuário com validações de negócio
  ResultFuture<UserEntity> call({
    required String name,
    required String email,
  }) async {
    // Validações de negócio aqui (se houver)
    if (name.trim().isEmpty) {
      return Left(ValidationFailure(message: 'Nome não pode ser vazio'));
    }

    if (!_isValidEmail(email)) {
      return Left(ValidationFailure(message: 'Email inválido'));
    }

    return await _repository.createUser(name: name, email: email);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
```

#### 2. DATA LAYER

##### 2.1. DTO (data/dtos/)

```dart
// filepath: lib/features/[feature]/data/dtos/user.dto.dart

import 'package:json_annotation/json_annotation.dart';

part 'user.dto.g.dart';

/// Data Transfer Object para User
/// 
/// Responsável por serialização/deserialização JSON
@JsonSerializable()
class UserDto {
  final String id;
  final String name;
  final String email;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  const UserDto({
    required this.id,
    required this.name,
    required this.email,
    this.createdAt,
  });

  /// Deserialização: JSON → DTO
  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  /// Serialização: DTO → JSON
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}
```

##### 2.2. Mapper (data/mappers/)

```dart
// filepath: lib/features/[feature]/data/mappers/user.mapper.dart

import '../../domain/entities/user.entity.dart';
import '../dtos/user.dto.dart';

/// Extensão para conversão DTO ↔ Entity
extension UserMapper on UserDto {
  /// Converte DTO para Entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
    );
  }
}

extension UserEntityMapper on UserEntity {
  /// Converte Entity para DTO
  UserDto toDto() {
    return UserDto(
      id: id,
      name: name,
      email: email,
      createdAt: createdAt?.toIso8601String(),
    );
  }
}
```

##### 2.3. DataSource (data/datasources/)

```dart
// filepath: lib/features/[feature]/data/datasources/remote/user_remote_datasource.dart

import '../../../../../core/network/network_client.dart';
import '../../../../../core/network/network_request.dart';
import '../../../../../core/error/exceptions.dart';
import '../../dtos/user.dto.dart';

/// Interface do DataSource Remoto
abstract class UserRemoteDataSource {
  Future<List<UserDto>> getUsers();
  Future<UserDto> getUserById(String id);
  Future<UserDto> createUser({required String name, required String email});
  Future<UserDto> updateUser({required String id, String? name, String? email});
  Future<void> deleteUser(String id);
}

/// Implementação do DataSource usando NetworkClient
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final NetworkClient _client;

  const UserRemoteDataSourceImpl({required NetworkClient client})
      : _client = client;

  @override
  Future<List<UserDto>> getUsers() async {
    try {
      final request = NetworkGetRequest(
        endpoint: '/users',
      );

      final response = await _client.get(request: request);

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Erro ao buscar usuários',
          statusCode: response.statusCode,
        );
      }

      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => UserDto.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserDto> createUser({
    required String name,
    required String email,
  }) async {
    try {
      final request = NetworkPostRequest(
        endpoint: '/users',
        body: {'name': name, 'email': email},
      );

      final response = await _client.post(request: request);

      if (response.statusCode != 201) {
        throw ServerException(
          message: 'Erro ao criar usuário',
          statusCode: response.statusCode,
        );
      }

      return UserDto.fromJson(response.data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // ... outros métodos
}
```

##### 2.4. Repository Implementation (data/repositories/)

```dart
// filepath: lib/features/[feature]/data/repositories/user.repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/types/typedefs.dart';
import '../../domain/entities/user.entity.dart';
import '../../domain/repositories/user.repository.dart';
import '../datasources/remote/user_remote_datasource.dart';
import '../mappers/user.mapper.dart';

/// Implementação do repositório de usuários
/// 
/// Coordena DataSources e converte exceções em Failures
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  const UserRepositoryImpl({
    required UserRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  ResultFuture<List<UserEntity>> getUsers() async {
    try {
      final dtos = await _remoteDataSource.getUsers();
      final entities = dtos.map((dto) => dto.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<UserEntity> createUser({
    required String name,
    required String email,
  }) async {
    try {
      final dto = await _remoteDataSource.createUser(
        name: name,
        email: email,
      );
      return Right(dto.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  // ... outros métodos
}
```

#### 3. PRESENTATION LAYER

##### 3.1. States (presentation/blocs/[feature]/)

```dart
// filepath: lib/features/[feature]/presentation/blocs/user/user.state.dart

part of 'user.bloc.dart';

/// Estados do UserBloc
/// 
/// Usar sealed class para pattern matching exaustivo
sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
final class UserInitial extends UserState {
  const UserInitial();
}

/// Carregando dados
final class UserLoading extends UserState {
  const UserLoading();
}

/// Usuários carregados com sucesso
final class UsersLoaded extends UserState {
  final List<UserEntity> users;

  const UsersLoaded({required this.users});

  @override
  List<Object?> get props => [users];
}

/// Usuário criado com sucesso
final class UserCreated extends UserState {
  final UserEntity user;

  const UserCreated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Erro ao processar
final class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object?> get props => [message];
}
```

##### 3.2. Events (presentation/blocs/[feature]/)

```dart
// filepath: lib/features/[feature]/presentation/blocs/user/user.event.dart

part of 'user.bloc.dart';

/// Eventos do UserBloc
sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

/// Evento: Carregar lista de usuários
final class LoadUsers extends UserEvent {
  const LoadUsers();
}

/// Evento: Criar novo usuário
final class CreateUser extends UserEvent {
  final String name;
  final String email;

  const CreateUser({
    required this.name,
    required this.email,
  });

  @override
  List<Object?> get props => [name, email];
}

/// Evento: Atualizar usuário
final class UpdateUser extends UserEvent {
  final String id;
  final String? name;
  final String? email;

  const UpdateUser({
    required this.id,
    this.name,
    this.email,
  });

  @override
  List<Object?> get props => [id, name, email];
}

/// Evento: Deletar usuário
final class DeleteUser extends UserEvent {
  final String id;

  const DeleteUser({required this.id});

  @override
  List<Object?> get props => [id];
}
```

##### 3.3. BLoC (presentation/blocs/[feature]/)

```dart
// filepath: lib/features/[feature]/presentation/blocs/user/user.bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.entity.dart';
import '../../../domain/usecases/get_users.usecase.dart';
import '../../../domain/usecases/create_user.usecase.dart';
import '../../../domain/usecases/update_user.usecase.dart';
import '../../../domain/usecases/delete_user.usecase.dart';

part 'user.event.dart';
part 'user.state.dart';

/// BLoC para gerenciamento de usuários
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersUseCase _getUsersUseCase;
  final CreateUserUseCase _createUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final DeleteUserUseCase _deleteUserUseCase;

  UserBloc({
    required GetUsersUseCase getUsersUseCase,
    required CreateUserUseCase createUserUseCase,
    required UpdateUserUseCase updateUserUseCase,
    required DeleteUserUseCase deleteUserUseCase,
  })  : _getUsersUseCase = getUsersUseCase,
        _createUserUseCase = createUserUseCase,
        _updateUserUseCase = updateUserUseCase,
        _deleteUserUseCase = deleteUserUseCase,
        super(const UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<CreateUser>(_onCreateUser);
    on<UpdateUser>(_onUpdateUser);
    on<DeleteUser>(_onDeleteUser);
  }

  Future<void> _onLoadUsers(
    LoadUsers event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());

    final result = await _getUsersUseCase();

    result.fold(
      (failure) => emit(UserError(message: failure.message)),
      (users) => emit(UsersLoaded(users: users)),
    );
  }

  Future<void> _onCreateUser(
    CreateUser event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());

    final result = await _createUserUseCase(
      name: event.name,
      email: event.email,
    );

    result.fold(
      (failure) => emit(UserError(message: failure.message)),
      (user) => emit(UserCreated(user: user)),
    );
  }

  Future<void> _onUpdateUser(
    UpdateUser event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());

    final result = await _updateUserUseCase(
      id: event.id,
      name: event.name,
      email: event.email,
    );

    result.fold(
      (failure) => emit(UserError(message: failure.message)),
      (user) => emit(UserCreated(user: user)),
    );
  }

  Future<void> _onDeleteUser(
    DeleteUser event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());

    final result = await _deleteUserUseCase(event.id);

    result.fold(
      (failure) => emit(UserError(message: failure.message)),
      (_) {
        // Recarregar lista após deletar
        add(const LoadUsers());
      },
    );
  }
}
```

##### 3.4. Screen (presentation/screens/)

```dart
// filepath: lib/features/[feature]/presentation/screens/user_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependencies_imports.dart';
import '../blocs/user/user.bloc.dart';
import '../widgets/user_list_item.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Usar .value se for Singleton no GetIt
      create: (_) => getIt<UserBloc>()..add(const LoadUsers()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Usuários'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Navigate to create user screen
              },
            ),
          ],
        ),
        body: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            // Reações a mudanças de estado
            if (state is UserError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }

            if (state is UserCreated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Usuário criado com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
              // Recarregar lista
              context.read<UserBloc>().add(const LoadUsers());
            }
          },
          builder: (context, state) {
            // Renderização baseada no estado
            if (state is UserLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is UsersLoaded) {
              if (state.users.isEmpty) {
                return const Center(
                  child: Text('Nenhum usuário encontrado'),
                );
              }

              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return UserListItem(
                    user: user,
                    onTap: () {
                      // Navigate to detail
                    },
                    onDelete: () {
                      context.read<UserBloc>().add(DeleteUser(id: user.id));
                    },
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
```

#### 4. DEPENDENCY INJECTION

```dart
// filepath: lib/core/di/dependency_injection.datasources.dart

part of 'dependencies_imports.dart';

Future<void> registerDataSources() async {
  // Remote DataSources
  if (!getIt.isRegistered<UserRemoteDataSource>()) {
    getIt.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(client: getIt()),
    );
  }

  // Local DataSources (se houver)
  // getIt.registerLazySingleton<UserLocalDataSource>(...)
}
```

```dart
// filepath: lib/core/di/dependency_injection.repositories.dart

part of 'dependencies_imports.dart';

Future<void> registerRepositories() async {
  if (!getIt.isRegistered<UserRepository>()) {
    getIt.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(
        remoteDataSource: getIt(),
      ),
    );
  }
}
```

```dart
// filepath: lib/core/di/dependency_injection.usecases.dart

part of 'dependencies_imports.dart';

Future<void> registerUseCases() async {
  // User UseCases
  if (!getIt.isRegistered<GetUsersUseCase>()) {
    getIt.registerLazySingleton<GetUsersUseCase>(
      () => GetUsersUseCase(repository: getIt()),
    );
  }

  if (!getIt.isRegistered<CreateUserUseCase>()) {
    getIt.registerLazySingleton<CreateUserUseCase>(
      () => CreateUserUseCase(repository: getIt()),
    );
  }

  if (!getIt.isRegistered<UpdateUserUseCase>()) {
    getIt.registerLazySingleton<UpdateUserUseCase>(
      () => UpdateUserUseCase(repository: getIt()),
    );
  }

  if (!getIt.isRegistered<DeleteUserUseCase>()) {
    getIt.registerLazySingleton<DeleteUserUseCase>(
      () => DeleteUserUseCase(repository: getIt()),
    );
  }
}
```

```dart
// filepath: lib/core/di/dependency_injection.blocs.dart

part of 'dependencies_imports.dart';

Future<void> registerBlocs() async {
  // Registrar como Singleton se quiser manter estado global
  if (!getIt.isRegistered<UserBloc>()) {
    getIt.registerSingleton<UserBloc>(
      UserBloc(
        getUsersUseCase: getIt(),
        createUserUseCase: getIt(),
        updateUserUseCase: getIt(),
        deleteUserUseCase: getIt(),
      ),
    );
  }

  // OU registrar como Factory se quiser instância nova por tela
  // getIt.registerFactory<UserBloc>(() => UserBloc(...));
}
```

---

## 🎯 Dependency Injection com GetIt

### Setup Inicial

```dart
// filepath: lib/core/di/dependencies_imports.dart

library dependencies;

import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Import all DI files
part 'dependency_injection.network.dart';
part 'dependency_injection.storage.dart';
part 'dependency_injection.datasources.dart';
part 'dependency_injection.repositories.dart';
part 'dependency_injection.usecases.dart';
part 'dependency_injection.blocs.dart';
part 'inject_dependencies.dart';

final getIt = GetIt.instance;
```

```dart
// filepath: lib/core/di/inject_dependencies.dart

part of 'dependencies_imports.dart';

bool _isInitialized = false;

/// Inicializa todas as dependências
/// 
/// Ordem importa! Respeitar hierarquia de dependências
Future<void> injectDependencies() async {
  if (_isInitialized) {
    print('⚠️ Dependências já foram injetadas');
    return;
  }

  print('⏳ Injetando dependências...');

  // 1. Carregar environment variables
  await dotenv.load(fileName: '.env');

  // 2. Registrar camada de infraestrutura
  await registerNetwork();
  await registerStorage();

  // 3. Registrar DataSources
  await registerDataSources();

  // 4. Registrar Repositories
  await registerRepositories();

  // 5. Registrar UseCases
  await registerUseCases();

  // 6. Registrar BLoCs
  await registerBlocs();

  _isInitialized = true;
  print('✅ Dependências injetadas com sucesso!');
}

/// Reseta todas as dependências (útil para testes)
Future<void> resetDependencies() async {
  await getIt.reset();
  _isInitialized = false;
}
```

### Tipos de Registro

```dart
// 1. SINGLETON - Uma única instância (lazy)
getIt.registerSingleton<AuthBloc>(AuthBloc());

// 2. LAZY SINGLETON - Criado apenas quando usado pela primeira vez
getIt.registerLazySingleton<NetworkClient>(() => NetworkClientImpl());

// 3. FACTORY - Nova instância a cada chamada
getIt.registerFactory<UserBloc>(() => UserBloc());

// 4. SINGLETON ASSÍNCRONO
getIt.registerSingletonAsync<SharedPreferences>(
  () => SharedPreferences.getInstance(),
);
await getIt.isReady<SharedPreferences>();
```

### Como usar no código

```dart
// ❌ ERRADO - Não instanciar diretamente
final bloc = UserBloc(getUsersUseCase: GetUsersUseCase());

// ✅ CORRETO - Usar GetIt
final bloc = getIt<UserBloc>();

// ✅ Em BlocProvider
BlocProvider.value(
  value: getIt<UserBloc>(),
  child: MyScreen(),
);

// ✅ Em qualquer lugar
final repository = getIt<UserRepository>();
```

---

## 🔄 State Management com BLoC

### Regras Fundamentais

1. ✅ **Estados devem ser imutáveis** (`sealed class` + `final class`)
2. ✅ **Eventos descrevem INTENÇÕES**, não implementações
3. ✅ **BLoC não deve conhecer widgets/UI**
4. ✅ **Um BLoC por feature/tela complexa**
5. ✅ **Use Equatable para comparação**

### Pattern Matching com Sealed Classes (Dart 3.0+)

```dart
// ✅ Estados com sealed class
sealed class AuthState {}

final class AuthInitial extends AuthState {}
final class AuthLoading extends AuthState {}
final class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}
final class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

// ✅ Pattern matching na UI
Widget build(BuildContext context) {
  return BlocBuilder<AuthBloc, AuthState>(
    builder: (context, state) {
      return switch (state) {
        AuthInitial() => const WelcomeScreen(),
        AuthLoading() => const LoadingIndicator(),
        AuthAuthenticated(:final user) => HomeScreen(user: user),
        AuthError(:final message) => ErrorScreen(message: message),
      };
    },
  );
}
```

### BlocBuilder vs BlocListener vs BlocConsumer

```dart
// 1. BlocBuilder - Para RENDERIZAR UI baseado no estado
BlocBuilder<UserBloc, UserState>(
  builder: (context, state) {
    if (state is UserLoading) return CircularProgressIndicator();
    if (state is UsersLoaded) return UserList(state.users);
    return SizedBox.shrink();
  },
);

// 2. BlocListener - Para SIDE EFFECTS (navegação, snackbar, etc)
BlocListener<UserBloc, UserState>(
  listener: (context, state) {
    if (state is UserError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
    if (state is UserCreated) {
      Navigator.of(context).pop();
    }
  },
  child: MyWidget(),
);

// 3. BlocConsumer - Combina Builder + Listener
BlocConsumer<UserBloc, UserState>(
  listener: (context, state) {
    // Side effects
  },
  builder: (context, state) {
    // UI rendering
  },
);
```

### Disparar Eventos

```dart
// ✅ CORRETO - Via context.read
context.read<UserBloc>().add(LoadUsers());

// ✅ CORRETO - Via BlocProvider.of
BlocProvider.of<UserBloc>(context).add(LoadUsers());

// ❌ EVITAR - Via context.watch (pode causar rebuilds desnecessários)
context.watch<UserBloc>().add(LoadUsers());
```

---

## 🌐 Network Layer

### NetworkClient Interface

```dart
// filepath: lib/core/network/network_client.dart

import 'network_request.dart';
import 'network_response.dart';

/// Interface para cliente HTTP
abstract class NetworkClient {
  Future<NetworkResponse> get({required NetworkGetRequest request});
  Future<NetworkResponse> post({required NetworkPostRequest request});
  Future<NetworkResponse> put({required NetworkPutRequest request});
  Future<NetworkResponse> delete({required NetworkDeleteRequest request});
  Future<NetworkResponse> patch({required NetworkPatchRequest request});
}
```

### NetworkClient Implementation com Dio

```dart
// filepath: lib/core/network/network_client_impl.dart

import 'package:dio/dio.dart';
import '../error/exceptions.dart';
import 'network_client.dart';
import 'network_request.dart';
import 'network_response.dart';

class NetworkClientImpl implements NetworkClient {
  final Dio _dio;

  NetworkClientImpl({required Dio dio}) : _dio = dio;

  @override
  Future<NetworkResponse> get({required NetworkGetRequest request}) async {
    try {
      final response = await _dio.get(
        request.endpoint,
        queryParameters: request.queryParameters,
        options: Options(headers: request.headers),
      );

      return NetworkResponse(
        data: response.data,
        statusCode: response.statusCode ?? 0,
        headers: response.headers.map,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  @override
  Future<NetworkResponse> post({required NetworkPostRequest request}) async {
    try {
      final response = await _dio.post(
        request.endpoint,
        data: request.body,
        queryParameters: request.queryParameters,
        options: Options(headers: request.headers),
      );

      return NetworkResponse(
        data: response.data,
        statusCode: response.statusCode ?? 0,
        headers: response.headers.map,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  // ... outros métodos

  NetworkException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: 'Timeout: Verifique sua conexão',
          statusCode: 408,
        );

      case DioExceptionType.badResponse:
        return ServerException(
          message: error.response?.data['message'] ?? 'Erro no servidor',
          statusCode: error.response?.statusCode ?? 500,
        );

      case DioExceptionType.cancel:
        return NetworkException(message: 'Requisição cancelada');

      default:
        return NetworkException(
          message: 'Erro de rede: ${error.message}',
        );
    }
  }
}
```

### API Endpoints Centralizados

```dart
// filepath: lib/core/network/api_endpoints.dart

class ApiEndpoints {
  // Base URLs
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com',
  );

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';

  // Users
  static const String users = '/users';
  static String userById(String id) => '/users/$id';

  // Products
  static const String products = '/products';
  static String productById(String id) => '/products/$id';

  // Construir URL completa
  static String buildUrl(String endpoint) => '$baseUrl$endpoint';
}
```

### Interceptors

```dart
// filepath: lib/core/network/auth_interceptor.dart

import 'package:dio/dio.dart';
import '../storage/local_storage.dart';

class AuthInterceptor extends Interceptor {
  final LocalStorage _storage;

  AuthInterceptor({required LocalStorage storage}) : _storage = storage;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getToken();
    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token expirado - tentar refresh
      final newToken = await _refreshToken();
      
      if (newToken != null) {
        // Retry request com novo token
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        final response = await Dio().fetch(err.requestOptions);
        return handler.resolve(response);
      }
    }

    super.onError(err, handler);
  }

  Future<String?> _refreshToken() async {
    // Implementar lógica de refresh token
    return null;
  }
}
```

---

## ⚠️ Error Handling

### Hierarquia de Failures

```dart
// filepath: lib/core/error/failures.dart

import 'package:equatable/equatable.dart';

/// Classe base para Failures (erros de negócio)
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Erro de servidor (API retornou erro)
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required String message,
    this.statusCode,
  }) : super(message: message);

  @override
  List<Object?> get props => [message, statusCode];
}

/// Erro de rede (sem conexão, timeout, etc)
class NetworkFailure extends Failure {
  const NetworkFailure({required String message}) : super(message: message);
}

/// Erro de validação (dados inválidos)
class ValidationFailure extends Failure {
  const ValidationFailure({required String message}) : super(message: message);
}

/// Erro de cache/storage local
class CacheFailure extends Failure {
  const CacheFailure({required String message}) : super(message: message);
}

/// Erro desconhecido
class UnknownFailure extends Failure {
  const UnknownFailure({required String message}) : super(message: message);
}
```

### Hierarquia de Exceptions

```dart
// filepath: lib/core/error/exceptions.dart

/// Classe base para Exceptions (erros técnicos)
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => message;
}

/// Erro no servidor
class ServerException extends AppException {
  const ServerException({
    required String message,
    int? statusCode,
  }) : super(message: message, statusCode: statusCode);
}

/// Erro de rede
class NetworkException extends AppException {
  const NetworkException({
    required String message,
    int? statusCode,
  }) : super(message: message, statusCode: statusCode);
}

/// Erro de cache
class CacheException extends AppException {
  const CacheException({required String message})
      : super(message: message);
}

/// Erro de validação
class ValidationException extends AppException {
  const ValidationException({required String message})
      : super(message: message);
}
```

### Conversão Exception → Failure

```dart
// No Repository
@override
ResultFuture<User> getUser(String id) async {
  try {
    final dto = await _remoteDataSource.getUser(id);
    return Right(dto.toEntity());
  } on ServerException catch (e) {
    return Left(ServerFailure(
      message: e.message,
      statusCode: e.statusCode,
    ));
  } on NetworkException catch (e) {
    return Left(NetworkFailure(message: e.message));
  } on CacheException catch (e) {
    return Left(CacheFailure(message: e.message));
  } catch (e) {
    return Left(UnknownFailure(message: e.toString()));
  }
}
```

---

## 💾 Storage & Persistence

### LocalStorage Interface

```dart
// filepath: lib/core/storage/local_storage.dart

/// Interface para armazenamento local
abstract class LocalStorage {
  // String
  Future<void> saveString(String key, String value);
  Future<String?> getString(String key);

  // Int
  Future<void> saveInt(String key, int value);
  Future<int?> getInt(String key);

  // Bool
  Future<void> saveBool(String key, bool value);
  Future<bool?> getBool(String key);

  // Delete
  Future<void> delete(String key);
  Future<void> clear();

  // Contains
  Future<bool> containsKey(String key);
}
```

### SharedPreferences Implementation

```dart
// filepath: lib/core/storage/shared_prefs_impl.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'local_storage.dart';

class SharedPrefsImpl implements LocalStorage {
  final SharedPreferences _prefs;

  const SharedPrefsImpl({required SharedPreferences prefs}) : _prefs = prefs;

  @override
  Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<void> saveInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    return _prefs.getInt(key);
  }

  @override
  Future<void> saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    return _prefs.getBool(key);
  }

  @override
  Future<void> delete(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    return _prefs.containsKey(key);
  }
}
```

### SecureStorage Implementation

```dart
// filepath: lib/core/storage/secure_storage_impl.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageImpl {
  final FlutterSecureStorage _storage;

  const SecureStorageImpl({required FlutterSecureStorage storage})
      : _storage = storage;

  Future<void> save(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }

  Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }
}
```

---

## 🧪 Testing Strategy

### Estrutura de Testes

```
test/
├── unit/
│   ├── domain/
│   │   └── usecases/
│   ├── data/
│   │   ├── datasources/
│   │   ├── repositories/
│   │   └── mappers/
│   └── presentation/
│       └── blocs/
├── widget/
│   └── presentation/
│       ├── screens/
│       └── widgets/
└── integration/
    └── features/
```

### Unit Test - UseCase

```dart
// filepath: test/unit/domain/usecases/get_users_usecase_test.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late GetUsersUseCase usecase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    usecase = GetUsersUseCase(repository: mockRepository);
  });

  group('GetUsersUseCase', () {
    final tUsers = [
      UserEntity(id: '1', name: 'User 1', email: 'user1@test.com'),
      UserEntity(id: '2', name: 'User 2', email: 'user2@test.com'),
    ];

    test('should get users from repository', () async {
      // Arrange
      when(() => mockRepository.getUsers())
          .thenAnswer((_) async => Right(tUsers));

      // Act
      final result = await usecase();

      // Assert
      expect(result, Right(tUsers));
      verify(() => mockRepository.getUsers()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      final tFailure = ServerFailure(message: 'Server error');
      when(() => mockRepository.getUsers())
          .thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, Left(tFailure));
      verify(() => mockRepository.getUsers()).called(1);
    });
  });
}
```

### BLoC Test

```dart
// filepath: test/unit/presentation/blocs/user_bloc_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUsersUseCase extends Mock implements GetUsersUseCase {}

void main() {
  late UserBloc bloc;
  late MockGetUsersUseCase mockGetUsersUseCase;

  setUp(() {
    mockGetUsersUseCase = MockGetUsersUseCase();
    bloc = UserBloc(getUsersUseCase: mockGetUsersUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  group('LoadUsers', () {
    final tUsers = [
      UserEntity(id: '1', name: 'User 1', email: 'user1@test.com'),
    ];

    blocTest<UserBloc, UserState>(
      'should emit [UserLoading, UsersLoaded] when successful',
      build: () {
        when(() => mockGetUsersUseCase())
            .thenAnswer((_) async => Right(tUsers));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadUsers()),
      expect: () => [
        const UserLoading(),
        UsersLoaded(users: tUsers),
      ],
      verify: (_) {
        verify(() => mockGetUsersUseCase()).called(1);
      },
    );

    blocTest<UserBloc, UserState>(
      'should emit [UserLoading, UserError] when fails',
      build: () {
        when(() => mockGetUsersUseCase())
            .thenAnswer((_) async => Left(ServerFailure(message: 'Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadUsers()),
      expect: () => [
        const UserLoading(),
        const UserError(message: 'Error'),
      ],
    );
  });
}
```

### Widget Test

```dart
// filepath: test/widget/presentation/screens/user_list_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockUserBloc extends MockBloc<UserEvent, UserState>
    implements UserBloc {}

void main() {
  late MockUserBloc mockBloc;

  setUp(() {
    mockBloc = MockUserBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<UserBloc>.value(
        value: mockBloc,
        child: const UserListScreen(),
      ),
    );
  }

  testWidgets('should show loading indicator when state is UserLoading',
      (tester) async {
    // Arrange
    when(() => mockBloc.state).thenReturn(const UserLoading());

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show users when state is UsersLoaded',
      (tester) async {
    // Arrange
    final tUsers = [
      UserEntity(id: '1', name: 'User 1', email: 'user1@test.com'),
    ];
    when(() => mockBloc.state).thenReturn(UsersLoaded(users: tUsers));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.text('User 1'), findsOneWidget);
  });
}
```

---

## ✅ Code Review Checklist

### Arquitetura
- [ ] Camadas claramente separadas (presentation → domain → data → infrastructure)
- [ ] Dependências fluem de fora para dentro
- [ ] Domain não depende de nada (apenas Dart puro)
- [ ] Data implementa interfaces do Domain
- [ ] Presentation usa apenas Domain

### Nomenclatura
- [ ] Arquivos em snake_case
- [ ] Classes em PascalCase
- [ ] Variáveis/funções em camelCase
- [ ] Privados com underscore prefix
- [ ] DTOs terminam com `.dto.dart`
- [ ] Entities terminam com `.entity.dart`
- [ ] UseCases terminam com `.usecase.dart`

### BLoC
- [ ] Estados são sealed classes com final classes
- [ ] Estados são imutáveis
- [ ]// filepath: AI_ARCHITECTURE_GUIDE.md

# 🏗️ Flutter Clean Architecture + BLoC - AI Implementation Guide

> **Guia completo de arquitetura para assistentes de IA**  
> Padrão: Clean Architecture + BLoC Pattern + GetIt DI  
> Plataforma: Flutter (Mobile & Web)  
> Versão: 2.0.0

---

## 📋 Índice

1. [Visão Geral da Arquitetura](#visão-geral-da-arquitetura)
2. [Estrutura de Camadas](#estrutura-de-camadas)
3. [Padrões Obrigatórios](#padrões-obrigatórios)
4. [Fluxo de Implementação](#fluxo-de-implementação)
5. [Stack Tecnológica](#stack-tecnológica)
6. [Guia de Implementação por Feature](#guia-de-implementação-por-feature)
7. [Dependency Injection com GetIt](#dependency-injection-com-getit)
8. [State Management com BLoC](#state-management-com-bloc)
9. [Network Layer](#network-layer)
10. [Error Handling](#error-handling)
11. [Storage & Persistence](#storage--persistence)
12. [Testing Strategy](#testing-strategy)
13. [Code Review Checklist](#code-review-checklist)
14. [Anti-Patterns (O que NÃO fazer)](#anti-patterns-o-que-não-fazer)

---

## 🎯 Visão Geral da Arquitetura

### Princípios Fundamentais

```
CLEAN ARCHITECTURE + SOLID + DRY + KISS

┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                   │
│  (UI, Widgets, Screens, BLoCs, States, Events)         │
│  - Depende apenas do DOMAIN                             │
│  - Não conhece DATA ou INFRASTRUCTURE                   │
└─────────────────────────────────────────────────────────┘
                          ↓ ↑
┌─────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                       │
│  (Entities, UseCases, Repository Interfaces)           │
│  - Núcleo da aplicação                                  │
│  - ZERO dependências externas                           │
│  - Define contratos (interfaces)                        │
└─────────────────────────────────────────────────────────┘
                          ↓ ↑
┌─────────────────────────────────────────────────────────┐
│                       DATA LAYER                        │
│  (DTOs, Mappers, Repository Implementations)           │
│  - Implementa contratos do DOMAIN                       │
│  - Depende de DOMAIN e INFRASTRUCTURE                   │
└─────────────────────────────────────────────────────────┘
                          ↓ ↑
┌─────────────────────────────────────────────────────────┐
│                  INFRASTRUCTURE LAYER                   │
│  (Network, Database, External APIs, DI, Services)      │
│  - Detalhes de implementação                            │
│  - Frameworks, Packages, APIs                           │
└─────────────────────────────────────────────────────────┘
```

### Regras de Dependência

1. ✅ **Dependências fluem de FORA para DENTRO**
2. ✅ **Domain NÃO depende de nada** (exceto Dart puro)
3. ✅ **Data implementa interfaces do Domain**
4. ✅ **Presentation usa apenas Domain**
5. ✅ **Infrastructure é isolada**

---

## 📁 Estrutura de Camadas

### Estrutura Completa de Pastas

```
lib/
├── config/                           # Configurações globais
│   ├── theme/                       # Temas, cores, tipografia
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_theme.dart
│   ├── constants/                   # Constantes da aplicação
│   │   └── app_constants.dart
│   └── environment/                 # Variáveis de ambiente
│       └── .env.example
│
├── core/                             # Núcleo compartilhado
│   ├── common/                      # Utilitários compartilhados
│   │   ├── extensions/             # Extensions do Dart
│   │   ├── validators/             # Validações comuns
│   │   └── utils/                  # Helpers genéricos
│   │
│   ├── components/                  # Widgets reutilizáveis
│   │   ├── buttons/
│   │   ├── inputs/
│   │   ├── dialogs/
│   │   ├── loaders/
│   │   └── cards/
│   │
│   ├── di/                          # Dependency Injection
│   │   ├── dependencies_imports.dart
│   │   ├── dependency_injection.blocs.dart
│   │   ├── dependency_injection.repositories.dart
│   │   ├── dependency_injection.usecases.dart
│   │   ├── dependency_injection.services.dart
│   │   └── inject_dependencies.dart
│   │
│   ├── error/                       # Error Handling
│   │   ├── failures.dart           # Failure classes
│   │   └── exceptions.dart         # Exception classes
│   │
│   ├── network/                     # Network Layer
│   │   ├── network_client.dart     # Interface
│   │   ├── network_client_impl.dart
│   │   ├── network_request.dart
│   │   ├── network_response.dart
│   │   ├── network_interceptor.dart
│   │   └── api_endpoints.dart
│   │
│   ├── storage/                     # Local Storage
│   │   ├── local_storage.dart      # Interface
│   │   ├── secure_storage_impl.dart
│   │   └── shared_prefs_impl.dart
│   │
│   ├── router/                      # Navigation
│   │   ├── app_router.dart
│   │   └── route_guards.dart
│   │
│   └── types/                       # Type Definitions
│       └── typedefs.dart
│
├── features/                         # Features (módulos)
│   └── [feature_name]/              # Exemplo: auth, user, product
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── remote/
│       │   │   │   └── [feature]_remote_datasource.dart
│       │   │   └── local/
│       │   │       └── [feature]_local_datasource.dart
│       │   ├── dtos/
│       │   │   ├── [entity].dto.dart
│       │   │   └── [entity].dto.g.dart
│       │   ├── mappers/
│       │   │   └── [entity].mapper.dart
│       │   └── repositories/
│       │       └── [repository]_impl.dart
│       │
│       ├── domain/
│       │   ├── entities/
│       │   │   └── [entity].entity.dart
│       │   ├── repositories/
│       │   │   └── [repository].dart
│       │   └── usecases/
│       │       └── [action]_[entity].usecase.dart
│       │
│       └── presentation/
│           ├── blocs/
│           │   └── [feature]/
│           │       ├── [feature].bloc.dart
│           │       ├── [feature].event.dart
│           │       └── [feature].state.dart
│           ├── screens/
│           │   └── [screen_name]_screen.dart
│           ├── widgets/
│           │   └── [widget_name].dart
│           └── components/
│               └── [component_name].dart
│
├── main.dart                         # Entry point
└── app.dart                          # MaterialApp wrapper

.env                                  # Environment variables (git ignored)
.env.example                          # Template de .env
pubspec.yaml                          # Dependencies
```

---

## 📐 Padrões Obrigatórios

### 1. Nomenclatura de Arquivos

```dart
// ✅ CORRETO - snake_case
user.entity.dart
login_user.usecase.dart
user.dto.dart
user.dto.g.dart              // Generated file
auth.bloc.dart
auth.event.dart
auth.state.dart
login_screen.dart
user_card_widget.dart
auth_repository.dart         // Interface
auth_repository_impl.dart    // Implementation
```

### 2. Nomenclatura de Classes

```dart
// ✅ Classes: PascalCase
class UserEntity { }
class LoginUserUseCase { }
class AuthBloc extends Bloc { }
class LoginScreen extends StatelessWidget { }

// ✅ Variáveis e Funções: camelCase
final userName = 'João';
void loginUser() { }
Future<void> fetchData() async { }

// ✅ Constantes: SCREAMING_SNAKE_CASE ou lowerCamelCase
const String API_BASE_URL = 'https://api.example.com';
const primaryColor = Color(0xFF6200EE);

// ✅ Privados: underscore prefix
class AuthBloc {
  final LoginUserUseCase _loginUserUseCase;
  void _handleLogin() { }
}

// ✅ Interfaces: Sem prefixo/sufixo especial
abstract class UserRepository { }      // Interface
class UserRepositoryImpl implements UserRepository { } // Implementation
```

### 3. Imports Organization

```dart
// ✅ ORDEM CORRETA
// 1. Dart SDK
import 'dart:async';
import 'dart:convert';

// 2. Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Packages (terceiros)
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dartz/dartz.dart';

// 4. Projeto (absolute imports)
import 'package:my_app/core/error/failures.dart';
import 'package:my_app/features/auth/domain/entities/user.entity.dart';

// 5. Relativos (evitar quando possível)
import '../utils/validators.dart';
```

---

## 🔄 Fluxo de Implementação

### Ordem OBRIGATÓRIA para implementar uma Feature

```
1. DOMAIN LAYER (Business Logic)
   ├─ 1.1. Criar Entity
   ├─ 1.2. Criar Repository Interface
   └─ 1.3. Criar UseCase

2. DATA LAYER (Data Management)
   ├─ 2.1. Criar DTO
   ├─ 2.2. Criar Mapper (DTO ↔ Entity)
   ├─ 2.3. Criar DataSource (se necessário)
   └─ 2.4. Implementar Repository

3. PRESENTATION LAYER (UI)
   ├─ 3.1. Criar States (sealed classes)
   ├─ 3.2. Criar Events
   ├─ 3.3. Criar BLoC
   ├─ 3.4. Criar Screen/Widgets
   └─ 3.5. Integrar com BLoC

4. DEPENDENCY INJECTION
   ├─ 4.1. Registrar DataSources
   ├─ 4.2. Registrar Repositories
   ├─ 4.3. Registrar UseCases
   └─ 4.4. Registrar BLoCs

5. TESTING (em paralelo)
   ├─ 5.1. Unit Tests (UseCases)
   ├─ 5.2. Widget Tests (UI)
   └─ 5.3. Integration Tests
```

---

## 🔧 Stack Tecnológica

### Dependencies Obrigatórias

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management (OBRIGATÓRIO)
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5              # Para comparação de estados

  # Dependency Injection (OBRIGATÓRIO)
  get_it: ^7.6.4

  # Functional Programming (OBRIGATÓRIO)
  dartz: ^0.10.1                 # Either, Option, etc

  # Networking (OBRIGATÓRIO)
  dio: ^5.4.0
  
  # JSON Serialization (OBRIGATÓRIO)
  json_annotation: ^4.8.1

  # Environment Variables (RECOMENDADO)
  flutter_dotenv: ^5.1.0

  # Storage (escolher conforme necessidade)
  shared_preferences: ^2.2.2     # Dados simples
  flutter_secure_storage: ^9.0.0 # Dados sensíveis
  hive: ^2.2.3                   # NoSQL local
  sqflite: ^2.3.0                # SQL local

  # UI Utilities (RECOMENDADO)
  responsive_framework: ^1.1.1   # Responsive design
  intl: ^0.18.1                  # Internationalization
  cached_network_image: ^3.3.0   # Image caching

dev_dependencies:
  # Code Generation (OBRIGATÓRIO)
  build_runner: ^2.4.6
  json_serializable: ^6.7.1

  # Testing (OBRIGATÓRIO)
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.5
  mocktail: ^1.0.1

  # Linting (OBRIGATÓRIO)
  flutter_lints: ^3.0.0
```

---

## 🎨 Guia de Implementação por Feature

### Template Completo de Feature

#### 1. DOMAIN LAYER

##### 1.1. Entity (domain/entities/)

```dart
// filepath: lib/features/[feature]/domain/entities/user.entity.dart

import 'package:equatable/equatable.dart';

/// Representa um usuário do sistema
/// 
/// [Entity] é um objeto de domínio puro, sem dependências de frameworks
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, email, createdAt];

  @override
  bool get stringify => true;
}
```

##### 1.2. Repository Interface (domain/repositories/)

```dart
// filepath: lib/features/[feature]/domain/repositories/user.repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/types/typedefs.dart';
import '../entities/user.entity.dart';

/// Interface do repositório de usuários
/// 
/// Define os contratos que a camada de DATA deve implementar
abstract class UserRepository {
  /// Busca todos os usuários
  ResultFuture<List<UserEntity>> getUsers();

  /// Busca um usuário por ID
  ResultFuture<UserEntity> getUserById(String id);

  /// Cria um novo usuário
  ResultFuture<UserEntity> createUser({
    required String name,
    required String email,
  });

  /// Atualiza um usuário existente
  ResultFuture<UserEntity> updateUser({
    required String id,
    String? name,
    String? email,
  });

  /// Deleta um usuário
  ResultVoid deleteUser(String id);
}
```

##### 1.3. UseCase (domain/usecases/)

```dart
// filepath: lib/features/[feature]/domain/usecases/get_users.usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/types/typedefs.dart';
import '../entities/user.entity.dart';
import '../repositories/user.repository.dart';

/// Caso de uso: Buscar todos os usuários
/// 
/// Regra de negócio: Cada UseCase deve ter UMA única responsabilidade
class GetUsersUseCase {
  final UserRepository _repository;

  const GetUsersUseCase({required UserRepository repository})
      : _repository = repository;

  /// Executa o caso de uso
  /// 
  /// Retorna Either<Failure, List<UserEntity>>:
  /// - Left: Em caso de erro
  /// - Right: Em caso de sucesso
  ResultFuture<List<UserEntity>> call() async {
    return await _repository.getUsers();
  }
}
```

```dart
// filepath: lib/features/[feature]/domain/usecases/create_user.usecase.dart

import '../../../../core/types/typedefs.dart';
import '../entities/user.entity.dart';
import '../repositories/user.repository.dart';

/// Caso de uso: Criar novo usuário
class CreateUserUseCase {
  final UserRepository _repository;

  const CreateUserUseCase({required UserRepository repository})
      : _repository = repository;

  /// Executa a criação de usuário com validações de negócio
  ResultFuture<UserEntity> call({
    required String name,
    required String email,
  }) async {
    // Validações de negócio aqui (se houver)
    if (name.trim().isEmpty) {
      return Left(ValidationFailure(message: 'Nome não pode ser vazio'));
    }

    if (!_isValidEmail(email)) {
      return Left(ValidationFailure(message: 'Email inválido'));
    }

    return await _repository.createUser(name: name, email: email);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
```

#### 2. DATA LAYER

##### 2.1. DTO (data/dtos/)

```dart
// filepath: lib/features/[feature]/data/dtos/user.dto.dart

import 'package:json_annotation/json_annotation.dart';

part 'user.dto.g.dart';

/// Data Transfer Object para User
/// 
/// Responsável por serialização/deserialização JSON
@JsonSerializable()
class UserDto {
  final String id;
  final String name;
  final String email;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  const UserDto({
    required this.id,
    required this.name,
    required this.email,
    this.createdAt,
  });

  /// Deserialização: JSON → DTO
  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  /// Serialização: DTO → JSON
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}
```

##### 2.2. Mapper (data/mappers/)

```dart
// filepath: lib/features/[feature]/data/mappers/user.mapper.dart

import '../../domain/entities/user.entity.dart';
import '../dtos/user.dto.dart';

/// Extensão para conversão DTO ↔ Entity
extension UserMapper on UserDto {
  /// Converte DTO para Entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
    );
  }
}

extension UserEntityMapper on UserEntity {
  /// Converte Entity para DTO
  UserDto toDto() {
    return UserDto(
      id: id,
      name: name,
      email: email,
      createdAt: createdAt?.toIso8601String(),
    );
  }
}
```

##### 2.3. DataSource (data/datasources/)

```dart
// filepath: lib/features/[feature]/data/datasources/remote/user_remote_datasource.dart

import '../../../../../core/network/network_client.dart';
import '../../../../../core/network/network_request.dart';
import '../../../../../core/error/exceptions.dart';
import '../../dtos/user.dto.dart';

/// Interface do DataSource Remoto
abstract class UserRemoteDataSource {
  Future<List<UserDto>> getUsers();
  Future<UserDto> getUserById(String id);
  Future<UserDto> createUser({required String name, required String email});
  Future<UserDto> updateUser({required String id, String? name, String? email});
  Future<void> deleteUser(String id);
}

/// Implementação do DataSource usando NetworkClient
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final NetworkClient _client;

  const UserRemoteDataSourceImpl({required NetworkClient client})
      : _client = client;

  @override
  Future<List<UserDto>> getUsers() async {
    try {
      final request = NetworkGetRequest(
        endpoint: '/users',
      );

      final response = await _client.get(request: request);

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Erro ao buscar usuários',
          statusCode: response.statusCode,
        );
      }

      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => UserDto.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserDto> createUser({
    required String name,
    required String email,
  }) async {
    try {
      final request = NetworkPostRequest(
        endpoint: '/users',
        body: {'name': name, 'email': email},
      );

      final response = await _client.post(request: request);

      if (response.statusCode != 201) {
        throw ServerException(
          message: 'Erro ao criar usuário',
          statusCode: response.statusCode,
        );
      }

      return UserDto.fromJson(response.data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // ... outros métodos
}
```

##### 2.4. Repository Implementation (data/repositories/)

```dart
// filepath: lib/features/[feature]/data/repositories/user.repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/types/typedefs.dart';
import '../../domain/entities/user.entity.dart';
import '../../domain/repositories/user.repository.dart';
import '../datasources/remote/user_remote_datasource.dart';
import '../mappers/user.mapper.dart';

/// Implementação do repositório de usuários
/// 
/// Coordena DataSources e converte exceções em Failures
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  const UserRepositoryImpl({
    required UserRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  ResultFuture<List<UserEntity>> getUsers() async {
    try {
      final dtos = await _remoteDataSource.getUsers();
      final entities = dtos.map((dto) => dto.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<UserEntity> createUser({
    required String name,
    required String email,
  }) async {
    try {
      final dto = await _remoteDataSource.createUser(
        name: name,
        email: email,
      );
      return Right(dto.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  // ... outros métodos
}
```

#### 3. PRESENTATION LAYER

##### 3.1. States (presentation/blocs/[feature]/)

```dart
// filepath: lib/features/[feature]/presentation/blocs/user/user.state.dart

part of 'user.bloc.dart';

/// Estados do UserBloc
/// 
/// Usar sealed class para pattern matching exaustivo
sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
final class UserInitial extends UserState {
  const UserInitial();
}

/// Carregando dados
final class UserLoading extends UserState {
  const UserLoading();
}

/// Usuários carregados com sucesso
final class UsersLoaded extends UserState {
  final List<UserEntity> users;

  const UsersLoaded({required this.users});

  @override
  List<Object?> get props => [users];
}

/// Usuário criado com sucesso
final class UserCreated extends UserState {
  final UserEntity user;

  const UserCreated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Erro ao processar
final class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object?> get props => [message];
}
```

##### 3.2. Events (presentation/blocs/[feature]/)

```dart
// filepath: lib/features/[feature]/presentation/blocs/user/user.event.dart

part of 'user.bloc.dart';

/// Eventos do UserBloc
sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

/// Evento: Carregar lista de usuários
final class LoadUsers extends UserEvent {
  const LoadUsers();
}

/// Evento: Criar novo usuário
final class CreateUser extends UserEvent {
  final String name;
  final String email;

  const CreateUser({
    required this.name,
    required this.email,
  });

  @override
  List<Object?> get props => [name, email];
}

/// Evento: Atualizar usuário
final class UpdateUser extends UserEvent {
  final String id;
  final String? name;
  final String? email;

  const UpdateUser({
    required this.id,
    this.name,
    this.email,
  });

  @override
  List<Object?> get props => [id, name, email];
}

/// Evento: Deletar usuário
final class DeleteUser extends UserEvent {
  final String id;

  const DeleteUser({required this.id});

  @override
  List<Object?> get props => [id];
}
```

##### 3.3. BLoC (presentation/blocs/[feature]/)

```dart
// filepath: lib/features/[feature]/presentation/blocs/user/user.bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.entity.dart';
import '../../../domain/usecases/get_users.usecase.dart';
import '../../../domain/usecases/create_user.usecase.dart';
import '../../../domain/usecases/update_user.usecase.dart';
import '../../../domain/usecases/delete_user.usecase.dart';

part 'user.event.dart';
part 'user.state.dart';

/// BLoC para gerenciamento de usuários
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersUseCase _getUsersUseCase;
  final CreateUserUseCase _createUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final DeleteUserUseCase _deleteUserUseCase;

  UserBloc({
    required GetUsersUseCase getUsersUseCase,
    required CreateUserUseCase createUserUseCase,
    required UpdateUserUseCase updateUserUseCase,
    required DeleteUserUseCase deleteUserUseCase,
  })  : _getUsersUseCase = getUsersUseCase,
        _createUserUseCase = createUserUseCase,
        _updateUserUseCase = updateUserUseCase,
        _deleteUserUseCase = deleteUserUseCase,
        super(const UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<CreateUser>(_onCreateUser);
    on<UpdateUser>(_onUpdateUser);
    on<DeleteUser>(_onDeleteUser);
  }

  Future<void> _onLoadUsers(
    LoadUsers event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());

    final result = await _getUsersUseCase();

    result.fold(
      (failure) => emit(UserError(message: failure.message)),
      (users) => emit(UsersLoaded(users: users)),
    );
  }

  Future<void> _onCreateUser(
    CreateUser event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());

    final result = await _createUserUseCase(
      name: event.name,
      email: event.email,
    );

    result.fold(
      (failure) => emit(UserError(message: failure.message)),
      (user) => emit(UserCreated(user: user)),
    );
  }

  Future<void> _onUpdateUser(
    UpdateUser event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());

    final result = await _updateUserUseCase(
      id: event.id,
      name: event.name,
      email: event.email,
    );

    result.fold(
      (failure) => emit(UserError(message: failure.message)),
      (user) => emit(UserCreated(user: user)),
    );
  }

  Future<void> _onDeleteUser(
    DeleteUser event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());

    final result = await _deleteUserUseCase(event.id);

    result.fold(
      (failure) => emit(UserError(message: failure.message)),
      (_) {
        // Recarregar lista após deletar
        add(const LoadUsers());
      },
    );
  }
}
```

##### 3.4. Screen (presentation/screens/)

```dart
// filepath: lib/features/[feature]/presentation/screens/user_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependencies_imports.dart';
import '../blocs/user/user.bloc.dart';
import '../widgets/user_list_item.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Usar .value se for Singleton no GetIt
      create: (_) => getIt<UserBloc>()..add(const LoadUsers()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Usuários'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Navigate to create user screen
              },
            ),
          ],
        ),
        body: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            // Reações a mudanças de estado
            if (state is UserError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }

            if (state is UserCreated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Usuário criado com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
              // Recarregar lista
              context.read<UserBloc>().add(const LoadUsers());
            }
          },
          builder: (context, state) {
            // Renderização baseada no estado
            if (state is UserLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is UsersLoaded) {
              if (state.users.isEmpty) {
                return const Center(
                  child: Text('Nenhum usuário encontrado'),
                );
              }

              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return UserListItem(
                    user: user,
                    onTap: () {
                      // Navigate to detail
                    },
                    onDelete: () {
                      context.read<UserBloc>().add(DeleteUser(id: user.id));
                    },
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
```

#### 4. DEPENDENCY INJECTION

```dart
// filepath: lib/core/di/dependency_injection.datasources.dart

part of 'dependencies_imports.dart';

Future<void> registerDataSources() async {
  // Remote DataSources
  if (!getIt.isRegistered<UserRemoteDataSource>()) {
    getIt.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(client: getIt()),
    );
  }

  // Local DataSources (se houver)
  // getIt.registerLazySingleton<UserLocalDataSource>(...)
}
```

```dart
// filepath: lib/core/di/dependency_injection.repositories.dart

part of 'dependencies_imports.dart';

Future<void> registerRepositories() async {
  if (!getIt.isRegistered<UserRepository>()) {
    getIt.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(
        remoteDataSource: getIt(),
      ),
    );
  }
}
```

```dart
// filepath: lib/core/di/dependency_injection.usecases.dart

part of 'dependencies_imports.dart';

Future<void> registerUseCases() async {
  // User UseCases
  if (!getIt.isRegistered<GetUsersUseCase>()) {
    getIt.registerLazySingleton<GetUsersUseCase>(
      () => GetUsersUseCase(repository: getIt()),
    );
  }

  if (!getIt.isRegistered<CreateUserUseCase>()) {
    getIt.registerLazySingleton<CreateUserUseCase>(
      () => CreateUserUseCase(repository: getIt()),
    );
  }

  if (!getIt.isRegistered<UpdateUserUseCase>()) {
    getIt.registerLazySingleton<UpdateUserUseCase>(
      () => UpdateUserUseCase(repository: getIt()),
    );
  }

  if (!getIt.isRegistered<DeleteUserUseCase>()) {
    getIt.registerLazySingleton<DeleteUserUseCase>(
      () => DeleteUserUseCase(repository: getIt()),
    );
  }
}
```

```dart
// filepath: lib/core/di/dependency_injection.blocs.dart

part of 'dependencies_imports.dart';

Future<void> registerBlocs() async {
  // Registrar como Singleton se quiser manter estado global
  if (!getIt.isRegistered<UserBloc>()) {
    getIt.registerSingleton<UserBloc>(
      UserBloc(
        getUsersUseCase: getIt(),
        createUserUseCase: getIt(),
        updateUserUseCase: getIt(),
        deleteUserUseCase: getIt(),
      ),
    );
  }

  // OU registrar como Factory se quiser instância nova por tela
  // getIt.registerFactory<UserBloc>(() => UserBloc(...));
}
```

---

## 🎯 Dependency Injection com GetIt

### Setup Inicial

```dart
// filepath: lib/core/di/dependencies_imports.dart

library dependencies;

import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Import all DI files
part 'dependency_injection.network.dart';
part 'dependency_injection.storage.dart';
part 'dependency_injection.datasources.dart';
part 'dependency_injection.repositories.dart';
part 'dependency_injection.usecases.dart';
part 'dependency_injection.blocs.dart';
part 'inject_dependencies.dart';

final getIt = GetIt.instance;
```

```dart
// filepath: lib/core/di/inject_dependencies.dart

part of 'dependencies_imports.dart';

bool _isInitialized = false;

/// Inicializa todas as dependências
/// 
/// Ordem importa! Respeitar hierarquia de dependências
Future<void> injectDependencies() async {
  if (_isInitialized) {
    print('⚠️ Dependências já foram injetadas');
    return;
  }

  print('⏳ Injetando dependências...');

  // 1. Carregar environment variables
  await dotenv.load(fileName: '.env');

  // 2. Registrar camada de infraestrutura
  await registerNetwork();
  await registerStorage();

  // 3. Registrar DataSources
  await registerDataSources();

  // 4. Registrar Repositories
  await registerRepositories();

  // 5. Registrar UseCases
  await registerUseCases();

  // 6. Registrar BLoCs
  await registerBlocs();

  _isInitialized = true;
  print('✅ Dependências injetadas com sucesso!');
}

/// Reseta todas as dependências (útil para testes)
Future<void> resetDependencies() async {
  await getIt.reset();
  _isInitialized = false;
}
```

### Tipos de Registro

```dart
// 1. SINGLETON - Uma única instância (lazy)
getIt.registerSingleton<AuthBloc>(AuthBloc());

// 2. LAZY SINGLETON - Criado apenas quando usado pela primeira vez
getIt.registerLazySingleton<NetworkClient>(() => NetworkClientImpl());

// 3. FACTORY - Nova instância a cada chamada
getIt.registerFactory<UserBloc>(() => UserBloc());

// 4. SINGLETON ASSÍNCRONO
getIt.registerSingletonAsync<SharedPreferences>(
  () => SharedPreferences.getInstance(),
);
await getIt.isReady<SharedPreferences>();
```

### Como usar no código

```dart
// ❌ ERRADO - Não instanciar diretamente
final bloc = UserBloc(getUsersUseCase: GetUsersUseCase());

// ✅ CORRETO - Usar GetIt
final bloc = getIt<UserBloc>();

// ✅ Em BlocProvider
BlocProvider.value(
  value: getIt<UserBloc>(),
  child: MyScreen(),
);

// ✅ Em qualquer lugar
final repository = getIt<UserRepository>();
```

---

## 🔄 State Management com BLoC

### Regras Fundamentais

1. ✅ **Estados devem ser imutáveis** (`sealed class` + `final class`)
2. ✅ **Eventos descrevem INTENÇÕES**, não implementações
3. ✅ **BLoC não deve conhecer widgets/UI**
4. ✅ **Um BLoC por feature/tela complexa**
5. ✅ **Use Equatable para comparação**

### Pattern Matching com Sealed Classes (Dart 3.0+)

```dart
// ✅ Estados com sealed class
sealed class AuthState {}

final class AuthInitial extends AuthState {}
final class AuthLoading extends AuthState {}
final class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}
final class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

// ✅ Pattern matching na UI
Widget build(BuildContext context) {
  return BlocBuilder<AuthBloc, AuthState>(
    builder: (context, state) {
      return switch (state) {
        AuthInitial() => const WelcomeScreen(),
        AuthLoading() => const LoadingIndicator(),
        AuthAuthenticated(:final user) => HomeScreen(user: user),
        AuthError(:final message) => ErrorScreen(message: message),
      };
    },
  );
}
```

### BlocBuilder vs BlocListener vs BlocConsumer

```dart
// 1. BlocBuilder - Para RENDERIZAR UI baseado no estado
BlocBuilder<UserBloc, UserState>(
  builder: (context, state) {
    if (state is UserLoading) return CircularProgressIndicator();
    if (state is UsersLoaded) return UserList(state.users);
    return SizedBox.shrink();
  },
);

// 2. BlocListener - Para SIDE EFFECTS (navegação, snackbar, etc)
BlocListener<UserBloc, UserState>(
  listener: (context, state) {
    if (state is UserError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
    if (state is UserCreated) {
      Navigator.of(context).pop();
    }
  },
  child: MyWidget(),
);

// 3. BlocConsumer - Combina Builder + Listener
BlocConsumer<UserBloc, UserState>(
  listener: (context, state) {
    // Side effects
  },
  builder: (context, state) {
    // UI rendering
  },
);
```

### Disparar Eventos

```dart
// ✅ CORRETO - Via context.read
context.read<UserBloc>().add(LoadUsers());

// ✅ CORRETO - Via BlocProvider.of
BlocProvider.of<UserBloc>(context).add(LoadUsers());

// ❌ EVITAR - Via context.watch (pode causar rebuilds desnecessários)
context.watch<UserBloc>().add(LoadUsers());
```

---

## 🌐 Network Layer

### NetworkClient Interface

```dart
// filepath: lib/core/network/network_client.dart

import 'network_request.dart';
import 'network_response.dart';

/// Interface para cliente HTTP
abstract class NetworkClient {
  Future<NetworkResponse> get({required NetworkGetRequest request});
  Future<NetworkResponse> post({required NetworkPostRequest request});
  Future<NetworkResponse> put({required NetworkPutRequest request});
  Future<NetworkResponse> delete({required NetworkDeleteRequest request});
  Future<NetworkResponse> patch({required NetworkPatchRequest request});
}
```

### NetworkClient Implementation com Dio

```dart
// filepath: lib/core/network/network_client_impl.dart

import 'package:dio/dio.dart';
import '../error/exceptions.dart';
import 'network_client.dart';
import 'network_request.dart';
import 'network_response.dart';

class NetworkClientImpl implements NetworkClient {
  final Dio _dio;

  NetworkClientImpl({required Dio dio}) : _dio = dio;

  @override
  Future<NetworkResponse> get({required NetworkGetRequest request}) async {
    try {
      final response = await _dio.get(
        request.endpoint,
        queryParameters: request.queryParameters,
        options: Options(headers: request.headers),
      );

      return NetworkResponse(
        data: response.data,
        statusCode: response.statusCode ?? 0,
        headers: response.headers.map,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  @override
  Future<NetworkResponse> post({required NetworkPostRequest request}) async {
    try {
      final response = await _dio.post(
        request.endpoint,
        data: request.body,
        queryParameters: request.queryParameters,
        options: Options(headers: request.headers),
      );

      return NetworkResponse(
        data: response.data,
        statusCode: response.statusCode ?? 0,
        headers: response.headers.map,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  // ... outros métodos

  NetworkException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: 'Timeout: Verifique sua conexão',
          statusCode: 408,
        );

      case DioExceptionType.badResponse:
        return ServerException(
          message: error.response?.data['message'] ?? 'Erro no servidor',
          statusCode: error.response?.statusCode ?? 500,
        );

      case DioExceptionType.cancel:
        return NetworkException(message: 'Requisição cancelada');

      default:
        return NetworkException(
          message: 'Erro de rede: ${error.message}',
        );
    }
  }
}
```

### API Endpoints Centralizados

```dart
// filepath: lib/core/network/api_endpoints.dart

class ApiEndpoints {
  // Base URLs
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com',
  );

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';

  // Users
  static const String users = '/users';
  static String userById(String id) => '/users/$id';

  // Products
  static const String products = '/products';
  static String productById(String id) => '/products/$id';

  // Construir URL completa
  static String buildUrl(String endpoint) => '$baseUrl$endpoint';
}
```

### Interceptors

```dart
// filepath: lib/core/network/auth_interceptor.dart

import 'package:dio/dio.dart';
import '../storage/local_storage.dart';

class AuthInterceptor extends Interceptor {
  final LocalStorage _storage;

  AuthInterceptor({required LocalStorage storage}) : _storage = storage;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getToken();
    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token expirado - tentar refresh
      final newToken = await _refreshToken();
      
      if (newToken != null) {
        // Retry request com novo token
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        final response = await Dio().fetch(err.requestOptions);
        return handler.resolve(response);
      }
    }

    super.onError(err, handler);
  }

  Future<String?> _refreshToken() async {
    // Implementar lógica de refresh token
    return null;
  }
}
```

---

## ⚠️ Error Handling

### Hierarquia de Failures

```dart
// filepath: lib/core/error/failures.dart

import 'package:equatable/equatable.dart';

/// Classe base para Failures (erros de negócio)
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Erro de servidor (API retornou erro)
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required String message,
    this.statusCode,
  }) : super(message: message);

  @override
  List<Object?> get props => [message, statusCode];
}

/// Erro de rede (sem conexão, timeout, etc)
class NetworkFailure extends Failure {
  const NetworkFailure({required String message}) : super(message: message);
}

/// Erro de validação (dados inválidos)
class ValidationFailure extends Failure {
  const ValidationFailure({required String message}) : super(message: message);
}

/// Erro de cache/storage local
class CacheFailure extends Failure {
  const CacheFailure({required String message}) : super(message: message);
}

/// Erro desconhecido
class UnknownFailure extends Failure {
  const UnknownFailure({required String message}) : super(message: message);
}
```

### Hierarquia de Exceptions

```dart
// filepath: lib/core/error/exceptions.dart

/// Classe base para Exceptions (erros técnicos)
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => message;
}

/// Erro no servidor
class ServerException extends AppException {
  const ServerException({
    required String message,
    int? statusCode,
  }) : super(message: message, statusCode: statusCode);
}

/// Erro de rede
class NetworkException extends AppException {
  const NetworkException({
    required String message,
    int? statusCode,
  }) : super(message: message, statusCode: statusCode);
}

/// Erro de cache
class CacheException extends AppException {
  const CacheException({required String message})
      : super(message: message);
}

/// Erro de validação
class ValidationException extends AppException {
  const ValidationException({required String message})
      : super(message: message);
}
```

### Conversão Exception → Failure

```dart
// No Repository
@override
ResultFuture<User> getUser(String id) async {
  try {
    final dto = await _remoteDataSource.getUser(id);
    return Right(dto.toEntity());
  } on ServerException catch (e) {
    return Left(ServerFailure(
      message: e.message,
      statusCode: e.statusCode,
    ));
  } on NetworkException catch (e) {
    return Left(NetworkFailure(message: e.message));
  } on CacheException catch (e) {
    return Left(CacheFailure(message: e.message));
  } catch (e) {
    return Left(UnknownFailure(message: e.toString()));
  }
}
```

---

## 💾 Storage & Persistence

### LocalStorage Interface

```dart
// filepath: lib/core/storage/local_storage.dart

/// Interface para armazenamento local
abstract class LocalStorage {
  // String
  Future<void> saveString(String key, String value);
  Future<String?> getString(String key);

  // Int
  Future<void> saveInt(String key, int value);
  Future<int?> getInt(String key);

  // Bool
  Future<void> saveBool(String key, bool value);
  Future<bool?> getBool(String key);

  // Delete
  Future<void> delete(String key);
  Future<void> clear();

  // Contains
  Future<bool> containsKey(String key);
}
```

### SharedPreferences Implementation

```dart
// filepath: lib/core/storage/shared_prefs_impl.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'local_storage.dart';

class SharedPrefsImpl implements LocalStorage {
  final SharedPreferences _prefs;

  const SharedPrefsImpl({required SharedPreferences prefs}) : _prefs = prefs;

  @override
  Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<void> saveInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    return _prefs.getInt(key);
  }

  @override
  Future<void> saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    return _prefs.getBool(key);
  }

  @override
  Future<void> delete(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    return _prefs.containsKey(key);
  }
}
```

### SecureStorage Implementation

```dart
// filepath: lib/core/storage/secure_storage_impl.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageImpl {
  final FlutterSecureStorage _storage;

  const SecureStorageImpl({required FlutterSecureStorage storage})
      : _storage = storage;

  Future<void> save(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }

  Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }
}
```

---

## 🧪 Testing Strategy

### Estrutura de Testes

```
test/
├── unit/
│   ├── domain/
│   │   └── usecases/
│   ├── data/
│   │   ├── datasources/
│   │   ├── repositories/
│   │   └── mappers/
│   └── presentation/
│       └── blocs/
├── widget/
│   └── presentation/
│       ├── screens/
│       └── widgets/
└── integration/
    └── features/
```

### Unit Test - UseCase

```dart
// filepath: test/unit/domain/usecases/get_users_usecase_test.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late GetUsersUseCase usecase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    usecase = GetUsersUseCase(repository: mockRepository);
  });

  group('GetUsersUseCase', () {
    final tUsers = [
      UserEntity(id: '1', name: 'User 1', email: 'user1@test.com'),
      UserEntity(id: '2', name: 'User 2', email: 'user2@test.com'),
    ];

    test('should get users from repository', () async {
      // Arrange
      when(() => mockRepository.getUsers())
          .thenAnswer((_) async => Right(tUsers));

      // Act
      final result = await usecase();

      // Assert
      expect(result, Right(tUsers));
      verify(() => mockRepository.getUsers()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      final tFailure = ServerFailure(message: 'Server error');
      when(() => mockRepository.getUsers())
          .thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, Left(tFailure));
      verify(() => mockRepository.getUsers()).called(1);
    });
  });
}
```

### BLoC Test

```dart
// filepath: test/unit/presentation/blocs/user_bloc_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUsersUseCase extends Mock implements GetUsersUseCase {}

void main() {
  late UserBloc bloc;
  late MockGetUsersUseCase mockGetUsersUseCase;

  setUp(() {
    mockGetUsersUseCase = MockGetUsersUseCase();
    bloc = UserBloc(getUsersUseCase: mockGetUsersUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  group('LoadUsers', () {
    final tUsers = [
      UserEntity(id: '1', name: 'User 1', email: 'user1@test.com'),
    ];

    blocTest<UserBloc, UserState>(
      'should emit [UserLoading, UsersLoaded] when successful',
      build: () {
        when(() => mockGetUsersUseCase())
            .thenAnswer((_) async => Right(tUsers));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadUsers()),
      expect: () => [
        const UserLoading(),
        UsersLoaded(users: tUsers),
      ],
      verify: (_) {
        verify(() => mockGetUsersUseCase()).called(1);
      },
    );

    blocTest<UserBloc, UserState>(
      'should emit [UserLoading, UserError] when fails',
      build: () {
        when(() => mockGetUsersUseCase())
            .thenAnswer((_) async => Left(ServerFailure(message: 'Error')));
        return bl…