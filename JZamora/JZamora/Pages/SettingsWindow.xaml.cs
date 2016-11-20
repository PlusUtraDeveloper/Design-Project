using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Ports;
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
using System.Windows.Shapes;

namespace JZamora.Pages
{
    /// <summary>
    /// Interaction logic for SettingsWindow.xaml
    /// </summary>
    public partial class SettingsWindow : Window
    {
        public SettingsWindow()
        {
            InitializeComponent();
            foreach (string s in SerialPort.GetPortNames())
            {
                cbComPort.Items.Add(s);
            }  
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            FileStream fs1 = new FileStream("CommPortSettings.mj", FileMode.OpenOrCreate, FileAccess.Write);
            StreamWriter writer = new StreamWriter(fs1);
            writer.Write(cbComPort.SelectedItem);
            writer.Close();
            this.Hide();
        }
    }
}
