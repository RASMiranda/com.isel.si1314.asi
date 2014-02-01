using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace ASIVesteSedeAppLayer
{
    [DataContract]
    [Serializable]
    public class Produto
    {
        Int32 id;
        Int32 tipo;
        Int32 stockMinimo;
        Int32 idFornecedor;
        string designacao;
        decimal preco;
        Int32 stockQtd;

        [DataMember]
        public Int32 Id
        {
            get { return id; }
            set { id = value; }
        }

        [DataMember]
        public Int32 Tipo
        {
            get { return tipo; }
            set { tipo = value; }
        }

        [DataMember]
        public Int32 StockMinimo
        {
            get { return stockMinimo; }
            set { stockMinimo = value; }
        }

        [DataMember]
        public Int32 IdFornecedor
        {
            get { return idFornecedor; }
            set { idFornecedor = value; }
        }

        [DataMember]
        public String Designacao
        {
            get { return designacao; }
            set { designacao = value; }
        }

        [DataMember]
        public decimal Preco
        {
            get { return preco; }
            set { preco = value; }
        }

        [DataMember]
        public Int32 StockQtd
        {
            get { return stockQtd; }
            set { stockQtd = value; }
        }


    }
}