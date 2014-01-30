using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Messaging;
using System.Transactions;
using QueueVendas;
using VendasPublisher.ServicoVendas;

namespace VendasPublisher
{
    class PublisherConsole
    {
        static void Main(string[] args)
        {

            

            VendaOrdem venda = new VendaOrdem();
            venda.dadosVenda("Cliente", "Av. Conselheiro Emidio Navarro, Lisboa");

            venda.acrescentaProduto("scam1", 5, 25.4f);
            venda.acrescentaProduto("scam2", 1, 33.2f);

            

            // submit the purchase order
            //Message msg = new Message();

            //msg.Body = venda;
            ServicoVendas.VendaServicoClient ordem = new VendaServicoClient();

            using (TransactionScope scope = new TransactionScope(TransactionScopeOption.Required))
            {
                ordem.enviaVenda(venda);
                //orderQueue.Send(msg, MessageQueueTransactionType.Automatic);
                // Complete the transaction.
                scope.Complete();
            }

            Console.WriteLine("Placed the order:{0}", venda);
            Console.WriteLine("Press <ENTER> to terminate client.");
            Console.ReadLine();



        }
    }
}
