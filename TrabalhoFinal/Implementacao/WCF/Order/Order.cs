//----------------------------------------------------------------
// Copyright (c) Microsoft Corporation.  All rights reserved.
//----------------------------------------------------------------

using System;
using System.Text;
using System.Collections.Generic;

namespace Microsoft.Samples.MSMQToWCF
{
    // Define the Purchase Order Line Item
    [Serializable]
    public class PurchaseOrderLineItem
    {
        
        public string productId;
        public float unitCost;
        public int quantity;

        public override string ToString()
        {
            String displayString = "Order LineItem: " + quantity + " of " + productId + " @unit price: $" + unitCost + "\n";
            return displayString;
        }

        public float TotalCost
        {
            get { return unitCost * quantity; }
        }
    }

    public enum OrderStates
    {
        Pending,
        Processed,
        Shipped
    }

    // Define Purchase Order
    [Serializable]
    public class PurchaseOrder
    {
	public static string[] OrderStates = { "Pending", "Processed", "Shipped" };
        public string poNumber;
        public string customerId;
        public PurchaseOrderLineItem[] orderLineItems;
        public OrderStates orderStatus;

        public float TotalCost
        {
            get
            {
                float totalCost = 0;
                foreach (PurchaseOrderLineItem lineItem in orderLineItems)
                    totalCost += lineItem.TotalCost;
                return totalCost;
            }
        }

        public OrderStates Status
        {
            get
            {
                return orderStatus;
            }
            set
            {
                orderStatus = value;
            }
        }

        public override string ToString()
        {
            StringBuilder strbuf = new StringBuilder("Purchase Order: " + poNumber + "\n");
            strbuf.Append("\tCustomer: " + customerId + "\n");
            strbuf.Append("\tOrderDetails\n");

            foreach (PurchaseOrderLineItem lineItem in orderLineItems)
            {
                strbuf.Append("\t\t" + lineItem.ToString());
            }

            strbuf.Append("\tTotal cost of this order: $" + TotalCost + "\n");
            strbuf.Append("\tOrder status: " + Status + "\n");
            return strbuf.ToString();
        }
    }
    
    [Serializable]
    public class VendaOrderItem
    {
        public string codigo; // o id do produto é diferente em cada base de dados o codigo é que é partilhado e único
        public float precoUnitario;
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
    [Serializable]
    public class VendaOrder
    {
        public static string[] orderStates = { "Pendente", "Encomendada", "Expedida" };
        public string nomeCliente;
        public string moradaCliente;
        public VendaOrderItem[] vendaItems; // a melhorar
        public int numItems;
        public VendaEstados vendaEstado;

        public void dadosVenda(string nome, string morada)
        {
            nomeCliente = nome;
            moradaCliente = morada;
            vendaEstado = VendaEstados.pendente;
            vendaItems = new VendaOrderItem[10];
            numItems = 0;
            //vendaItems = new List<VendaOrderItem>();
        }

        public void produto(string codigo, int qtd, float precoUnitario)
        {
            VendaOrderItem item = new VendaOrderItem();
            item.precoUnitario = precoUnitario;
            item.quantidade = qtd;
            item.codigo = codigo;
            vendaItems[ numItems]=item;
            numItems++;
        }
        public float custoTotal
        {
            get
            {
                float totalCost = 0;
                foreach (VendaOrderItem item in vendaItems)
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

            foreach (VendaOrderItem item in vendaItems)
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
}
