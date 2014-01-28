using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ASIVesteSede.Models
{
    public enum TipoProduto
    {
        Senhora, Crianca, Homem, Desportista
    }
    public class Produto
    {
        public int ProdutoID { get; set; }
        public TipoProduto?  Tipo { get; set; }
        public string Codigo { get; set; }
        public string Designacao { get; set; }
        public int StockQtd { get; set; }
        public int StockMinimo { get; set; }
        public float Preco { get; set; }

        public virtual Fornecedor Fornecedor { get; set; }

    }
}