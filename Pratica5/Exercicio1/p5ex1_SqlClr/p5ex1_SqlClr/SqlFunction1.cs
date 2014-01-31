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

public partial class UserDefinedFunctions
{
    readonly static int i;
    [Microsoft.SqlServer.Server.SqlFunction]
    public static SqlSingle SqlFunction1()
    {
        // Put your code here
        return new SqlSingle (1.3F);
    }
}
