using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ASIVesteSede.Models
{
    public enum EstadoVenda
    {
        Pendente, Encomendado, Expedida
    }

    public class Venda
    {
        public int VendaID { get; set; }
        public string NomeCliente { get; set; }
        public string MoradaCliente { get; set; }
        public EstadoVenda?  Estado { get; set; }

        public virtual ICollection<VendaProdutos> Produtos { get; set; }
    }
}