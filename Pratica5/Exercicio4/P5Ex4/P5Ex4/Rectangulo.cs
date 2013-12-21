//------------------------------------------------------------------------------
// <copyright file="CSSqlUserDefinedType.cs" company="Microsoft">
//     Copyright (c) Microsoft Corporation.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------
using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Text.RegularExpressions;


[Serializable]
[Microsoft.SqlServer.Server.SqlUserDefinedType(Format.Native)]
public struct Rectangulo: INullable
{
        // formato geral (l1,l2) em que l1 e l2 sao variaveis
    static readonly string parsStr = @"(\((?<l1>[0-9]+)\,(?<l2>[0-9]+)\))";
    static readonly Regex regExpresssion = new Regex(parsStr);
 
    public override string ToString()
    {
        // Replace with your own code
        string s = "null";
        if ( ! _null )
            s = String.Format("({0},{1})", l1, l2);
        return s;
    }
    
    public bool IsNull
    {
        get
        {
            // Put your code here
            
            return _null;
        }
    }
    
    public static Rectangulo Null
    {
        get
        {
            Rectangulo h = new Rectangulo();
            h._null = true;
            return h;
        }
    }
    
    public static Rectangulo Parse(SqlString s)
    {

        if (s.IsNull || s.Value.ToLower().Equals("null"))
            return Null;
        Rectangulo u = new Rectangulo();
        // Put your code here
        if (!regExpresssion.IsMatch(s.Value))
            throw new ApplicationException("Formato de rectangulo incorrecto");
        Match m = regExpresssion.Match(s.Value);
        u.l1 = double.Parse(m.Result("${l1}"));
        u.l2 = double.Parse(m.Result("${l2}"));
        u.Area = u.l1 * u.l2;
        
        return u;
    }
    
    // This is a place-holder method
    public string Method1()
    {
        // Put your code here
        return string.Empty;
    }
    
    // This is a place-holder static method
    public static SqlString Method2()
    {
        // Put your code here
        return new SqlString("");
    }
    
    // This is a place-holder member field
    public double l1;
    public double l2;
    public double Area;
 
    //  Private member
    private bool _null;
}