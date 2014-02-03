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
            var queuePath = ConfigurationManager.AppSettings["queuePath"];
            if (!MessageQueue.Exists(queuePath))
            {
                MessageQueue.Create(queuePath, true);
            }

            ChannelFactory<IVendaServico> servico = new ChannelFactory<IVendaServico>("queueService");
            IVendaServico endpt = servico.CreateChannel();

            VendaOrdem vendaOrdem = new VendaOrdem();
            vendaOrdem.dadosVenda(venda.nomeCliente, venda.moradaCliente);

            vendaOrdem.acrescentaProduto(venda.codigoProduto, venda.quantidade, preco);

            endpt.enviaVenda(vendaOrdem);
        }

        internal static bool efectuaVenda(Venda venda, out String erro)
        {
            //TODO?: Try Catch->Pretty message?

            using (TransactionScope scope = new TransactionScope(TransactionScopeOption.Required))
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
                // Complete the transaction.
                scope.Complete();
            }
            erro = "";
            return true;
        }
    }
}