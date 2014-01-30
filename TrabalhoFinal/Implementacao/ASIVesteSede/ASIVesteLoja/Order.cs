//----------------------------------------------------------------
// Copyright (c) Microsoft Corporation.  All rights reserved.
//----------------------------------------------------------------

using System;
using System.Text;
using System.Collections.Generic;

namespace ASIVesteSede.Vendas_Queue
{
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
