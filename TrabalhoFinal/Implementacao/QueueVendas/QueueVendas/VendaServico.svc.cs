using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;

namespace QueueVendas
{
    public class VendaServico : IVendaServico
    {
        public void enviaVenda(VendaOrdem ordem)
        {
            Console.Write("You entered: {0}", ordem);//TODO: DELETE AFTER TESTES?

            SedeVendaServicoReference.SedeVendaServicoClient cl = new SedeVendaServicoReference.SedeVendaServicoClient();
            
            //TODO: tratar as vendas nas lojas como na sede, contendo um produto cada uma?
            foreach (var item in ordem.vendaItems)
	        {
                if (item != null)//TODO: FIX THIS, ordem.vendaItems vem com elementos vazios, limpar no cliente antes de enviar...
                {
                    SedeVendaServicoReference.Venda venda = new SedeVendaServicoReference.Venda();
                    venda.IdProduto = item.id;
                    venda.Qtd = item.quantidade;
                    venda.MoradaCliente = ordem.moradaCliente;
                    venda.NomeCliente = ordem.nomeCliente;
                    cl.registaVenda(venda);//TODO: Neste cenario com varios produtos numa venda fara sentido colocar este ciclo dentro de uma transacção?
                }
	        }
        }
    }
}
