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
    public partial class ASIEntities7 : DbContext
    {
        public ASIEntities7(EntityConnection cn) : base(cn, false) { }
    }
 
    
    class Program
    {
        
        static void Main(string[] args)
        {


            EntityConnection cn = new EntityConnection("name=ASIEntities7");

            var alnPedro = new Aluno { NumAl = 1001, Nome = "Pedro" };
            alnPedro.AlunosAssEsts = new HashSet<AlunosAssEst>();

            var alnPaula = new Aluno { NumAl = 1002, Nome = "Paula" };
            alnPaula.AlunosAssEsts = new HashSet<AlunosAssEst>();

            using (var ctx1 = new ASIEntities7(cn))
            {
                // em alternativa a usar o Sql Server Profiler, pode fazer:
                ctx1.Database.Log = Console.Write;

                //ctx.Database.Connection.Open();

                //ctx.Configuration.AutoDetectChangesEnabled = false;

                ctx1.Alunos.Add(alnPedro);
                ctx1.Alunos.Add(alnPaula);

                //ctx.ChangeTracker.DetectChanges();

                ctx1.SaveChanges();
            }

            using (var ctx2 = new ASIEntities7(cn))
            {
                // em alternativa a usar o Sql Server Profiler, pode fazer:
                ctx2.Database.Log = Console.Write;

                //ctx2.Configuration.AutoDetectChangesEnabled = false;

                var i1 = new AlunosAssEst { NumAl = 1002, Interesse = "i1" };
                var i2 = new AlunosAssEst { NumAl = 1002, Interesse = "i2" };

                alnPaula.AlunosAssEsts.Add(i1);
                alnPaula.AlunosAssEsts.Add(i2);
                ctx2.AlunosAssEsts.Add(i1);
                ctx2.AlunosAssEsts.Add(i2);

                //ctx2.ChangeTracker.DetectChanges();

                ctx2.SaveChanges(); 

            }

            using (var ctx3 = new ASIEntities7(cn))
            {
                // em alternativa a usar o Sql Server Profiler, pode fazer:
                ctx3.Database.Log = Console.Write;

                //ctx3.Configuration.AutoDetectChangesEnabled = false;

                ctx3.Alunos.Attach(alnPaula);

				//TODO: System.InvalidOperationException {"The object cannot be deleted because it was not found in the ObjectStateManager."}
                ctx3.Alunos.Remove(alnPaula); 
                
                ctx3.SaveChanges();

            }

            Console.WriteLine("Press any key to exit...");
            Console.ReadLine();
        }
    }
}
