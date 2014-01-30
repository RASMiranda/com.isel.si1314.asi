using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using ASIVesteSede.Vendas_Queue;
using System.Messaging;


namespace VendasService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "Service1" in code, svc and config file together.
    // NOTE: In order to launch WCF Test Client for testing this service, please select Service1.svc or Service1.svc.cs at the Solution Explorer and start debugging.
    public class VendaService : IVendaService
    {
        public void submitVenda(VendaOrder order)
        {
            Console.Write("Recebeu a ordem: {0}", order);
        }
        static void Main(string[] args)
        {
            using ( ServiceHost host = new ServiceHost( typeof(VendaService)))
            {
                string queueLSC = ".\\private$\\VendasLSC";
                if( ! MessageQueue.Exists( queueLSC ) )
                {
                    MessageQueue.Create( queueLSC, false);
                }
                host.Open();
                Console.WriteLine( "Server Started");
                Console.WriteLine("Carregue return para terminar");
                Console.ReadKey();
            }
        
        }
    }
}
