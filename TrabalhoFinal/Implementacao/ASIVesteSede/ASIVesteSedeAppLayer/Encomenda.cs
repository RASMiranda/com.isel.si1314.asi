using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace ASIVesteSedeAppLayer
{
    [DataContract]
    public class Encomenda
    {
        Int32 id;
        Int32 idProduto;
        bool recebida;
        Int32 qtd;
        Int32 idVenda;

        [DataMember]
        public Int32 Id
        {
            get { return id; }
            set { id = value; }
        }

        [DataMember]
        public Int32 IdProduto
        {
            get { return idProduto; }
            set { idProduto = value; }
        }

        [DataMember]
        public bool Recebida
        {
            get { return recebida; }
            set { recebida = value; }
        }

        [DataMember]
        public Int32 Qtd
        {
            get { return qtd; }
            set { qtd = value; }
        }

        [DataMember]
        public Int32 IdVenda
        {
            get { return idVenda; }
            set { idVenda = value; }
        }


    }
}