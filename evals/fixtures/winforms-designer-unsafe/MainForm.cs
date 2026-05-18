using System;
using System.Windows.Forms;

namespace InstrumentControl.UI.WinForms;

public partial class MainForm : Form
{
    private readonly VendorSpectrometer _device;

    public MainForm()
    {
        InitializeComponent();
        BuildRuntimeLayout();
        _device = new VendorSpectrometer("COM3");
        _device.Connect();
    }

    private void BuildRuntimeLayout()
    {
        var startButton = new Button { Text = "Start", Dock = DockStyle.Top };
        startButton.Click += (_, _) =>
        {
            var value = _device.ReadIntensity();
            MessageBox.Show($"Intensity: {value}");
        };

        Controls.Add(startButton);
    }
}

public sealed class VendorSpectrometer
{
    public VendorSpectrometer(string portName)
    {
        PortName = portName;
    }

    public string PortName { get; }

    public void Connect()
    {
    }

    public double ReadIntensity()
    {
        return 42.0;
    }
}

