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
            //Transaction tx = Transaction.Current;

            Console.Write( "You entered: {0}", ordem);
            using (var db = new Entities())
            {
               

               
                var venda = new Venda(){ Estado= 0,
                    MoradaCliente= ordem.moradaCliente,
                    NomeCliente= ordem.nomeCliente };

                db.Vendas.Add(venda);

                // invoca inserirVenda
                db.SaveChanges();
            } 
    
        }
    }
}
