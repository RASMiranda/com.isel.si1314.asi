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
        public ASIEntities7(EntityConnection cn)
            : base(cn, false)
        {
        }
    }
 
    
    class Program
    {
        
        static void Main(string[] args)
        {
            Main1(args);
        }

        static void Main1(string[] args)
        {


            EntityConnection cn = new EntityConnection("name=ASIEntities7");

            var al1 = new Aluno { NumAl = 1001, Nome = "Pedro" };
            al1.AlunosAssEsts = new HashSet<AlunosAssEst>();

            var al2 = new Aluno { NumAl = 1002, Nome = "Paula" };
            al2.AlunosAssEsts = new HashSet<AlunosAssEst>();

            using (var ctx = new ASIEntities7(cn))
            {
                // em alternativa a usar o Sql Server Profiler, pode fazer:
                ctx.Database.Log = Console.Write;

                ctx.Database.Connection.Open();

                ctx.Configuration.AutoDetectChangesEnabled = false;

                ctx.Alunos.Add(al1);
                ctx.Alunos.Add(al2);

                ctx.SaveChanges();
            }

            using (var ctx2 = new ASIEntities7(cn))
            {
                // em alternativa a usar o Sql Server Profiler, pode fazer:
                ctx2.Database.Log = Console.Write;

                ctx2.Configuration.AutoDetectChangesEnabled = false;

                var i1 = new AlunosAssEst { NumAl = 1002, Interesse = "i1" };
                var i2 = new AlunosAssEst { NumAl = 1002, Interesse = "i2" };

                //TODO: Correcto?
                al1.AlunosAssEsts.Add(i1);
                al1.AlunosAssEsts.Add(i2);
                ctx2.AlunosAssEsts.Add(i1);
                ctx2.AlunosAssEsts.Add(i2);

                ctx2.ChangeTracker.DetectChanges();

                ctx2.SaveChanges(); 

            }

            using (var ctx3 = new ASIEntities7(cn))
            {
                // em alternativa a usar o Sql Server Profiler, pode fazer:
                ctx3.Database.Log = Console.Write;

                ctx3.Configuration.AutoDetectChangesEnabled = false;

                ctx3.Alunos.Attach(al2);

				//TODO: System.InvalidOperationException {"The object cannot be deleted because it was not found in the ObjectStateManager."}
                ctx3.Alunos.Remove(al2); 
                
                ctx3.SaveChanges();

            }

            Console.WriteLine("Press any key to exit...");
            Console.ReadLine();
        }
    }
}
