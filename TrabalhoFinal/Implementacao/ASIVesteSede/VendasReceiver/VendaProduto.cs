//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace VendasReceiver
{
    using System;
    using System.Collections.Generic;
    
    public partial class VendaProduto
    {
        public VendaProduto()
        {
            this.Encomendas = new HashSet<Encomenda>();
        }
    
        public int VendaProdutosID { get; set; }
        public string Codigo { get; set; }
        public int Qtd { get; set; }
        public Nullable<int> Estado { get; set; }
        public Nullable<int> Venda_VendaID { get; set; }
        public Nullable<int> Produto_ProdutoID { get; set; }
    
        public virtual ICollection<Encomenda> Encomendas { get; set; }
        public virtual Produto Produto { get; set; }
        public virtual Venda Venda { get; set; }
    }
}
