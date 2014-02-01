using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;

namespace QueueVendas
{
    public class VendaServico : IVendaServico
    {
        public void enviaVenda(SedeVendaServicoReference.Venda venda)
        {
            Console.Write("You entered: {0}", venda);//TODO: DELETE AFTER TESTES?

            SedeVendaServicoReference.SedeVendaServicoClient cl = new SedeVendaServicoReference.SedeVendaServicoClient();

            cl.registaVenda(venda);
        }
    }
}
