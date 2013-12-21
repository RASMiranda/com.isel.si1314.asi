using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class UserDefinedFunctions
{
    
    static int i;
    [Microsoft.SqlServer.Server.SqlFunction]
    public static SqlSingle f()
    {
        return new SqlSingle(1.3F);
    }
};

