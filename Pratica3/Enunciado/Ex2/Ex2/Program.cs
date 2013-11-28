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

namespace Ex2
{
    class Program
    {

// ponto 1

        static void Main(string[] args)
        {
 
            using (var ctx = new ASIEntities7())
            {
                // em alternativa a usar o Sql Server Profiler, pode fazer:
                //ctx.Database.Log = Console.Write;
               
               var q = (from a in ctx.Alunos
                         select a);


                foreach (var a in q)
                {

                    Console.WriteLine(a.NumAl);

// Ver output do Sql Profiler
                    foreach (var i in a.AlunosAssEsts)
                    {
// Ver output do Sql Profiler
                        Console.WriteLine("{0}:{1}", i.nSeq, i.Interesse);
                    }

                }
            }

//ponto 2
// clear trace no Sql Profiler
            using (var ctx = new ASIEntities7())
            {
                // em alternativa a usar o Sql Server Profiler, pode fazer:
                // ctx.Database.Log = Console.Write;

                ctx.Configuration.ProxyCreationEnabled = false;

                var q = (from a in ctx.Alunos.Include(a => a.AlunosAssEsts)
                         select a);


                foreach (var a in q)
                {

                    Console.WriteLine(a.NumAl);

// Ver output do Sql Profiler
                    foreach (var i in a.AlunosAssEsts)
                    {
// Ver output do Sql Profiler
                        Console.WriteLine("{0}:{1}", i.nSeq, i.Interesse);
                    }

                }
            }

 

        }
    }
}
