using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Printing;
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
using System.Windows.Forms;
using System.IO;
using JZamora.Data_Access;

namespace JZamora
{
    /// <summary>
    /// Interaction logic for FrontPage.xaml
    /// </summary>
    /// 
    public partial class FrontPage : Page
    {
        
        DataAccess db = new DataAccess();
        string fName;
        string lName;
        string mInit;
        public FrontPage()
        {
            InitializeComponent();
        }
        public FrontPage(string f, string l, string m)
        {
            fName = f;
            lName = l;
            mInit = m;
            InitializeComponent();
            tb_FullName.Text = lName + ", " + fName + " " + mInit; 
        }
        private void mitm_back_Click(object sender, RoutedEventArgs e)
        {
           
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

        private void TextBox_TextChanged(object sender, TextChangedEventArgs e)
        {

        }

        private void tb_FullName_TextChanged(object sender, TextChangedEventArgs e)
        {
           
        }

        private void mitm_save_Click_1(object sender, RoutedEventArgs e)
        {
            RenderTargetBitmap renderTargetBitmap =
   new RenderTargetBitmap(860, 1950, 96, 96, PixelFormats.Pbgra32);
            renderTargetBitmap.Render(TOR_Printable_Front);
            PngBitmapEncoder pngImage = new PngBitmapEncoder();
            pngImage.Frames.Add(BitmapFrame.Create(renderTargetBitmap));

            using (Stream fileStream = File.Create("TOR_Front.jpg"))
            {
                pngImage.Save(fileStream);

            }

            System.Windows.MessageBox.Show("Data has been saved!");
        }

        private void btn_next_Click(object sender, RoutedEventArgs e)
        {

        }

        private void Next_Click(object sender, RoutedEventArgs e)
        {
            RenderTargetBitmap renderTargetBitmap =
  new RenderTargetBitmap(860, 1950, 96, 96, PixelFormats.Pbgra32);
            renderTargetBitmap.Render(TOR_Printable_Front);
            PngBitmapEncoder pngImage = new PngBitmapEncoder();
            pngImage.Frames.Add(BitmapFrame.Create(renderTargetBitmap));

            using (Stream fileStream = File.Create("TOR_Front.jpg"))
            {
                pngImage.Save(fileStream);

            }

            DialogResult result = System.Windows.Forms.MessageBox.Show("Please make sure that all fields are answered and that the page is scrolled upward. Record may be cut if the page is not scrolled at the top most. Continuing will remove all data inserted on the fields. Do you want to continue?",
               "Warning!", MessageBoxButtons.YesNo);

            if (result == DialogResult.Yes)
            {
                NavigationService n = NavigationService.GetNavigationService(this);
                // n.Navigate(new Uri("Pages/BackPage.xaml", UriKind.RelativeOrAbsolute));
                n.Navigate(new BackPage(fName,lName,mInit));
            }
        }

        private void tb_FullName_Copy2_TextChanged(object sender, TextChangedEventArgs e)
        {

        }

       

     

      
    }
}
