using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Messaging;
using System.ServiceModel;
using QueueVendasInterfaces;
using System.Transactions;
using ASIVesteLoja.Models;
using ASIVesteLoja.DAL;
using System.Data.Entity.Infrastructure;

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

                    try
                    {
                        if (produto == null)
                        {
                            erro = "Produto inexistente";
                            return false;
                        }

                        //TODO?: Assumindo que se aceita stock = 0, correcto?
                        if (produto.StockQtd - venda.quantidade < 0)
                        {
                            erro = "Stock indisponível";
                            return false;
                        }

                        enviaVendaParaSede(venda, produto.Preco);

                        produto.StockQtd = produto.StockQtd - venda.quantidade;

                        //TODO!: Validar iconsistencia dados (se entretanto o produto da base de dados já foi actualizado por outra venda)

                        context.SaveChanges();
                    }
                    //catch (DbUpdateConcurrencyException ex)
                    catch (DbUpdateException ex)
                    {
                        var entry = ex.Entries.Single();
                        var clientValues = (Produto)entry.Entity;
                        var databaseValues = (Produto)entry.GetDatabaseValues().ToObject();

                        if (databaseValues.StockQtd != clientValues.StockQtd)
                        {
                            //TODO databaseValues.StockQtd != clientValues.StockQtd
                            throw new Exception("TODO databaseValues.StockQtd != clientValues.StockQtd");
                        }
                        produto.RowVersion = databaseValues.RowVersion;
                    }

                }//END using (var context = new ASIVesteContext())

                // Complete the transaction.
                scope.Complete();

            }//END using (TransactionScope scope = new TransactionScope(TransactionScopeOption.Required))

            erro = "";
            return true;

        }//END efectuaVenda

    }//END class VendaHelper
}