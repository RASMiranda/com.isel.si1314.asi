using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Ex1Cliente.ServiceReference1;


namespace Ex1Cliente
{
    class Program
    {
        static void Main(string[] args)
        {
            using (var proxy1 = new ServicoClient())
            {

                var c1 = new Conta();
                c1.Numero = 1;
                c1.Saldo = 1000;
                c1.Titular = "José";
                proxy1.inserirConta(c1);

                Console.WriteLine(
                        "Inserida Conta nº " + c1.Numero.ToString()
                        + " com Saldo: " + c1.Saldo.ToString()
                        + " do Titular: " + c1.Titular);

                var c2 = new Conta();
                c2.Numero = 2;
                c2.Saldo = 1000;
                c2.Titular = "António";
                proxy1.inserirConta(c2);

                Console.WriteLine(
                        "Inserida Conta nº " + c2.Numero.ToString()
                        + " com Saldo: " + c2.Saldo.ToString()
                        + " do Titular: " + c2.Titular);

                float valor = 500;
                proxy1.Transferir(c1.Numero, c2.Numero, valor);

                Console.WriteLine(
                        "1º Transferido valor: " + valor
                        + " da Conta nº: " + c1.Numero.ToString()
                        + " para Conta nº: " + c2.Numero.ToString());

                proxy1.Transferir(c1.Numero, c2.Numero, valor);

                Console.WriteLine(
                        "2º Transferido valor: " + valor
                        + " da Conta nº: " + c1.Numero.ToString()
                        + " para Conta nº: " + c2.Numero.ToString());
            }
            Console.WriteLine("Cliente terminou. Enter para terminar");
            Console.ReadLine();


        }
    }
}
