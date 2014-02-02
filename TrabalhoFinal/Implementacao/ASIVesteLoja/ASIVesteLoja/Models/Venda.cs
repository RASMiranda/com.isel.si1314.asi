using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ASIVesteLoja.Models
{
    public class Venda
    {
        public int VendaID { get; set; }//ignorar
        public string nomeCliente { get; set; }
        public string moradaCliente { get; set; }
        public string codigoProduto { get; set; }
        public int quantidade { get; set; }
    }
}