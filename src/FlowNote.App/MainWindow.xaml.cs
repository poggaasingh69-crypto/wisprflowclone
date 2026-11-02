using System.Windows;

namespace FlowNote.App;

public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();
        Closing += (_, e) =>
        {
            if (System.Windows.Application.Current is App app && !app.IsExiting)
            {
                e.Cancel = true;
                Hide();
            }
        };
    }
}