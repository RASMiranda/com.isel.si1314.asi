using System;
using System.Data;
using System.Data.SqlClient;
using Microsoft.SqlServer.Server;


public partial class Triggers
{
    
    [Microsoft.SqlServer.Server.SqlTrigger (Name="TriggerEx3", Target="t1", Event="FOR UPDATE")]
    public static void Ex3()
    {
        int nl;
        SqlTriggerContext tc = SqlContext.TriggerContext;
        SqlConnection cn = new SqlConnection("context connection=true");
        cn.Open();
        SqlCommand cmd = cn.CreateCommand();
        cmd.CommandText = "insert into t2 select c1 from inserted where c2 = null";
        nl = cmd.ExecuteNonQuery();
        cn.Close();
    }
}
