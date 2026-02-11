# POC: Migração para Super Editor

Esta branch (`feat/super-editor-poc`) demonstra a migração do AppFlowy Editor para o Super Editor.

## O que foi implementado

### 1. Dependências
- Adicionado `super_editor` via GitHub (branch `main`)
- Removido `appflowy_editor` do pubspec.yaml

### 2. Arquitetura

#### Converters
- **`document_converter_base.dart`**: Interface genérica com type parameter `<T>`
- **`super_editor_document_converter.dart`**: Implementação para Super Editor
  - Usa **Markdown** como formato de serialização
  - Converte entre Markdown ↔ MutableDocument
  - Suporta texto plano como fallback

#### Controllers
- **`rich_text_editor_controller_generic.dart`**: Controller genérico com `<T>`
  - Suporta qualquer tipo de EditorState
  - Auto-save com debounce
  - Listener de mudanças no documento

#### Widgets
- **`rich_text_editor_super.dart`**: Widget usando SuperEditor
  - Integração completa com Super Editor
  - Suporta configuração via `RichTextEditorConfig`
  - Estilização customizada baseada no ColorScheme
  
#### Integração
- **`card_description_editor_super.dart`**: Wrapper para Card

## Diferenças vs AppFlowy Editor

| Aspecto | AppFlowy Editor | Super Editor |
|---------|-----------------|--------------|
| **Formato de Persistência** | JSON proprietário | Markdown (builtin) |
| **Document Model** | `EditorState` → `Document` | `Editor` + `MutableDocument` + `MutableDocumentComposer` |
| **Change Tracking** | `transactionStream` | `document.addListener()` |
| **Serialização** | `Document.toJson()` | `serializeDocumentToMarkdown()` |
| **Componentes** | `BlockComponentBuilder` | `ComponentBuilder` |
| **Seleção** | `editorState.selection` | `editor.execute([ChangeSelectionRequest()])` |

## Próximos Passos

### Para testar a POC:

1. **Substituir o editor antigo**:
   ```dart
   // Antes
   import 'components/card_description_editor.dart';
   CardDescriptionEditor(...)
   
   // Depois
   import 'components/card_description_editor_super.dart';
   CardDescriptionEditorSuper(...)
   ```

2. **Migrar dados existentes** (se necessário):
   - Descrições salvas em JSON AppFlowy serão tratadas como Markdown
   - Texto plano funciona como fallback
   - Migração gradual é possível

### Features a adicionar:

- [ ] Toolbar customizada
- [ ] Suporte a Tasks (checkbox)
- [ ] Suporte a Images
- [ ] Blockquotes
- [ ] Undo/Redo (já builtin no Super Editor)
- [ ] Mobile gesture support
- [ ] Slash commands para markdown

## Arquivos Novos

```
kanew_flutter/lib/core/widgets/rich_text_editor/
├── converters/
│   ├── document_converter_base.dart              # NEW: Interface genérica
│   └── super_editor_document_converter.dart       # NEW: Converter para Super Editor
├── rich_text_editor_controller_generic.dart       # NEW: Controller genérico
└── rich_text_editor_super.dart                    # NEW: Widget com Super Editor

kanew_flutter/lib/features/board/presentation/components/
└── card_description_editor_super.dart             # NEW: Wrapper para Card
```

## Arquivos Antigos (mantidos para referência)

Estes arquivos ainda usam AppFlowy Editor e terão erros de compilação (esperado):

- `rich_text_editor.dart` (antigo)
- `rich_text_editor_controller.dart` (antigo)
- `converters/appflowy_document_converter.dart` (antigo)
- `converters/document_converter.dart` (antigo)
- `blocks/block_registry.dart` (antigo)
- `card_description_editor.dart` (antigo)

## Como funciona

### Fluxo de Dados

```
User Input → SuperEditor → MutableDocument → Document Listener
                                ↓
                            Controller._onContentChanged()
                                ↓
                        Debounce Timer (500ms)
                                ↓
                        Controller._save()
                                ↓
                    serializeDocumentToMarkdown()
                                ↓
                        onSave callback → Serverpod
```

### Exemplo de Markdown Gerado

```markdown
# Título do Card

Este é um parágrafo com **negrito** e *itálico*.

- Item de lista 1
- Item de lista 2

1. Item numerado
2. Outro item
```

## Vantagens do Super Editor

1. **Manutenção ativa**: 1.9k stars, ativamente mantido
2. **Markdown nativo**: Serialização builtin
3. **Melhor suporte mobile**: Gestos iOS/Android nativos
4. **Undo/Redo builtin**: Não precisa implementar
5. **Plugin system**: Extensível via plugins
6. **Melhor documentação**: Mais exemplos e demos

## Notas

- A POC usa serialização em **Markdown** em vez de JSON para simplicidade
- Compatibilidade com dados antigos é possível (text plano funciona)
- O controller é genérico para facilitar futuras mudanças
- Estilos do tema são aplicados automaticamente
