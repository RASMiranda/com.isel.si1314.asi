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
    
    public partial class Venda
    {
        public Venda()
        {
            this.VendaProdutos = new HashSet<VendaProduto>();
        }
    
        public int VendaID { get; set; }
        public string NomeCliente { get; set; }
        public string MoradaCliente { get; set; }
        public Nullable<int> Estado { get; set; }
    
        public virtual ICollection<VendaProduto> VendaProdutos { get; set; }
    }
}
