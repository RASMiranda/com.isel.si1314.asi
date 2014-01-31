using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Entity.Infrastructure;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Core.EntityClient;
using System.Configuration;

using System.Data.SqlClient;

using System.Data.Entity.Core.Objects;

using System.Transactions;

namespace Ex3
{
    class Program
    {

        
        static void Main(string[] args)
        {


            var al1 = new Aluno { NumAl = 7777, Nome = "ana" };
            al1.AlunosAssEsts = new HashSet<AlunosAssEst>();

            using (var ctx = new ASIEntities7())
            {
                // em alternativa a usar o Sql Server Profiler, pode fazer:
                ctx.Database.Log = Console.Write;

                ctx.Configuration.AutoDetectChangesEnabled = false;


                ctx.Alunos.Add(al1);

                var interesse = new AlunosAssEst { NumAl = 7777, Interesse = "musica" };

                al1.AlunosAssEsts.Add(interesse); 

                var al2= ctx.Alunos.Create<Aluno>();
                al2.NumAl = 9999;
                al2.Nome = "xavier";

                ctx.Alunos.Add(al2);

                interesse = new AlunosAssEst { NumAl = 9999, Interesse = "futebol" };

                al2.AlunosAssEsts.Add(interesse);

                
// ponto 1: correr o programa primeiro com o comentário na linha seguinte e depois, sem
                //ctx.ChangeTracker.DetectChanges();

                ctx.SaveChanges();

// verificar a saída do Sql Server Profiler

                Console.WriteLine("Press any key to exit...");
                Console.ReadLine();

            }

 
        }
    }
}
