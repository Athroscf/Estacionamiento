using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace Estacionamiento
{
    /// <summary>
    /// Lógica de interacción para MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void LvControlEntradaSalida_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            Main.NavigationService.Navigate(new EntradasSalidas());
        }

        private void LvRegistroDiario_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            Main.NavigationService.Navigate(new Registro());
        }

        private void LvSalirPrograma_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (MessageBox.Show("Close Application?", "Question", MessageBoxButton.YesNo, MessageBoxImage.Warning) == MessageBoxResult.Yes)
            {
                Application.Current.Shutdown();
            }
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {

        }

        private void LvControlEntradaSalida_Click(object sender, RoutedEventArgs e)
        {

        }

        private void LvRegistroDiario_Click(object sender, RoutedEventArgs e)
        {

        }

        private void LvSalirPrograma_Click(object sender, RoutedEventArgs e)
        {

        }
    }
}
