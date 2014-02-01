using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Web;

namespace QueueVendas
{

    [DataContract]
    [Serializable]
    public class VendaOrdemItem
    {
        public int id;
        public float precoUnitario;
        public int quantidade; // assumimos que as vendas são de numero inteiro de unidades de produto

        public float CustoTotal
        {
            get { return quantidade * precoUnitario; }
        }
        public override string ToString()
        {
            float custoItem = quantidade * precoUnitario;
            StringBuilder strbuf = new StringBuilder("Produto: " + id + "\t" + quantidade + "\t"
                    + precoUnitario + "\t" + custoItem);
            return strbuf.ToString();
        }

    }
}