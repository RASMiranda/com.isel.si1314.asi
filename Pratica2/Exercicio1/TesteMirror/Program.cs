using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.Data;
using System.Data.Common;
using System.Data.SqlClient;

using System.Configuration;

namespace TesteMirror
{
    class Program
    {
        static void Main(string[] args)
        {
            ConnectionStringSettings conn = ConfigurationManager.ConnectionStrings["TesteMirror.Properties.Settings.Inst1FailOver"];
            String strConn = conn.ConnectionString;
            Console.WriteLine("ConnectionString: " + strConn);
            SqlConnection cn = new SqlConnection(strConn);
            string strSQL = "SELECT @@servername; SELECT [dbname], [dtime] FROM [dbo].[t];";
            Console.WriteLine("SQL command issued:\r\n{0:s}", strSQL);
            Console.WriteLine("Press ENTER.");
            Console.ReadLine();

            cn.Open();
            SqlCommand cmd = new SqlCommand(strSQL, cn);
            cmd.CommandType = CommandType.Text;

            #region SqlParameters
            /*
            //string strSQL = "SELECT @srvname = @@servername; SELECT @dbname = [dbname], @dbtime = [dtime] FROM [dbo].[t];";
            SqlParameter srvname, dbname, dbtime;

            srvname = cmd.Parameters.Add("@srvname", SqlDbType.VarChar);
            srvname.Direction = ParameterDirection.Output;

            dbname = cmd.Parameters.Add("@dbname", SqlDbType.VarChar);
            dbname.Direction = ParameterDirection.Output;

            dbtime = cmd.Parameters.Add("@dbtime", SqlDbType.DateTime);
            dbtime.Direction = ParameterDirection.Output;
            */
            #endregion

            string lastServerName = string.Empty;
            while(true)
            {
                Console.WriteLine();
                try
                {
                    SqlDataReader dr = cmd.ExecuteReader();

                    #region read first SELECT
                    if (dr.HasRows)
                    {
                        while (dr.Read()) // while é redundante: só há uma linha...
                        {
                            string serverName = dr.GetString(0);
                            
                            if (lastServerName != string.Empty && !serverName.Equals(lastServerName))
                            {
                                Console.WriteLine("Ocorreu failover!!");
                                System.Threading.Thread.Sleep(3000);
                            }
                            lastServerName = serverName;
                            
                            Console.WriteLine("ConnectionDB: {0:s} ConnectionDataSrc: {1:s} Conteudo obtido as {2:s}:\r\nRunnning queries @{3:s}",
                                                cn.Database, cn.DataSource, DateTime.Now, serverName);  //DateTime.Now.ToString("HH:mm.ss")
                        }
                    }
                    #endregion read first SELECT

                    dr.NextResult();

                    #region read second SELECT
                    if (dr.HasRows)
                    {
                        while (dr.Read())
                        {
                            string dbName = dr.GetString(dr.GetOrdinal("dbname"));
                            DateTime dbTime = dr.GetDateTime(dr.GetOrdinal("dtime"));
                            Console.WriteLine("Instance {0:s} wrote info @{1:s}", dbName, dbTime);
                        }
                    }
                    #endregion read first SELECT

                    dr.Close();

                    System.Threading.Thread.Sleep(500);
                }
                catch (SqlException e)
                {
                    cn.Close();
                    Console.WriteLine(e.Message);
                    System.Threading.Thread.Sleep(500);
                    cn.Open();
                }
            }

            cn.Close(); // with while(true) it never reaches here...
        }
    }
}
