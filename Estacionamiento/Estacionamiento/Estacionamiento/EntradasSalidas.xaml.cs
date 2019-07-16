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
using System.Windows.Threading;
// Namespaces para la conexion a la BD
using System.Data;
using System.Data.SqlClient;

namespace Estacionamiento
{
    /// <summary>
    /// Lógica de interacción para EntradasSalidas.xaml
    /// </summary>
    public partial class EntradasSalidas : Page
    {

        SqlConnection sqlConnection;
        public EntradasSalidas()
        {
            InitializeComponent();

            DispatcherTimer timer = new DispatcherTimer(new TimeSpan(0, 0, 1), DispatcherPriority.Normal, delegate
            {
                this.txtHoraIngresoSalida.Text = DateTime.Now.ToString("ddd, dd MMM yyy  HH:mm:ss");
            }, this.Dispatcher);

            string connectionString = @"Server = (local)\sqlexpress; Database = Estacionamiento; Integrated Security = true;";
            sqlConnection = new SqlConnection(connectionString);
        }

        private void BtnIngresarDatos_Click(object sender, RoutedEventArgs e)
        {
            if (txtHoraIngresoSalida.Text == String.Empty || cbTipoVehiculo.SelectedIndex == 0)
            {
                MessageBox.Show("Porfavor llenar todos los campos!");
            }
            else
            {
                try
                {
                    sqlConnection.Open();

                    string query = "spInsercionVehiculosEntradasSalidas";

                    SqlCommand sqlCommand = new SqlCommand(query, sqlConnection);

                    sqlCommand.CommandType = CommandType.StoredProcedure;

                    sqlCommand.CommandType = CommandType.StoredProcedure;

                    SqlParameter placa = new SqlParameter("@placa", SqlDbType.VarChar);
                    placa.Value = txtPlaca.Text;
                    SqlParameter tipo = new SqlParameter("@tipoVehiculo", SqlDbType.VarChar);
                    tipo.Value = cbTipoVehiculo.Text;

                    sqlCommand.Parameters.Add(placa);
                    sqlCommand.Parameters.Add(tipo);

                    sqlCommand.ExecuteNonQuery();

                    if (ValidacionEstado(txtPlaca.Text))
                        MessageBox.Show("Vehiculo con placa {1}{0}Total a pagar: {1}", Environment.NewLine );
                    else
                        MessageBox.Show("Ingresado");

                    txtPlaca.Text = String.Empty;
                    cbTipoVehiculo.SelectedIndex = 0;

                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.ToString());
                }
                finally
                {
                    sqlConnection.Close();
                }
            }
        }

        private bool ValidacionEstado(string placa)
        {
            sqlConnection.Open();

            string estado = @"SELECT estado FROM Estacionamiento.Vehiculo Where placa = @placa";

            SqlCommand sqlCommand = new SqlCommand(estado, sqlConnection);

            sqlCommand.CommandText = "SELECT treatment FROM appointment WHERE patientid = ";

            string value = Convert.ToString(sqlCommand.ExecuteScalar());

            if (value == "0")
            {
                return false;
            }
            else
            {
                return true;
            }
        }
    }
}
