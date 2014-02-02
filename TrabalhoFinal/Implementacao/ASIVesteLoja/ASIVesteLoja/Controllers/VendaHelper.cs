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
using ASIVesteLoja.DAL;

namespace ASIVesteLoja.Controllers
{
    public static class VendaHelper
    {
        private static void enviaVendaParaSede(Venda venda, float preco)
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

            vendaOrdem.acrescentaProduto(venda.codigoProduto, venda.quantidade, preco);
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

        internal static bool efectuaVenda(Venda venda, out String erro)
        {
            using (var context = new ASIVesteContext())
            {
                var produto = context.Produtos
                                    .Where(b => b.Codigo == venda.codigoProduto)
                                    .FirstOrDefault();

                if (produto == null)
                {
                    erro = "Produto inexistente";
                    return false;
                }

                //TODO: Assumindo que se aceita stock = 0, correcto?
                if (produto.StockQtd - venda.quantidade < 0)
                {
                    erro = "Stock indisponível";
                    return false;
                }
                
                enviaVendaParaSede(venda, produto.Preco);

                produto.StockQtd = produto.StockQtd - venda.quantidade;

                //TODO: Validar iconsistencia? (se entretanto o produto da base de dados já foi actualizado por outra venda)

                context.SaveChanges();
            }
            erro = "";
            return true;
        }
    }
}