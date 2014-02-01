using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace ASIVesteSedeAppLayer
{
    [DataContract]
    public class Fornecedor
    {
        Int32 id;
        string nome;
        string morada;

        [DataMember]
        public Int32 Id
        {
            get { return id; }
            set { id = value; }
        }

        [DataMember]
        public String Nome
        {
            get { return nome; }
            set { nome = value; }
        }

        [DataMember]
        public String Morada
        {
            get { return morada; }
            set { morada = value; }
        }


    }
}