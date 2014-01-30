using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using System.ServiceModel.MsmqIntegration;
using ASIVesteSede.Vendas_Queue;

namespace ASIVesteLoja
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IVendasQueue" in both code and config file together.
    // Define a service contract. 
    [ServiceContract(Namespace = "http://ASIVesteSede.Vendas_Queue")]
    [ServiceKnownType(typeof(VendaOrder))]
    public interface IVendaService
    {

        [OperationContract(IsOneWay = true, Action = "*")]
        void SubmitVenda(MsmqMessage<VendaOrder> msg);

    }

 
}
