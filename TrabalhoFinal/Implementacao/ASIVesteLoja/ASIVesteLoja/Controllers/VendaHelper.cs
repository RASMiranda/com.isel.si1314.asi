using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Messaging;

namespace ASIVesteLoja.Controllers
{
    public static class VendaHelper
    {
        internal static void enviaVendaParaSede()
        {
            var queue = ConfigurationManager.AppSettings["queue"];
            if (!MessageQueue.Exists(queue))
            {
                MessageQueue.Create(queue, true);
            }


            ////msg.Body = venda;
            //Boolean terminar = new Boolean();
            //string comando;

            //terminar = false;
            //ServicoVendas.VendaServicoClient ordem = new VendaServicoClient();

            //while (!terminar)
            //{
            //    VendaOrdem venda = new VendaOrdem();
            //    venda.dadosVenda("Cliente", "Av. Conselheiro Emidio Navarro, Lisboa");

            //    venda.acrescentaProduto("scam1", 5, 25.4f);
            //    venda.acrescentaProduto("scam2", 1, 33.2f);
            //    try
            //    {

            //        using (TransactionScope scope = new TransactionScope(TransactionScopeOption.Required))
            //        {

            //            ordem.enviaVenda(venda);
            //            //orderQueue.Send(msg, MessageQueueTransactionType.Automatic);
            //            // Complete the transaction.
            //            scope.Complete();
            //        }
            //    }
            //    catch (Exception e)
            //    {
            //        Console.Write("erro {0}", e);
            //    }


            //    Console.WriteLine("Ordem colocada na queue:{0}", venda);
            //    Console.WriteLine("Use 'q' para terminar ou <ENTER> criar mais uma mensgem na queue.");
            //    comando = Console.ReadLine();
            //    terminar = comando.Contains('q');
            //}
            //ordem.Close();
        }
    }
}