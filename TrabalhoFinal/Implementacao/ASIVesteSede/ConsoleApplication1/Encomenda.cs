//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ConsoleApplication1
{
    using System;
    using System.Collections.Generic;
    
    public partial class Encomenda
    {
        public int EncomendaID { get; set; }
        public int Qtd { get; set; }
        public Nullable<int> Estado { get; set; }
        public Nullable<int> Produto_ProdutoID { get; set; }
        public Nullable<int> VendaProduto_VendaProdutosID { get; set; }
    
        public virtual Produto Produto { get; set; }
        public virtual VendaProduto VendaProduto { get; set; }
    }
}
