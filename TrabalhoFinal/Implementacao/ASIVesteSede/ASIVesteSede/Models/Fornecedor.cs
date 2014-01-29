using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ASIVesteSede.Models
{
    public class Fornecedor
    {
        public int FornecedorID {get; set;}
        public int Numero {get; set;}
        public string Nome {get; set;}
        public string Morada {get; set;}
    
        public virtual ICollection<Produto> Produtos { get; set;}
    }
}