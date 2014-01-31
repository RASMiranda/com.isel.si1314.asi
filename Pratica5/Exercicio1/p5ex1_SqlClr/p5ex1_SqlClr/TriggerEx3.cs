//------------------------------------------------------------------------------
// <copyright file="CSSqlTrigger.cs" company="Microsoft">
//     Copyright (c) Microsoft Corporation.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------
using System;
using System.Data;
using System.Data.SqlClient;
using Microsoft.SqlServer.Server;

public partial class Triggers
{        
    // Enter existing table or view for the target and uncomment the attribute line
    [Microsoft.SqlServer.Server.SqlTrigger (Name="TriggerEx3", Target="t1", Event="FOR UPDATE")]
    public static void Ex3 ()
    {
        // Replace with your own code
        SqlContext.Pipe.Send("Trigger FIRED");

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

