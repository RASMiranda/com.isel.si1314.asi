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
    
    public partial class Fornecedor
    {
        public Fornecedor()
        {
            this.Produtoes = new HashSet<Produto>();
        }
    
        public int FornecedorID { get; set; }
        public int Numero { get; set; }
        public string Nome { get; set; }
        public string Morada { get; set; }
    
        public virtual ICollection<Produto> Produtoes { get; set; }
    }
}
