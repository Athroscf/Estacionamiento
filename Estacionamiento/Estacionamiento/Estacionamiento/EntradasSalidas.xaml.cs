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

namespace Estacionamiento
{
    /// <summary>
    /// Lógica de interacción para EntradasSalidas.xaml
    /// </summary>
    public partial class EntradasSalidas : Page
    {
        public EntradasSalidas()
        {
            InitializeComponent();

            DispatcherTimer timer = new DispatcherTimer(new TimeSpan(0, 0, 1), DispatcherPriority.Normal, delegate
            {
                this.txtHoraIngresoSalida.Text = DateTime.Now.ToString("ddd, dd MMM yyy  HH:mm:ss");
            }, this.Dispatcher);
        }
    }
}
