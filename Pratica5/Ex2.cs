using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

using System.Collections;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction(
                 TableDefinition = "c int"
                 )]
    public static IEnumerable f2(int n)
    {   ArrayList a = new ArrayList();
    for (int i = 0; i < n; ++i)
        a.Add(new SqlInt32(i));
        return a;
    }

    
};

