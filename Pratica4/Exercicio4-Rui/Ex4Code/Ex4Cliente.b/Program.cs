using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Ex4Cliente.b.ServiceReference1;


namespace Ex4Cliente.b
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                ServicoClient proxy1 = new ServicoClient();
                ServicoClient proxy2 = new ServicoClient();
                // alinea a) Comentar para realizar a alinea b)
                //proxy1.TransferirSessionFull(1, 2, 100);
                //proxy2.TransferirSessionFull(1, 2, 100);
                //proxy1.Finalizar();
                //proxy2.Finalizar();

                // alinea b) 
                proxy1.TransferirSessionLess(1, 2, 100);
                proxy2.TransferirSessionLess(1, 2, 100);

                proxy1.Close();
                proxy2.Close();
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception.Message: {0}", e.Message);
                Console.WriteLine("Exception.StackTrace: {0}", e.StackTrace);
            }
            Console.WriteLine("Cliente terminado. Enter para sair");
            Console.ReadLine();


        }
    }
}
