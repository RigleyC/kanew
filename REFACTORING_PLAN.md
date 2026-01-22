# Plano de Refatoracao: State Management

**Data:** 2026-01-17  
**Objetivo:** Simplificar o gerenciamento de estado seguindo o padrao Flutter recomendado (View cria Controller, dispoe Controller).

---

## Sumario Executivo

### Situacao Atual (Refatorada)

```
┌─────────────────────────────────────────────────────────────────┐
│                        GetIt                                    │
│  Singletons:                                                    │
│  ├── Client                                                     │
│  ├── FlutterAuthSessionManager                                  │
│  └── AppConfig                                                  │
│                                                                 │
│  LazySingletons:                                                │
│  ├── AuthRepository                                             │
│  ├── WorkspaceRepository                                        │
│  ├── BoardRepository                                            │
│  ├── ListRepository                                             │
│  └── CardRepository                                             │
│                                                                 │
│  Factories:                                                     │
│  ├── AuthController                                             │
│  ├── WorkspaceController (global, mas Factory)                  │
│  ├── BoardsPageController                                       │
│  ├── BoardViewPageController                                    │
│  └── CardDetailPageController                                   │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                        Pages                                    │
│  Cada page:                                                     │
│  ├── initState: _controller = getIt<XController>()              │
│  ├── dispose: _controller.dispose()                             │
│  └── build: ListenableBuilder(listenable: _controller, ...)     │
└─────────────────────────────────────────────────────────────────┘
```

---

## Checklist Final

- [x] Fase 1.1: Remover chamadas de UI dos ViewModels
- [x] Fase 1.2: Criar modelo Result (opcional - pulado)
- [x] Fase 2.1: Renomear AuthViewModel para AuthController
- [x] Fase 2.2: Manter AuthController como Singleton
- [x] Fase 3.1: Renomear WorkspaceViewModel para WorkspaceController
- [x] Fase 3.2: Manter WorkspaceController como Singleton
- [x] Fase 4.1: Criar novos Controllers (BoardsPage, BoardViewPage, CardDetail)
- [x] Fase 4.2: Atualizar BoardsPage
- [x] Fase 4.3: Atualizar BoardViewPage
- [x] Fase 4.4: Atualizar CardDetailPage
- [x] Fase 4.5: Atualizar Router (remover BoardScope)
- [x] Fase 4.6: Deletar arquivos obsoletos
- [x] Fase 5.1: Atualizar main.dart
- [x] Fase 5.2: Atualizar injection.dart
- [x] Fase 5.3: Atualizar AGENTS.md

---

## Status Final

✅ **CONCLUÍDO**

A refatoração da arquitetura de gerenciamento de estado foi concluída com sucesso. O padrão `BoardScope` foi removido e substituído por controladores instanciados diretamente pelas páginas (Factory pattern), resultando em um código mais limpo, previsível e alinhado com as boas práticas modernas do Flutter.
