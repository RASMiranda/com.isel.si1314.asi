using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Ex2Cliente.a.ServiceReference1;


namespace Ex2Cliente.a
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                using (var proxy1 = new ServicoClient())
                {

                    var c1 = new Conta();
                    c1.Numero = 1;
                    c1.Saldo = 1000;
                    c1.Titular = "José";
                    proxy1.alterarConta(c1);

                    Console.WriteLine(
                            "Alterada Conta nº " + c1.Numero.ToString()
                            + " com Saldo: " + c1.Saldo.ToString()
                            + " do Titular: " + c1.Titular);

                    var c2 = new Conta();
                    c2.Numero = 2;
                    c2.Saldo = 1000;
                    c2.Titular = "António";
                    proxy1.alterarConta(c2);

                    Console.WriteLine(
                            "Alterada Conta nº " + c2.Numero.ToString()
                            + " com Saldo: " + c2.Saldo.ToString()
                            + " do Titular: " + c2.Titular);

                    float valor = 500;

                    Console.WriteLine(
                            "Vai Transferi valor: " + valor
                            + " da Conta nº: " + c1.Numero.ToString()
                            + " para Conta nº: " + c2.Numero.ToString());

                    proxy1.Transferir(c1.Numero, c2.Numero, valor);

                    Console.WriteLine(
                            "Transferido valor: " + valor
                            + " da Conta nº: " + c1.Numero.ToString()
                            + " para Conta nº: " + c2.Numero.ToString());



                }

                Console.WriteLine("Cliente terminou. Enter para terminar");
                Console.ReadLine();


            }
            catch (Exception e)
            {
                Console.WriteLine("Exception.Message:");
                Console.WriteLine(e.Message);
                Console.WriteLine("Exception.StackTrace:");
                Console.WriteLine(e.StackTrace);
                Console.WriteLine("Cliente terminou. Enter para terminar");
                Console.ReadLine();
            }

        }
    }
}
