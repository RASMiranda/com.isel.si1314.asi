using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using System.ServiceModel.MsmqIntegration;
using System.Configuration;
using ASIVesteSede.Vendas_Queue;
using System.Messaging;
using System.Transactions;

namespace ASIVesteSede.Vendas_Queue
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "Service1" in code, svc and config file together.
    // NOTE: In order to launch WCF Test Client for testing this service, please select Service1.svc or Service1.svc.cs at the Solution Explorer and start debugging.
    // Service class which implements the service contract.
    // Added code to write output to the console window
    class Program
    {
        static void Main(string[] args)
        {
            //Connect to the queue
            MessageQueue orderQueue = new MessageQueue(@"FormatName:Direct=OS:" + ConfigurationManager.AppSettings["orderQueueName"]);

            VendaOrder venda = new VendaOrder();
            venda.dadosVenda("Cliente", "Av. Conselheiro Emidio Navarro, Lisboa");

            venda.produto("scam1", 5, 25.4f);
            venda.produto("scam2", 1, 33.2f);

            Message msg = new Message();
            msg.Body = venda;
            using (TransactionScope scope = new TransactionScope(TransactionScopeOption.Required))
            {
                orderQueue.Send(msg, MessageQueueTransactionType.Automatic);
                // Complete the transaction.
                scope.Complete();
            }

            Console.WriteLine("Placed the order:{0}", venda);
            Console.WriteLine("Press <ENTER> to terminate client.");
            Console.ReadLine();
        }
    }

}
