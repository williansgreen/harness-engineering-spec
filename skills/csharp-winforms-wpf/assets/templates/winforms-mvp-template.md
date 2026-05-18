# WinForms MVP Template

```text
UI.WinForms/
  Views/IMainView.cs
  Forms/MainForm.cs
  Forms/MainForm.Designer.cs
  Presenters/MainPresenter.cs
  Composition/WinFormsCompositionRoot.cs
```

## View Contract

```csharp
public interface IMainView
{
    event EventHandler StartRequested;
    event EventHandler StopRequested;

    void SetBusy(bool busy);
    void ShowStatus(string message);
    void ShowError(string message);
}
```

## Presenter Contract

Presenter receives `IMainView` and application services. It must be testable with a fake view and fake services.

