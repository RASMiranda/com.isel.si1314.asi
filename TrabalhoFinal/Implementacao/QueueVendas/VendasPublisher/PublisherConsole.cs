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
        // aplicacao para testes da proxy VendaServicoClient
        static void Main(string[] args)
        {
            // submit the purchase order

            //Message msg = new Message();
            string queueLSC = ".\\private$\\queueLSC";
            //string queueLSC = ".\\queueLSC";
            if (!MessageQueue.Exists(queueLSC))
                MessageQueue.Create(queueLSC, true);

            ServicoVendas.VendaServicoClient ordem = new VendaServicoClient();

            VendaOrdem venda = new VendaOrdem();

            #region primeira ordem de venda 
            venda.dadosVenda("Cliente#1", "Av. Conselheiro Emidio Navarro, Lisboa");
            venda.acrescentaProduto("SC002", 3, 25.4f);

            using (TransactionScope scope = new TransactionScope(TransactionScopeOption.Required))
            {
                ordem.enviaVenda(venda);
                //orderQueue.Send(msg, MessageQueueTransactionType.Automatic);
                // Complete the transaction.
                scope.Complete();
            }
            #endregion primeira ordem de venda 

            Console.WriteLine("Emitida a primeira ordem de venda.");
            Console.ReadKey();

            #region segunda ordem de venda
            venda.dadosVenda("Cliente#2", "Zona J, Chelas");
            venda.acrescentaProduto("SC002", 4, 25.4f);

            using (TransactionScope scope = new TransactionScope(TransactionScopeOption.Required))
            {
                ordem.enviaVenda(venda);
                scope.Complete();
            }
            #endregion segunda ordem de venda

            Console.WriteLine("Emitida a segunda ordem de venda.");
            Console.ReadKey();

            #region terceira ordem de venda
            venda.dadosVenda("Cliente#3", "Zona J, Chelas");
            venda.acrescentaProduto("SC002", 4, 25.4f);

            using (TransactionScope scope = new TransactionScope(TransactionScopeOption.Required))
            {
                ordem.enviaVenda(venda);
                scope.Complete();
            }
            #endregion terceira ordem de venda

            Console.WriteLine("Emitida a terceira ordem de venda.");
            Console.ReadKey();

            ordem.Close();
        }
    }
}
