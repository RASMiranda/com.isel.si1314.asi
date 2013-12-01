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

namespace Ex4
{
    public partial class ASIEntities7 : DbContext
    {
        public ASIEntities7(EntityConnection cn)
            : base(cn,false)
        {
        }
    }
    class Program
    {

        
        static void Main(string[] args)
        {

            using (var ts = new TransactionScope())
            {

                EntityConnection cn = new EntityConnection("name=ASIEntities7");
                using (var ctx = new ASIEntities7(cn))
                {
                    // em alternativa a usar o Sql Server Profiler, pode fazer:
                    ctx.Database.Log = Console.Write;

                    //Em EF 5:
                    //((IObjectContextAdapter)ctx).ObjectContext.Connection.Open(); 
                    ctx.Database.Connection.Open();
                    var al = (from a in ctx.Alunos
                              where a.NumAl == 1111
                              select a)
                                .First();


                    al.Nome = "xico";


                   
                    using (var ctx1 = new ASIEntities7(cn))
                    {
                        //Em EF5:
                        //((IObjectContextAdapter)ctx1).ObjectContext.Connection.Open(); 
                        //ctx1.Database.Connection.Open();
                        var al1 = (from a in ctx.Alunos
                                   where a.NumAl == 4444
                                   select a)
                                .First();
                        al1.Nome = "xxxx";

                        ctx1.SaveChanges();
                    }

                    ctx.SaveChanges();
                }
// ponto 1: observar no Sql Server Profiler
                ts.Complete();
            }
        }
    }
}
