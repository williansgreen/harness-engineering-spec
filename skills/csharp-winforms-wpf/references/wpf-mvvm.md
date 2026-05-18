# WPF MVVM

Use this reference for WPF apps and XAML-heavy UI work.

## Default Pattern

WPF defaults to MVVM:

- View: XAML layout, bindings, visual states, resources.
- ViewModel: state, commands, input validation, navigation state.
- Model/Domain: business entities and rules.
- Application services: workflows, device calls, data saving.

## View Rules

- Fixed layout belongs in XAML.
- Dynamic content should use `Binding`, `ItemsControl`, `DataTemplate`, `Style`, and `ResourceDictionary`.
- Avoid `Canvas` for normal app layout.
- Avoid large runtime UI construction in code-behind.
- Code-behind should be limited to view-only concerns that are awkward in XAML.

## ViewModel Rules

ViewModel may:

- Expose observable state and commands.
- Validate input.
- Coordinate application services.
- Publish UI state such as busy, error, warning, progress, selected item.

ViewModel must not:

- Directly access controls.
- Directly access vendor SDKs.
- Open file dialogs without an abstraction.
- Block the UI thread.

## Recommended Files

```text
UI.Wpf/
  Views/MainWindow.xaml
  Views/MainWindow.xaml.cs
  ViewModels/MainViewModel.cs
  Controls/
  Resources/
  DesignTime/
  Composition/WpfCompositionRoot.cs
```

## Acceptance

- Main window opens without real devices.
- Bindings are coherent.
- Design-time data does not touch serial ports, databases, or network services.
- Long-running operations are asynchronous and cancellable.

