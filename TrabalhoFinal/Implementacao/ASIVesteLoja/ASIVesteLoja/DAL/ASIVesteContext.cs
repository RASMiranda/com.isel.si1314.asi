using ASIVesteLoja.Models;
using System.Data.Entity;
using System.Data.Entity.ModelConfiguration.Conventions;

namespace ASIVesteLoja.DAL
{
    public class ASIVesteContext : DbContext
    {
        public DbSet<Produto> Produtos { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        }

        public DbSet<Venda> Vendas { get; set; }

        public DbSet<Reclamacao> Reclamacaos { get; set; }
     }
}
