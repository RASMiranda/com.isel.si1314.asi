using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ASIVesteSede.Models
{
    public class VendaProdutos
    {
        public int VendaProdutosID { get; set; }
        public string NomeCliente { get; set; }
        public int Qtd { get; set; }
        public EstadoVenda? Estado { get; set; }

        public virtual Venda Venda { get; set;}
        public virtual Produto Produto { get; set;}
    }
}