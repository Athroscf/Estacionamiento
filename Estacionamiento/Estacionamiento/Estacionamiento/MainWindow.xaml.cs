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
// Namespaces para la conexion a la BD
using System.Data;
using System.Data.SqlClient;

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
            Main.Content = new EntradasSalidas();
        }

        private void LvRegistroDiario_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            Main.Content = new Registro();
        }

        // Metodo para registrar la entrada y salida de los vehiculos
        private void VehiculoEntradaSalida()
        {
            try
            {

            }
            catch (Exception)
            {

                throw;
            }
        }

    }
}
