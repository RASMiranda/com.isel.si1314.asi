//------------------------------------------------------------------------------
// <copyright file="CSSqlFunction.cs" company="Microsoft">
//     Copyright (c) Microsoft Corporation.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------
using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

using System.Collections;


public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction( TableDefinition = "c int",
        FillRowMethodName= "trataLinha")]
    public static IEnumerable f2(int n)
    {
        ArrayList a = new ArrayList();
        for (int i = 0; i < n; ++i)
            a.Add(new SqlInt32(i));
        return a;
    }
    public static void trataLinha(object linha, out int c)
    {
        SqlInt32 dr = (SqlInt32)linha;
        c = (int)dr;
    }
}
