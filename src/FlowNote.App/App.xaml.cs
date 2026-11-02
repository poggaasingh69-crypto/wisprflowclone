using System.Drawing;
using System.Windows;
using Forms = System.Windows.Forms;

namespace FlowNote.App;

public partial class App : System.Windows.Application
{
    private Forms.NotifyIcon? _trayIcon;
    private Forms.ContextMenuStrip? _trayMenu;
    private Forms.ToolStripMenuItem? _showHideItem;

    internal bool IsExiting { get; private set; }

    protected override void OnStartup(StartupEventArgs e)
    {
        base.OnStartup(e);
        ShutdownMode = ShutdownMode.OnExplicitShutdown;

        var window = new MainWindow();
        MainWindow = window;

        _showHideItem = new Forms.ToolStripMenuItem("Hide pill", null, (_, _) => TogglePill());
        _trayMenu = new Forms.ContextMenuStrip();
        _trayMenu.Items.Add(_showHideItem);
        _trayMenu.Items.Add(new Forms.ToolStripSeparator());
        _trayMenu.Items.Add(new Forms.ToolStripMenuItem("Exit", null, (_, _) => ExitApplication()));

        _trayIcon = new Forms.NotifyIcon
        {
            ContextMenuStrip = _trayMenu,
            Icon = SystemIcons.Application,
            Text = "FlowNote",
            Visible = true
        };
        _trayIcon.DoubleClick += (_, _) => TogglePill();

        window.Show();
    }

    protected override void OnExit(ExitEventArgs e)
    {
        _trayIcon?.Dispose();
        _trayMenu?.Dispose();
        base.OnExit(e);
    }

    private void TogglePill()
    {
        if (MainWindow is not { } window || _showHideItem is not { } menuItem)
        {
            return;
        }

        if (window.IsVisible)
        {
            window.Hide();
        }
        else
        {
            window.Show();
        }

        menuItem.Text = window.IsVisible ? "Hide pill" : "Show pill";
    }

    private void ExitApplication()
    {
        IsExiting = true;
        Shutdown();
    }
}
