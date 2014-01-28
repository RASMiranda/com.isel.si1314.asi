using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ASIVesteSede.Models
{
    public enum EstadoEncomenda
    {
        Pendente, Recebida
    }


    public class Encomenda
    {
        public int EncomendaID { get; set; }
        public int Qtd { get; set; }
        public EstadoEncomenda? Estado { get; set; }

        public virtual ICollection<Produto> Produtos { get; set; }
        public virtual VendaProdutos VendaProduto { get; set; }

    }
}