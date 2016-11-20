using JZamora.Data_Access;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Forms;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace JZamora
{
    /// <summary>
    /// Interaction logic for BackPage.xaml
    /// </summary>
    public partial class BackPage : Page
    {
        DataAccess db = new DataAccess();
        string fName;
        string lName;
        string mInit;
        
        public BackPage()
        {
            InitializeComponent();
        }
        public BackPage(string f, string l, string m)
        {
            fName = f;
            lName = l;
            mInit = m;
            InitializeComponent();
        }

        private void mitm_print_Click(object sender, RoutedEventArgs e)
        {
           


        }

      
        private void mitm_front_Click(object sender, RoutedEventArgs e)
        {
            NavigationService n = NavigationService.GetNavigationService(this);
            n.Navigate(new Uri("Pages/FrontPage.xaml", UriKind.RelativeOrAbsolute));
        }

        private void mitm_upload_Click(object sender, RoutedEventArgs e)
        {
            NavigationService n = NavigationService.GetNavigationService(this);
            n.Navigate(new Uri("Pages/UploadTranscriptPage.xaml", UriKind.RelativeOrAbsolute));
        }

        private void mitm_open_Click(object sender, RoutedEventArgs e)
        {
            NavigationService n = NavigationService.GetNavigationService(this);
            n.Navigate(new Uri("Pages/SearchPage.xaml", UriKind.RelativeOrAbsolute));
        }

        private void mitm_save_Click_1(object sender, RoutedEventArgs e)
        {

        }

        private void Finilize_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                DialogResult result = System.Windows.Forms.MessageBox.Show("Please make sure that all fields are answered and that the page is scrolled upward. Record may be cut if the page is not scrolled at the top most. Do you want to continue?",
              "Warning!", MessageBoxButtons.YesNo);

                if (result == DialogResult.Yes)
                {
                    //creates back transcript photo
                    RenderTargetBitmap renderTargetBitmap =
         new RenderTargetBitmap(860, 1950, 96, 96, PixelFormats.Pbgra32);
                    renderTargetBitmap.Render(TOR_Printable_Back);
                    PngBitmapEncoder pngImage = new PngBitmapEncoder();
                    pngImage.Frames.Add(BitmapFrame.Create(renderTargetBitmap));

                    using (Stream fileStream = File.Create("TOR_Back.jpg"))
                    {
                        pngImage.Save(fileStream);

                    }

                    //saves photo in the database 
                    db.SaveStudentTOR(lName, fName, mInit, "TOR_Front.jpg", "TOR_Back.jpg");
                    System.Windows.MessageBox.Show("Student's Transcript of Record has been save!");
                }
            }
            catch
            {
                System.Windows.MessageBox.Show("An unexpected Error has occur.", "Error!", MessageBoxButton.OK, MessageBoxImage.Asterisk);
            }
        }



        
    }
}
