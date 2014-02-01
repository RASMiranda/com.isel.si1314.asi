using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;

namespace ASIVesteSedeAppLayer
{
    [ServiceContract(Namespace = "http://asiveste/services/sede/venda")]
    public interface ISedeVendaServico
    {
        /// <summary>
        /// TODO
        /// </summary>
        /// <param name="venda"></param>
        [OperationContract]
        void registaVenda(Venda venda);
    }
}
