using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Web;

namespace QueueVendas
{

    [DataContract]
    [Serializable]
    public class VendaOrdem
    {
        [DataMember]
        public static string[] orderStates = { "Pendente", "Encomendada", "Expedida" };
        [DataMember]
        public string nomeCliente;
        [DataMember]
        public string moradaCliente;
        [DataMember]
        public VendaOrdemItem[] vendaItems; // a melhorar
        [DataMember]
        public int numItems;
        [DataMember]
        public VendaEstados vendaEstado;

        public void dadosVenda(string nome, string morada)
        {
            nomeCliente = nome;
            moradaCliente = morada;
            vendaEstado = VendaEstados.pendente;
            vendaItems = new VendaOrdemItem[10];
            numItems = 0;
            //vendaItems = new List<VendaOrderItem>();
        }

        public void acrescentaProduto(int id, int qtd, float precoUnitario)
        {
            VendaOrdemItem item = new VendaOrdemItem();
            item.precoUnitario = precoUnitario;
            item.quantidade = qtd;
            item.id = id;
            vendaItems[numItems] = item;
            numItems++;
        }
        public float custoTotal
        {
            get
            {
                float totalCost = 0;
                foreach (VendaOrdemItem item in vendaItems)
                    if (item != null)
                    {
                        totalCost += item.CustoTotal;
                    }
                return totalCost;
            }
        }

        public VendaEstados Status
        {
            get
            {
                return vendaEstado;
            }
            set
            {
                vendaEstado = value;
            }
        }

        public override string ToString()
        {
            StringBuilder strbuf = new StringBuilder("Venda a: " + nomeCliente + "\n");
            strbuf.Append("\tMorador em: " + moradaCliente + "\n");
            strbuf.Append("\tProdutos\n");

            foreach (VendaOrdemItem item in vendaItems)
            {
                if (item != null)
                {
                    strbuf.Append("\t\t" + item.ToString());
                }
            }

            strbuf.Append("\tcusto total: $" + custoTotal + "\n");
            strbuf.Append("\testado: " + vendaEstado + "\n");
            return strbuf.ToString();
        }
    }
    public enum VendaEstados
    {
        pendente,
        encomenda,
        entregue
    }
}