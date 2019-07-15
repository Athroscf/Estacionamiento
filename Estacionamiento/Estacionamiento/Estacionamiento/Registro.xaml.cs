using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
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
    /// Lógica de interacción para Registro.xaml
    /// </summary>
    public partial class Registro : Page
    {
        SqlConnection sqlconnection;

        public Registro()
        {
            InitializeComponent();
        }

        private void BtnListar_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                string connectionString = @"Server=(local)\sqlexpress; database = Estacionamiento; Integrated Security=true;";
                sqlconnection = new SqlConnection(connectionString);
                SqlCommand query = new SqlCommand(@"SELECT Vehiculo.placa, 
	                                                   TipoVehiculo.tipo, 
                                                       PagoVehiculo.fechaHoraEntrada,
	                                                   PagoVehiculo.fechaHoraSalida, 
	                                                   PagoVehiculo.total
                                                       FROM Estacionamiento.Vehiculo INNER JOIN Estacionamiento.PagoVehiculo
                                                       ON Estacionamiento.PagoVehiculo.vehiculo = Estacionamiento.Vehiculo.id INNER JOIN Estacionamiento.TipoVehiculo
                                                       ON Estacionamiento.TipoVehiculo.id = Estacionamiento.Vehiculo.tipoVehiculo", sqlconnection);
                sqlconnection.Open();
                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(query);
                DataTable registros = new DataTable();
                sqlDataAdapter.Fill(registros);
                dgRegistros.ItemsSource = registros.DefaultView;
                query.Dispose();
                sqlconnection.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
        }
    }
}
