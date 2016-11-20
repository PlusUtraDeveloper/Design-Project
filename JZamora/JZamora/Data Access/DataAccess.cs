using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JZamora.Data_Access
{
    class DataAccess
    {
        SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["JZamoraFinalDb"].ToString());
        
        private DataSet DataSetHelper(SqlCommand cmd)
        {

            DataSet ds = null;
            SqlDataAdapter objDataAdapter = new SqlDataAdapter();
            try
            {
                objDataAdapter.SelectCommand = cmd;
                ds = new DataSet();
                objDataAdapter.Fill(ds);
            }
            catch
            {

            }
            finally
            {
                if (cmd != null)
                    cmd.Dispose();
                if (objDataAdapter != null)
                    objDataAdapter.Dispose();
            }
            return ds;
        }
        private DataTable DataTableHelper(SqlCommand cmd)
        {

            DataTable dt = null;
            SqlDataAdapter objDataAdapter = new SqlDataAdapter();
            try
            {
                objDataAdapter.SelectCommand = cmd;
                dt = new DataTable();
                objDataAdapter.Fill(dt);
            }
            catch
            {

            }
            finally
            {
                if (cmd != null)
                    cmd.Dispose();
                if (objDataAdapter != null)
                    objDataAdapter.Dispose();
            }
            return dt;
        }


        public DataTable GetAllStudents()
        {
            SqlCommand cmd = new SqlCommand("GetAllStudents", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            return DataTableHelper(cmd);
        }

        public DataTable GetTOR(int studentId)
        {
            SqlCommand cmd = new SqlCommand("GetStudentTOR", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@sid", SqlDbType.Int).Value = studentId;
            return DataTableHelper(cmd);
        }
        public DataTable deleteStudent(int s)
        {
            SqlCommand cmd = new SqlCommand("DeleteRecord", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@sid", SqlDbType.Int).Value = s;
            return DataTableHelper(cmd);
          
            
        }
        public DataSet SaveStudentTOR(string last, string first, string mi, string TOR_Front, string TOR_Back)
        {
            //Read Image Bytes into a byte array
            byte[] imageData_TOR_Front = ReadFile(TOR_Front);
            byte[] imageData_TOR_Back = ReadFile(TOR_Back);

            SqlCommand cmd = new SqlCommand("SaveStudentTOR", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@lname", SqlDbType.VarChar, 50).Value = last;
            cmd.Parameters.Add("@fname", SqlDbType.VarChar, 50).Value = first;
            cmd.Parameters.Add("@mi", SqlDbType.VarChar, 5).Value = mi;

            cmd.Parameters.Add(new SqlParameter("@TOR_Front", imageData_TOR_Front));
            cmd.Parameters.Add(new SqlParameter("@TOR_Back", imageData_TOR_Back));
            
            return DataSetHelper(cmd);
        }

       
        public DataSet SaveTOR_Front(string ImagePath, int id)
        {

            //Read Image Bytes into a byte array
            byte[] imageData = ReadFile(ImagePath);

            SqlCommand cmd = new SqlCommand("saveGradePhoto", conn);    // 1.  create a command object identifying the stored procedure            
            cmd.CommandType = CommandType.StoredProcedure;  // 2. set the command object so it knows to execute a stored procedure
            cmd.Parameters.Add("@Student_ID", SqlDbType.Int).Value = id;    // 3. add parameter to command, which will be passed to the stored procedure
            cmd.Parameters.Add(new SqlParameter("@Student_Photo", imageData));

            return DataSetHelper(cmd);

        }
        public DataSet SaveTOR_Back(string ImagePath, int id)
        {

            //Read Image Bytes into a byte array
            byte[] imageData = ReadFile(ImagePath);

            SqlCommand cmd = new SqlCommand("saveGradePhoto", conn);    // 1.  create a command object identifying the stored procedure            
            cmd.CommandType = CommandType.StoredProcedure;  // 2. set the command object so it knows to execute a stored procedure
            cmd.Parameters.Add("@Student_ID", SqlDbType.Int).Value = id;    // 3. add parameter to command, which will be passed to the stored procedure
            cmd.Parameters.Add(new SqlParameter("@Student_Photo", imageData));

            return DataSetHelper(cmd);

        }

        byte[] ReadFile(string sPath)
        {
            //Initialize byte array with a null value initially.
            byte[] data = null;

            //Use FileInfo object to get file size.
            FileInfo fInfo = new FileInfo(sPath);
            long numBytes = fInfo.Length;

            //Open FileStream to read file
            FileStream fStream = new FileStream(sPath, FileMode.Open, FileAccess.Read);

            //Use BinaryReader to read file stream into byte array.
            BinaryReader br = new BinaryReader(fStream);

            //When you use BinaryReader, you need to supply number of bytes 
            //to read from file.
            //In this case we want to read entire file. 
            //So supplying total number of bytes.
            data = br.ReadBytes((int)numBytes);

            return data;
        }


    }
}
