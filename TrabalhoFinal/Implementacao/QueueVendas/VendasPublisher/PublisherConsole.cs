using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Messaging;
using System.Transactions;
using VendasPublisher.ServicoVendas;

namespace VendasPublisher
{
    class PublisherConsole
    {
        static void Main(string[] args)
        {
            // submit the purchase order
            //Message msg = new Message();

            //msg.Body = venda;
            ServicoVendas.VendaServicoClient ordem = new VendaServicoClient();

            Venda venda = new Venda();
            venda.IdProduto = 1;
            venda.MoradaCliente = "Av. Conselheiro Emidio Navarro, Lisboa";
            venda.NomeCliente = "Cliente";
            venda.Qtd = 2;

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
