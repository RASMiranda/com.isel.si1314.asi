using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Ex4Cliente.ServiceReference1;


namespace Ex4Cliente
{
    class Program
    {
        static void Main(string[] args)
        {
            ServicoClient proxy1 = new ServicoClient();
            ServicoClient proxy2 = new ServicoClient();
            // alinea a) Comentar para realizar a alinea b)
            proxy1.TransferirSessionFull(1, 2, 100);
            proxy2.TransferirSessionFull(1, 2, 100);
            proxy1.Finalizar();
            proxy2.Finalizar();

            // alinea b) 
            proxy1.TransferirSessionLess(1, 2, 100);
            proxy2.TransferirSessionLess(1, 2, 100);

            proxy1.Close();
            proxy2.Close();


        }
    }
}
