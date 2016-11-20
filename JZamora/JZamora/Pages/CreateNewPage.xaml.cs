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

namespace JZamora.Pages
{
    /// <summary>
    /// Interaction logic for CreateNewPage.xaml
    /// </summary>
    public partial class CreateNewPage : Page
    {
        public CreateNewPage()
        {
            InitializeComponent();
        }

        private void btn_browse_back_Click(object sender, RoutedEventArgs e)
        {

        }

        private void btn_upload_Click(object sender, RoutedEventArgs e)
        {

        }

        private void btn_next_Click(object sender, RoutedEventArgs e)
        {

            NavigationService n = NavigationService.GetNavigationService(this);
            // n.Navigate(new Uri("Pages/BackPage.xaml", UriKind.RelativeOrAbsolute));
            n.Navigate(new FrontPage(tb_first_name.Text,tb_last_name.Text,tb_mi.Text));
        }

        private void mitm_new_Click(object sender, RoutedEventArgs e)
        {
            NavigationService n = NavigationService.GetNavigationService(this);
            n.Navigate(new Uri("Pages/CreateNewPage.xaml", UriKind.RelativeOrAbsolute));
        }

        private void mitm_open_Click(object sender, RoutedEventArgs e)
        {
            NavigationService n = NavigationService.GetNavigationService(this);
            n.Navigate(new Uri("Pages/SearchPage.xaml", UriKind.RelativeOrAbsolute));
        }
    }
}
