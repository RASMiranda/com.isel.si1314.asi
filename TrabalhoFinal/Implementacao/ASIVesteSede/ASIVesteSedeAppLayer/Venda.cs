using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace ASIVesteSedeAppLayer
{
    [DataContract]
    [Serializable]
    public class Venda
    {
        Int32 id;
        string nomeCliente;
        string moradaCliente;
        Int32 idProduto;
        Int32 qtd;

        [DataMember]
        public Int32 Id
        {
            get { return id; }
            set { id = value; }
        }

        [DataMember]
        public string NomeCliente
        {
            get { return nomeCliente; }
            set { nomeCliente = value; }
        }

        [DataMember]
        public string MoradaCliente
        {
            get { return moradaCliente; }
            set { moradaCliente = value; }
        }

        [DataMember]
        public Int32 IdProduto
        {
            get { return idProduto; }
            set { idProduto = value; }
        }

        [DataMember]
        public Int32 Qtd
        {
            get { return qtd; }
            set { qtd = value; }
        }

    }
}