# WPF MVVM Template

```text
UI.Wpf/
  Views/MainWindow.xaml
  Views/MainWindow.xaml.cs
  ViewModels/MainViewModel.cs
  Commands/
  Resources/
  DesignTime/
  Composition/WpfCompositionRoot.cs
```

## ViewModel Contract

```csharp
public sealed class MainViewModel
{
    public bool IsBusy { get; }
    public string StatusMessage { get; }
    public ICommand StartCommand { get; }
    public ICommand StopCommand { get; }
}
```

ViewModel coordinates application services and exposes UI state. It does not directly access controls or vendor SDKs.

