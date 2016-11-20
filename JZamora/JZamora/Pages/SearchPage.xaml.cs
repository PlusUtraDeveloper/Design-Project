using System;
using System.Collections.Generic;
using System.Data;
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
using System.IO;
using System.Drawing.Printing;
using System.Drawing;
using System.IO.Ports;

namespace JZamora.Pages
{
    /// <summary>
    /// Interaction logic for SearchPage.xaml
    /// </summary>
    public partial class SearchPage : Page
    {
        DataAccess db = new DataAccess();
        List<int> studId = new List<int>();
        int studentId;
        SerialPort PrinterSerial;
        SerialPort DeleteSerial;
        string code;
        public SearchPage()
        {
            InitializeComponent();
            LoadStudents();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            DeleteSerial = new SerialPort();
            DeleteSerial.Close();
            DeleteSerial.PortName = ReadCommPortSetting();
            DeleteSerial.BaudRate = 9600;
            try
            {
                DeleteSerial.Open();
                DeleteSerial.DataReceived += new SerialDataReceivedEventHandler(DeleteSerial_DataReceived);
                MessageBox.Show("Please tap the card.");
            }
            catch
            {
                SettingsWindow comport = new SettingsWindow();
                comport.Show();
            }         
        }

        private void deleteRecord()
        {
            db.deleteStudent(studentId);

            MessageBox.Show("Record has been deleted!");
            NavigationService n = NavigationService.GetNavigationService(this);
            n.Navigate(new SearchPage());
        }
        private void DeleteSerial_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            code = DeleteSerial.ReadLine();
            code = code.Trim('\r');
            code = code.Trim(' ');
            code = code.Remove(code.Length - 1);

            if (code.Equals("760027777056") || code.Equals("760027777056"))
            {
                this.Dispatcher.Invoke((Action)(() => { deleteRecord(); }));
            }
            else
            {
                MessageBox.Show("Unauthorized Access Detected. Aborting Delete.");
            }
            DeleteSerial.DiscardInBuffer();
            DeleteSerial.Close();

        }

        private void mitm_print_Click(object sender, RoutedEventArgs e)
        {
            PrinterSerial = new SerialPort();
            PrinterSerial.Close();
            PrinterSerial.PortName = ReadCommPortSetting();
            PrinterSerial.BaudRate = 9600;
            try 
            { 
                PrinterSerial.Open();
                PrinterSerial.DataReceived += new SerialDataReceivedEventHandler(PrinterSerial_DataReceived);
                MessageBox.Show("Please tap the card.");
            }
            catch 
            {
                SettingsWindow comport = new SettingsWindow();
                comport.Show();
            }         
        }
       

        private string ReadCommPortSetting()
        {
            string commPort;
            FileStream fs2 = new FileStream("CommPortSettings.mj", FileMode.OpenOrCreate, FileAccess.Read);
            StreamReader reader = new StreamReader(fs2);
            commPort = reader.ReadToEnd();
            reader.Close();
            return commPort;
        }
        private void PrinterSerial_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            code = PrinterSerial.ReadLine();
            code = code.Trim('\r');
            code = code.Trim(' ');
            code = code.Remove(code.Length - 1);

            if (code.Equals("760027777056") || code.Equals("760027777056"))
            {
                this.Dispatcher.Invoke((Action)(() =>{print();}));
                MessageBox.Show("NOW PRINTING!!!");
            }
            else
            {
                MessageBox.Show("Unauthorized Access Detected. Aborting Printing.");
            }
            PrinterSerial.DiscardInBuffer();
            PrinterSerial.Close();

        }

        private void print()
        {
            PrintDocument pd = new PrintDocument();
            pd.PrintPage += PrintFrontPage;
            pd.Print();

            pd = new PrintDocument();
            pd.PrintPage += PrintBackPage;
            pd.Print();
        }

        private void PrintFrontPage(object o, PrintPageEventArgs e)
        {
            DataTable dt = db.GetTOR(studId[cb_student_list.SelectedIndex]);

            byte[] blob = (byte[])dt.Rows[0]["TOR_Front"];
            MemoryStream stream = new MemoryStream();
            stream.Write(blob, 0, blob.Length);
            stream.Position = 0;

            System.Drawing.Image img = System.Drawing.Image.FromStream(stream);
            BitmapImage bi = new BitmapImage();
            bi.BeginInit();

            MemoryStream ms = new MemoryStream();
            img.Save(ms, System.Drawing.Imaging.ImageFormat.Bmp);
            ms.Seek(0, SeekOrigin.Begin);
            bi.StreamSource = ms;
            bi.EndInit();
            e.Graphics.DrawImage(img, e.MarginBounds);
        }


        private void PrintBackPage(object o, PrintPageEventArgs e)
        {
            DataTable dt = db.GetTOR(studId[cb_student_list.SelectedIndex]);

            byte[] blob = (byte[])dt.Rows[0]["TOR_Back"];
            MemoryStream stream = new MemoryStream();
            stream.Write(blob, 0, blob.Length);
            stream.Position = 0;

            System.Drawing.Image img = System.Drawing.Image.FromStream(stream);
            BitmapImage bi = new BitmapImage();
            bi.BeginInit();

            MemoryStream ms = new MemoryStream();
            img.Save(ms, System.Drawing.Imaging.ImageFormat.Bmp);
            ms.Seek(0, SeekOrigin.Begin);
            bi.StreamSource = ms;
            bi.EndInit();
            e.Graphics.DrawImage(img, e.MarginBounds);
        }

        private void mitm_upload_Click(object sender, RoutedEventArgs e)
        {
            NavigationService n = NavigationService.GetNavigationService(this);
            n.Navigate(new Uri("Pages/UploadTranscriptPage.xaml", UriKind.RelativeOrAbsolute));
        }

        private void mitm_new_Click(object sender, RoutedEventArgs e)
        {
            NavigationService n = NavigationService.GetNavigationService(this);
            n.Navigate(new Uri("Pages/CreateNewPage.xaml", UriKind.RelativeOrAbsolute));
        }

        private void cb_student_list_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            DataTable dt = db.GetTOR(studId[cb_student_list.SelectedIndex]);
            studentId = studId[cb_student_list.SelectedIndex];

            byte[] blob = (byte[])dt.Rows[0]["TOR_Front"];
            MemoryStream stream = new MemoryStream();
            stream.Write(blob, 0, blob.Length);
            stream.Position = 0;

            System.Drawing.Image img = System.Drawing.Image.FromStream(stream);
            BitmapImage bi = new BitmapImage();
            bi.BeginInit();

            MemoryStream ms = new MemoryStream();
            img.Save(ms, System.Drawing.Imaging.ImageFormat.Bmp);
            ms.Seek(0, SeekOrigin.Begin);
            bi.StreamSource = ms;
            bi.EndInit();
            img_front_page.Source = bi;

            blob = (byte[])dt.Rows[0]["TOR_Back"];
            stream = new MemoryStream();
            stream.Write(blob, 0, blob.Length);
            stream.Position = 0;

            img = System.Drawing.Image.FromStream(stream);
            bi = new BitmapImage();
            bi.BeginInit();

            ms = new MemoryStream();
            img.Save(ms, System.Drawing.Imaging.ImageFormat.Bmp);
            ms.Seek(0, SeekOrigin.Begin);
            bi.StreamSource = ms;
            bi.EndInit();
            img_back_page.Source = bi;


        }

        private void LoadStudents()
        {
            DataTable dt = db.GetAllStudents();
            //int box = Convert.ToInt32(dt.Rows[0]["SID"].ToString());
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                studId.Add(Convert.ToInt32(dt.Rows[i]["SID"].ToString()));
                string StudentName = dt.Rows[i]["Last_Name"].ToString() + ", " +
                    dt.Rows[i]["First_Name"].ToString() + " " +
                    dt.Rows[i]["Middle_Initial"].ToString();
                cb_student_list.Items.Add(StudentName);
            }
        }
    }
}
