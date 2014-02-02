using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Messaging;
using System.ServiceModel;
using QueueVendas;
using System.Transactions;
using ASIVesteLoja.Models;

namespace ASIVesteLoja.Controllers
{
    public static class VendaHelper
    {
        internal static void enviaVendaParaSede(Venda venda)
        {
            var queue = ConfigurationManager.AppSettings["queue"];
            if (!MessageQueue.Exists(queue))
            {
                MessageQueue.Create(queue, true);
            }

            ChannelFactory<IVendaServico> servico = new ChannelFactory<IVendaServico>("qLSC");
            IVendaServico endpt = servico.CreateChannel();

            VendaOrdem vendaOrdem = new VendaOrdem();
            vendaOrdem.dadosVenda(venda.nomeCliente, venda.moradaCliente);

            float precoUnitario = getProdutoPreco(venda.codigoProduto);

            vendaOrdem.acrescentaProduto(venda.codigoProduto, venda.quantidade, precoUnitario);
            try
            {

                using (TransactionScope scope = new TransactionScope(TransactionScopeOption.Required))
                {

                    endpt.enviaVenda(vendaOrdem);
                    //orderQueue.Send(msg, MessageQueueTransactionType.Automatic);
                    // Complete the transaction.
                    scope.Complete();
                }
            }
            catch (Exception e)
            {
                Console.Write("erro {0}", e);
            }


        }

        private static float getProdutoPreco(string p)
        {
            //TODO: getProdutoPreco
            return 0;
        }
    }
}