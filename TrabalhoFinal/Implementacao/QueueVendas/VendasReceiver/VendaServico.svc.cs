using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.Transactions;

using QueueVendas;

namespace VendasReceiver
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "Service1" in code, svc and config file together.
    // NOTE: In order to launch WCF Test Client for testing this service, please select Service1.svc or Service1.svc.cs at the Solution Explorer and start debugging.
    
    public class VendaServico : IVendaServico
    {
        [OperationBehavior(TransactionScopeRequired = true )]
        public void enviaVenda( VendaOrdem ordem)
        {
            Console.WriteLine("A processar uma ordem: {0}", ordem);

            if (ordem.numItems != 1)
                throw new Exception(String.Format("É suportado apenas um item por Venda. Itens na Venda:{0}", ordem.numItems));
            
            // ordem.vendaItems.Length == ordem.numItems
            // inserir Vendas e items de venda
            // receber Encomenda (stk qtd sincrono nas 3 db)

            using (var transaction = new TransactionScope(Transaction.Current))
            {
                using (var db = new ASIVesteEntities())
                {
                    db.sp_realizarVenda(ordem.nomeCliente,
                                        ordem.moradaCliente,
                                        ordem.vendaItems[0].codigo,
                                        ordem.vendaItems[0].quantidade);
                }

                transaction.Complete();
            }
    
        }
    }
}
