using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;


namespace QueueVendas
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IService1" in both code and config file together.
    [ServiceContract]
    public interface IVendaServico
    {

        [OperationContract(IsOneWay= true)]
        void enviaVenda( VendaOrdem ordem);

     }

    
    [DataContract]
    [Serializable]
    public class VendaOrdemItem
    {
        [DataMember]
        public string codigo; // o id do produto é diferente em cada base de dados o codigo é que é partilhado e único
        [DataMember]
        public float precoUnitario;
        [DataMember]
        public int quantidade; // assumimos que as vendas são de numero inteiro de unidades de produto

        public float CustoTotal
        {
            get { return quantidade * precoUnitario; }
        }
        public override string ToString()
        {
            float custoItem = quantidade * precoUnitario;
            StringBuilder strbuf = new StringBuilder("Produto: " + codigo + "\t" + quantidade + "\t"
                    + precoUnitario + "\t" + custoItem);
            return strbuf.ToString();
        }

    }
    public enum VendaEstados
    {
        pendente,
        encomenda,
        entregue
    }
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

        public void acrescentaProduto(string codigo, int qtd, float precoUnitario)
        {
            VendaOrdemItem item = new VendaOrdemItem();
            item.precoUnitario = precoUnitario;
            item.quantidade = qtd;
            item.codigo = codigo;
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
            DateTime now = DateTime.Now;
            string timeFormat =  "yyyy.MM.dd HH:mm:ss";
            
            StringBuilder strbuf = new StringBuilder("Venda em:" + now.ToString( timeFormat ) +
                " a: " + nomeCliente + "\n");
            strbuf.Append("\tMorador em: " + moradaCliente + "\n");
            strbuf.Append("\tProdutos\n");

            for (int i = 0; i < numItems; i++)
            {
                VendaOrdemItem item = new VendaOrdemItem();
                item = vendaItems[ i ];

                strbuf.Append("\t\t" + item.ToString());

            }



            strbuf.Append("\n\tcusto total: $" + custoTotal + "\n");
            strbuf.Append("\testado: " + vendaEstado + "\n===============\n");
            return strbuf.ToString();
        }
    }
}
