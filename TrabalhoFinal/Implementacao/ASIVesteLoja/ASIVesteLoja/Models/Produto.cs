using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace ASIVesteLoja.Models
{
    public class Produto
    {
        public int ProdutoID { get; set; }
        public string Codigo { get; set; }
        public string Designacao { get; set; }
        public int StockQtd { get; set; }
        public float Preco { get; set; }

        [Timestamp]
        //[ConcurrencyCheck]
        public byte[] RowVersion { get; set; }

    }
}