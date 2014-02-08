using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace ASIVesteLoja.Models
{
    public class Reclamacao
    {
        public int ReclamacaoID { get; set; }
        public string ClienteBI { get; set; }
        public string Texto { get; set; }
        public DateTime DataInsercao { get; set; }
    }
}