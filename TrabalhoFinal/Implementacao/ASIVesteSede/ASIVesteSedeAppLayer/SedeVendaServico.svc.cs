using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;

namespace ASIVesteSedeAppLayer
{
    [ServiceBehavior(Namespace = "http://asiveste/services/sede/venda")]
    public class SedeVendaServico : ISedeVendaServico
    {
        public void registaVenda(Venda venda)
        {
            if (venda == null)
            {
                throw new ArgumentNullException("composite");
            }
            //TODO: LOGICA DE NEGOCIO/ACESSO A DADOS
        }
    }
}
