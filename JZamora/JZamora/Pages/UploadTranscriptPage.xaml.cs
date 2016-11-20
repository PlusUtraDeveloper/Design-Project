using Microsoft.Win32;
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
using JZamora.Data_Access;

namespace JZamora
{
    /// <summary>
    /// Interaction logic for UploadTranscriptPage.xaml
    /// </summary>
    public partial class UploadTranscriptPage : Page
    {
        DataAccess db = new DataAccess();
       
        public UploadTranscriptPage()
        {
            InitializeComponent();
        }

        private void mitm_new_Click(object sender, RoutedEventArgs e)
        {
            NavigationService n = NavigationService.GetNavigationService(this);
            n.Navigate(new Uri("Pages/CreateNewPage.xaml", UriKind.RelativeOrAbsolute));
        }

        private void tb_browse_front_Click(object sender, RoutedEventArgs e)
        {
            OpenFileDialog openFileDialog = new OpenFileDialog();
            openFileDialog.Filter = "JPG Files (*.jpg)|*.jpg|PEG Files (*.jpeg)|*.jpeg";
            if (openFileDialog.ShowDialog() == true)
                tb_front.Text = openFileDialog.FileName;
        }

        private void btn_browse_back_Click(object sender, RoutedEventArgs e)
        {
            OpenFileDialog openFileDialog = new OpenFileDialog();
            openFileDialog.Filter = "JPG Files (*.jpg)|*.jpg|PEG Files (*.jpeg)|*.jpeg";
            if (openFileDialog.ShowDialog() == true)
                tb_front.Text = openFileDialog.FileName;
        }

        private void mitm_open_Click(object sender, RoutedEventArgs e)
        {
            NavigationService n = NavigationService.GetNavigationService(this);
            n.Navigate(new Uri("Pages/SearchPage.xaml", UriKind.RelativeOrAbsolute));
        }

        private void btn_upload_Click(object sender, RoutedEventArgs e)
        {
            try
            { 
                db.SaveStudentTOR(tb_last_name.Text, tb_first_name.Text, tb_mi.Text,tb_front.Text,tb_back.Text);
                MessageBox.Show("Student's Transcript of Record has been save!");
            }
            catch
            {
                MessageBox.Show("An unexpected Error has occur.","Error!",MessageBoxButton.OK,MessageBoxImage.Asterisk);
            }
        }



       
    }
}
