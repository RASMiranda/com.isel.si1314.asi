using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.Data;
using System.Data.Common;
using System.Data.SqlClient;



namespace TesteMirror
{
    class Program
    {
        static void Main(string[] args)
        {

            string strConn = "Address=(local)\\instancia1;Database=DBMirror;Failover Partner=(local)\\instancia2;Integrated Security = true";
            
            SqlConnection cn = new SqlConnection(strConn);
            string strSQL = "Select TOP 1 @i = i from t";

            for (; ; )
            {
                try
                {
                    cn.Open();
                    SqlCommand cmd = new SqlCommand(strSQL, cn);
                    cmd.CommandType = CommandType.Text;
                    SqlParameter i = cmd.Parameters.Add("@i", SqlDbType.Int);
                    i.Direction = ParameterDirection.Output;
                    cmd.ExecuteNonQuery();
                    Console.WriteLine(i.Value.ToString());
                    cn.Close();
                }
                catch (SqlException e)
                {
                    
                    cn.Close(); 
                }
            }

   	
        }
    }
}
